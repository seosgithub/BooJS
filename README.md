![boojs: A unix tool to execute headless browser javascript](https://raw.githubusercontent.com/sotownsend/boojs/master/logo.png)

[![Gem Version](https://badge.fury.io/rb/BooJS.svg)](http://badge.fury.io/rb/boojs)
[![Build Status](https://travis-ci.org/sotownsend/BooJS.svg?branch=master)](https://travis-ci.org/sotownsend/boojs)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/sotownsend/BooJS/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
[![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/sotownsend/BooJS/blob/master/LICENSE)

<p align="center">
  <img src="https://raw.githubusercontent.com/sotownsend/boojs/master/usage.gif" />
</p>

# What is this?
**BooJS** allows you to execute javascript on the command line as if you were in a browser. It has well defined behavior that follows `unix` conventions and is built on-top of [PhantomJS](http://phantomjs.org/).

**BooJS** was purpose built for our continuous integration infrastructure at [Fittr®](http://www.fittr.com).

# Setup
```sh
#Setup
gem install boojs
```

# Usage
#### SYNOPSIS
```sh
boojs [-e statement] [-t timeout] [-v file] [file]
```

#### DESCRIPTION
The following options are available:
 * `-e` - Pass a javascript statement to execute after the file (if a file is provided) and then immediately terminate unless `-t` is set.
 * `-t` - Close the program after N seconds have passed, if an exception is raised before this, terminate immediately
 * `-v` - Verify that a file contains no javascript syntax errors. Returns 0 if there are no errors.

#### EXAMPLES
Open a javascript pipe that reads from stdin, writes via console.log to stdout, prints exceptions via stderr, and exits with a return code of 1 if there are errors.
```sh
(sh)>boojs
```

Same as `boojs` but read the javascript file before reading from stdin.  (i.e. preload a javascript file into your environment)
```sh
(sh)>boojs code.js
```

Execute a javascript statement, and then immediately exit. Exceptions will return 1.
```sh
(sh)>boojs -e "console.log(document);"
```

Execute a javascript statement, and then wait 4 seconds before exiting. Exceptions will return 1 and end execution early.
```sh
(sh)>boojs -e "console.log(document);" -t 4
```

Verify that a file contains no javascript runtime initialization errors
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

### Wait, isn't this just NodeJS?
No, they are for different things. BooJS gives you the full DOM, you can call `document` in BooJS and import arbitrary browser javascript libraries.

### ...But PhantomJS has a perfectly good REPL, kids these days...
There are a myriad issues with the *PhantomJS repl*; most notably, the *PhantomJS repl*:
  * Outputs special format characters even when not attached to a `tty`
  * Does not have well defined behavior which makes it a nightmare to integrate with
  * **Has no support for asynchronous stdin**
  * Is not a unix tool in any sense

I don't think any of this is the `PhantomJS`'s team fault; it's just not their focus or target.

### When should I use boojs?

When you need to test javascript code that needs to run in a browser but don't necessarily need to test the UI components.

### What's Fittr?

Fittr is a SaaS company that focuses on providing personalized workouts and health information to individuals and corporations through phenomenal interfaces and algorithmic data-collection and processing.

* * *

### Creator

- [Seo Townsend](http://github.com/sotownsend) ([@seotownsend](https://twitter.com/seotownsend))

## License

boojs is released under the MIT license. See LICENSE for details.
