![boojs: A unix tool to execute headless browser javascript](https://raw.githubusercontent.com/sotownsend/boojs/master/logo.png)

[![Gem Version](https://badge.fury.io/rb/BooJS.svg)](http://badge.fury.io/rb/boojs)
[![Build Status](https://travis-ci.org/sotownsend/BooJS.svg?branch=master)](https://travis-ci.org/sotownsend/boojs)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/sotownsend/BooJS/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
[![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/sotownsend/BooJS/blob/master/LICENSE)

# What is this?
A simple tool that allows you to execute javascript in the command line as if you were in a browser. Built on-top of [PhantomJS](phantomjs.org) and 
addresess it's shortcomings as a unix tool.

```sh
#Setup
gem install boojs
```

# Usage
```sh
boojs [-v file]
```

There are two modes of operating.


1. If you pass the `-v` flag with a file, boojs will `validate` the javascript file you passed. If it contains any syntax errors, or anything that would crash the execution of the javascript file, these are caught here. Useful for unit tests to make sure the JS files are executable. It will return 0 if the file and not 0 if otherwise

`boojs -v file_to_check.js`

2. If you do not pass the `-v` flag, boojs will accept JS input from stdin and emit JS output on stdout. If there is an exception, boojs 
will output the exception to stderr and return not 0. In all other cases, boojs will not exit and you must send SIGINT to the process.


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
