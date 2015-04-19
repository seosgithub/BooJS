![boojs: A ruby library for managing GitHub pull requests](https://raw.githubusercontent.com/sotownsend/boojs/master/logo.png)

[![Gem Version](https://badge.fury.io/rb/BooJS.svg)](http://badge.fury.io/rb/boojs)
[![Build Status](https://travis-ci.org/sotownsend/BooJS.svg?branch=master)](https://travis-ci.org/sotownsend/boojs)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/sotownsend/BooJS/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
[![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/sotownsend/BooJS/blob/master/LICENSE)

# What is this?
boojs was purpose built for Fittr® to provide information from our gocd server to our slack channel.  This is a standalone server that relays gocd information directly to slack.  **It is not a gocd plugin and relies on gocd's API for communication**.  Currently will monitor all pipelines for activity.

# What it looks like

###Failing will post a random fail gif
![Fail](https://raw.githubusercontent.com/sotownsend/boojs/master/fail.gif)

###Passing
![Pass](https://raw.githubusercontent.com/sotownsend/boojs/master/pass.gif)

###Cancelling
![Cancelled](https://raw.githubusercontent.com/sotownsend/boojs/master/cancelled.gif)

# What's gocd?
[Go | Continuous Deployment](http://www.go.cd/) is a free and open source deployment server.

# Installation
```sh
#Setup
gem install boojs

#Run using a service hook with the name 'bot_name' for the gocd server installed on localhost at 8513
#You *must* use http:// at the beginning for the gocd server host otherwise slack will *not* generate links
gocdss http://localhost:8153" https://hooks.slack.com/services/..." "bot_name"

#Or, optionally, you may add your username to the end
gocdss http://localhost:8153" https://hooks.slack.com/services/..." "bot_name" "username:pass"
```

# Usage
```sh
gocdss <gocd_hostname> <slack_hook_url> <bot_name> [<user>:<pass>]
```

## Requirements

- curl
- Ruby 2.1 or Higher

## Communication

- If you **found a bug**, submit a pull request.
- If you **have a feature request**, submit a pull request.
- If you **want to contribute**, submit a pull request.

---

## FAQ

### When should I use boojs?

When you want to announce to slack users what gocd is up to

### What's Fittr?

Fittr is a SaaS company that focuses on providing personalized workouts and health information to individuals and corporations through phenomenal interfaces and algorithmic data-collection and processing.

* * *

### Creator

- [Seo Townsend](http://github.com/sotownsend) ([@seotownsend](https://twitter.com/seotownsend))

## License

boojs is released under the MIT license. See LICENSE for details.
