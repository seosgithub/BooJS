![boojs: A unix tool to execute headless browser javascript](https://raw.githubusercontent.com/sotownsend/boojs/master/logo.png)

[![Gem Version](https://badge.fury.io/rb/boojs.svg)](http://badge.fury.io/rb/boojs)
[![Build Status](https://travis-ci.org/sotownsend/BooJS.svg?branch=master)](https://travis-ci.org/sotownsend/BooJS)
[![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/sotownsend/BooJS/blob/master/LICENSE)

<p align="center">
  <img src="https://raw.githubusercontent.com/sotownsend/boojs/master/usage.gif" />
</p>

# What is this?
**BooJS** allows you to execute javascript on the command line as if you were in a browser. It has well defined behavior that follows `unix` conventions and is built on-top of [PhantomJS](http://phantomjs.org/).

# Setup
```js
#Setup
gem install boojs
```

# Usage
#### SYNOPSIS
```js
boojs [-e statement] [-t timeout] [-v file] [file]
```

#### DESCRIPTION
The following options are available:
 * `-e` - Pass a javascript statement to execute after the file (if a file is provided) and then immediately terminate unless `-t` is set.
 * `-t` - Close the program after N seconds have passed, if an exception is raised before this, terminate immediately
 * `-v` - Verify that a file contains no javascript syntax errors. Returns 0 if there are no errors.

#### EXAMPLES
Open a javascript pipe that reads from stdin, writes via console.log to stdout, prints exceptions via stderr, and exits with a return code of 1 if there are errors.
```js
(sh)>boojs
console.log("Hello world!");           //Output to $stdout
console.error("Goodbye cruel world!"); //Output to $stderr
```

Same as `boojs` but read the javascript file before reading from stdin.  (i.e. preload a javascript file into your environment)
```js
(sh)>boojs jquery.js
$("body").html("<h1>Hello</h1>");
console.log($("body").html())
```

Execute a javascript statement, and then immediately exit. Exceptions will return 1.
```js
(sh)>boojs -e "console.log(document);"
```

Execute a javascript statement, and then wait 4 seconds before exiting. Exceptions will return 1 and end execution early.
```js
(sh)>boojs -e "console.log(document);" -t 4
```

Verify that a file contains no javascript runtime initialization errors
```js
(sh)>boojs -v code.js
(sh)>echo $?
0
```


#### NOTES
  * Calling `booPing()` will immediately return `"pong"` to `stdout`. You may use this to know when boo has started up fully.
  * `console.error(msg)` will output to `$stderr`.  `console.log(msg)` will output to `$stdout`.

#### Local Storage Persistance
Every restart of boojs will cause `localStorage` to be reset. There is a bug where multiple instances of `boojs` will all *share* the same
instance of `localStorage`, so if you open multiple copies of boojs, you are guaranteed to delete `localStorage` of all boojs instances.
You may restart the boojs intsance without deleting local storage via sending `$__RESTART__` directly to `stdin` of the boojs instance as
it's own line. You may then wait for the reply `$__RESTART_OK__`. At this point, boojs will have restarted with a fresh instance except
that `localStorage` will still be intact.

**You must fully drain the `stdout` pipe of *boojs* before attempting to `$__RESTART__`. If you fail to do so, your commands may execute after
`$__RESTART__` has executed because `$__RESTART__` is executed asynchronously. You should send `booPing()`, wait for a reply of `pong`, and then
send the `$__RESTART__` command.

## Requirements

- Ruby 2.1 or Higher

## Communication

- If you **found a bug**, submit a pull request.
- If you **have a feature request**, submit a pull request.
- If you **want to contribute**, submit a pull request.

---

## FAQ & Rants

### Wait, isn't this just NodeJS?
No, they are for different things. BooJS gives you the full DOM, you can call `document` in BooJS and import arbitrary browser javascript libraries.

### ...But PhantomJS has a perfectly good REPL, kids these days...
There are a myriad issues with the *PhantomJS repl*; most notably, the *PhantomJS repl*:
  * Outputs special format characters even when not attached to a `tty`
  * Does not have well defined behavior which makes it a nightmare to integrate with
  * **Has no support for asynchronous stdin**
  * Does not output `console.error` to `stderr`
  * Changes what it considers a newline based on the attached terminal (A QT quirk)
  * Is not a unix tool in any sense
  * **Has no support for resetting local storage**

I don't think any of this is the `PhantomJS`'s team fault; it's just not their focus or target.

### When should I use boojs?
When you need to test javascript code that needs to run in a browser but don't necessarily need to test the UI components.

* * *

### Creator

- [So Townsend](http://github.com/sotownsend)

## License

boojs is released under the MIT license. See LICENSE for details.
