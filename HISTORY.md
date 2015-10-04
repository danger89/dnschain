###### 0.5.2 - March 11, 2015

- __Improvements:__
    + Includes tests for verifying NXT support
    + Added [`superagent`](https://github.com/visionmedia/superagent) for simpler HTTP requests
    + Moved `dnsHandler` into `blockchain.coffee` template class
    + Prevent `favicon.ico` requests from filling logs
    + Improved `Comparisons.md` documentation
    + Misc. code and logging improvements
- __Fixes:__
    + #138: Nxt resolver not working
    + #140: Prevent non-json values in Namecoin from returning "Not found"
    + #141: Allow arbitrary namecoin keys, but enforce ICANN domain rules for for `d/`
    + #142 + #120: Make it less likely Travis will fail

###### 0.5.1 - March 8th, 2015

- Bugfix: Exception `ReferenceError` on invalid Namecoin query (Closes #137)

###### 0.5.0 - March 7th, 2015

- __New Features:__
    + Basic [Openname Resolver RESTful API](docs/What-is-it.md#API) support!
    + Built-in HTTPS server that can route multiple services over the same IP and port thanks to [@SGrondin](https://github.com/SGrondin)
    + Automatically generates [4096-bit HTTPS key/certificate pair for you](docs/How-do-I-run-my-own.md#autogen)
    + Redis caching for *both* DNS and HTTP requests thanks to [@WeMeetAgain](https://github.com/WeMeetAgain)
    + Traffic throttling for *both* DNS and HTTP requests thanks to [@SGrondin](https://github.com/SGrondin)
    + **Super simple** to add any new blockchain to DNSChain thanks to major refactoring work by [@WeMeetAgain](https://github.com/WeMeetAgain)
    + NXT blockchain support thanks to [@toenu23](https://github.com/toenu23) (this means a `nxt.dns` metaTLD and `.nxt` TLD resolution)
    + Query DNS records over HTTPS using either [the new Openname API](docs/What-is-it.md#icann) or `icann.dns` metaTLD! (by [@WeMeetAgain](https://github.com/WeMeetAgain))
    + Ability to specify configuration file path for any supported blockchain via the dnschain configuration ([@WeMeetAgain](https://github.com/WeMeetAgain), again!)
    + RESTful API to fetch server fingerprint (Closes #44).
- __Improvements:__
    + Complete overhaul, refactoring, and improvement of the entire code base
    + Travic CI support
    + Comprehensive testing suite with complete code coverage for all critical files (excludes some error handlers and datasources)
    + Replaced a lot of callback code with Promises (still more to be done!)
    + All DNSChain components/servers are started and shutdown asynchronously (using Promise based API)
    + Precisely specified dependency versions to spare sysadmins any annoying surprises
    + Added badges for NPM version, Travis build status, and Gitter to top of README
    + All Namecoin data is now returned for HTTP(S) queries (`txid`, `expires_in`, etc.)
- __Documentation:__
    + [Comparisons](docs/Comparison.md) to __TACK__, __HPKP__, and __Thin Clients__
    + Numerous miscellaneous improvements to documentation
    + Updated Contributors list in README
    + Added badges for NPM version, Travis build status, and Gitter chat to top of README
    + This release includes the brand new documentation by [@mdw](https://twitter.com/mdw) and [@taoeffect](https://twitter.com/taoeffect)
- __Fixes:__
    + Closed #111: `TypeError` on startup on CentOS machines
    + Closed #90 and #87: Exception on access to unknown metaTLD

###### 0.2.5 - July 10, 2014

- Fixed `.bit` resolution bug introduced in `0.2.4`

###### 0.2.4 - July 10, 2014

- Fixed installation issue caused by `json-rpc2`
- Fixed exception (issue #20)
- Prevented possible DoS on in certain server setup where DNSChain
  is combined with another DNS server

###### 0.2.3 - May 27, 2014

- Updated native-dns module
- Fixed [#16](https://github.com/okTurtles/dnschain/issues/16) (unhandled exceptions). DNSSEC and other "unhandled" packets should be relayed now as a result.

###### 0.2.2 - May 3, 2014

- Corrected StackedSchedule scheduling
- Copied old release notes to HISTORY.md

###### 0.2.1 - May 2, 2014

_(NOTE: 0.2.1 is the same as 0.2.0, just forgot to bump NPM version.)_

- __New Features:__
    + oldDNSMethod config options should can now be specified as strings
      (and should be!)
    + new oldDNSMethod `NO_OLD_DNS_EVER` prevents resolution in oldDNS
      even if the blockchain specifies it be done.
      (see comments in `globals.coffee` for more info and options)
- __Improvements:__
    + Improved logging shows file and line number for all warnings
      and errors (and for some messages of other log levels too)
    + All injected globals now start with 'g' (except for module names)
    + Faster `.bit` resolution
    + Imporved overall code quality and readability
- __Fixes:__
    + Fixed #8 (exception on NS timeout)
    + Fixed #9 (return NXDOMAIN on bad 'ns' in *.bit)

###### 0.1.1 - April 24, 2014

- __Improvements:__
    + Some improved logging
- __Fixes:__
    + Issue resolving some `.bit` domains introduced in previous release
    + `ttl` for `.bit` domains is now equal to average block creation time
    + Outdated license string in `package.json`

###### 0.1.0 - April 24, 2014

- __New Features:__
    + DANE/TLSA support for *BOTH* canonical DNS and blockchain DNS!
    + Added `NO_OLD_DNS` option for `oldDNSMethod` (refuses all non-blockchain queries)
- __Improvements:__
    + Redesigned `dns.coffee` and improved its structure
    + Accurate `ttl` values now returned for namecoin DNS queries based on `expires_in` field
    + Updated contributors, code and config examples in `README.md`
    + Improved EDNS support
    + Improved handling of ANY queries
    + Updated dependencies to latest versions
    + `native-dns` is now fetched from the `dnschain` branch of [our fork](https://github.com/okTurtles/node-dns/tree/dnschain).
    + Comments added all over the place (to `native-dns` &amp; related projects also!)
    + Many other code improvements both to DNSChain and the NodeJS `native-dns` module
    + Some performance improvements
- __Fixes:__
    + Fixed broken `grunt example`
    + Fixed some uncaught exceptions (issues #1 and #2)
    + Fixed broken NAPTR support
- __Changes:__
    + DNSChain license is now MPL-2.0 (applies to version 0.1.0 onward)
    + Default logging level is now `info`

###### 0.0.2 - April 15, 2014

- Enabled [namespace syntax](https://github.com/gagle/node-properties#namespaces) for the config file
- Cherry-picked fix for `namecoinizeDomain` by @rakoo (thanks!)
- Added more public servers to README.md
- Added example systemd unit files for `namecoind` and `dnscrypt-wrapper` to scripts folder

###### 0.0.1 - February 9, 2014

- Published to `npm` under `dnschain`
