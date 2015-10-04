###

dnschain
http://dnschain.net

Copyright (c) 2014 okTurtles Foundation

This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.

###

# we don't 'use strict' because i really want to be able to use 'eval' to declare variables

# expose global dependencies, functions, and constants into our namespace
for k of require('./globals')(exports)
    eval "var #{k} = exports.globals.#{k};"

exports.createServer = (a...) -> new DNSChain a...

DNSServer = require('./dns')(exports)
HTTPServer = require('./http')(exports)
EncryptedServer = require('./https')(exports)
ResolverCache = require('./cache')(exports)

localhosts = ->
    _.uniq [
        "127.0.0.", "10.0.0.", "192.168.", "::1", "fe80::"
        gConf.get('dns:host'), gConf.get('http:host')
        gConf.get('dns:externalIP'), gExternalIP()
        _.map(gConf.chains, (c) -> c.get('host'))...
    ].filter (o)-> typeof(o) is 'string'

exports.DNSChain = class DNSChain
    constructor: ->
        @log = gNewLogger 'DNSChain'
        chainDir = path.join __dirname, 'blockchains'
        @chains = _.omit(_.mapValues(_.indexBy(fs.readdirSync(chainDir), (file) =>
            S(file).chompRight('.coffee').s
        ), (file) =>
            chain = new (require('./blockchains/'+file)(exports)) @
            chain.config()
        ), (chain) =>
            not chain
        )
        @chainsTLDs = _.indexBy _.compact(_.map(@chains, (chain) ->
            chain if chain.tld?
        )), 'tld'
        gConf.localhosts = localhosts.call @
        @dns = new DNSServer @
        @http = new HTTPServer @
        @encryptedserver = new EncryptedServer @
        @cache = new ResolverCache @
        # ordered this way to start all external facing servers last
        @servers = _.values(@chains).concat [@cache, @http, @encryptedserver, @dns]
        gFillWithRunningChecks @

    start: ->
        @startCheck (cb) =>
            Promise.all(@servers.map (s)-> s.start()).then =>
                [host, port] = ['dns:externalIP', 'dns:port'].map (x)-> gConf.get x
                @log.info "DNSChain started and advertising DNS on: #{host}:#{port}"

                if process.getuid() isnt 0 and port isnt 53 and require('tty').isatty process.stdout
                    @log.warn "DNS port isn't 53!".bold.red, "While testing you should either run me as root or make sure to set standard ports in the configuration!".bold
                cb null
            .catch (e) -> cb e
        .catch (e) =>
            @log.error "DNSChain failed to start:", e.stack
            @shutdown()
            throw e # re-throw to indicate that this promise failed

    shutdown: ->
        @shutdownCheck (cb) =>
            # shutdown servers in the opposite order they were started
            reversedServers = @servers[..].reverse()
            Promise.settle reversedServers.map (s, idx) =>
                name = s?.name || s?.log?.transports.console?.label
                @log.debug "Shutting down server at idx:#{idx}: #{name}"
                s?.shutdown()
            .then -> cb null
            .catch (e) -> cb e
