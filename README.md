![boojs: A unix tool to execute headless browser javascript](https://raw.githubusercontent.com/sotownsend/boojs/master/logo.png)

[![Gem Version](https://badge.fury.io/rb/BooJS.svg)](http://badge.fury.io/rb/boojs)
[![Build Status](https://travis-ci.org/sotownsend/BooJS.svg?branch=master)](https://travis-ci.org/sotownsend/boojs)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/sotownsend/BooJS/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
[![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/sotownsend/BooJS/blob/master/LICENSE)

<p align="center">
  <img src="https://raw.githubusercontent.com/sotownsend/boojs/master/usage.gif" />
</p>

# What is this?
A simple tool that allows you to execute javascript in the command line as if you were in a browser. Built on-top of [PhantomJS](http://phantomjs.org/) and
acts as a well-behaved unix tool.

**Wait, isn't this just NodeJS? No, they are for different things. BooJS gives you the full DOM, you can call `document` in BooJS and import arbitrary browser javascript libraries.**

# Setup
```sh
#Setup
gem install boojs
```

# Usage
#### SYNOPSIS
```sh
boojs [-v file] [file]
```

#### DESCRIPTION
The following options are available:
 * `-v` - Verify that a file contains no javascript syntax errors. Returns 0 if there are no errors.

#### EXAMPLES
Open a standard headless javascript browser 'REPL'
```sh
(sh)>boojs
```

Execute a file first, then enter pipe mode (repl like)
```sh
(sh)>boojs code.js
```

Verify that a file contains no javascript errors
```sh
(sh)>boojs -v code.js
(sh)>echo $?
0
```

## Requirements

- Ruby 2.1 or Higher

## Communication

- If you **found a bug**, submit a pull request.
- If you **have a feature request**, submit a pull request.
- If you **want to contribute**, submit a pull request.

---

## FAQ

### When should I use boojs?

When you need to test javascript code that needs to run in a browser but don't necessarily need to test the UI components.

### What's Fittr?

Fittr is a SaaS company that focuses on providing personalized workouts and health information to individuals and corporations through phenomenal interfaces and algorithmic data-collection and processing.

* * *

### Creator

- [Seo Townsend](http://github.com/sotownsend) ([@seotownsend](https://twitter.com/seotownsend))

## License

boojs is released under the MIT license. See LICENSE for details.
