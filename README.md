# coffee
Buzz up your UNIX login.

## Requirements
Bash. And some other utilities commonly available on Linux.

## Installation
Source `etc/bashrc` from your bash startup script.  E.g.,

```
$ mkdir ~/coffee
$ cd ~/coffee
$ git clone https://github.com/markuskimius/coffee.git
$ echo 'source "${HOME}/coffee/coffee/etc/bashrc"' >> ~/.bashrc
```

## What does it do?
Installing coffee:

* Provides several scripts, functions, and libraries to bash.
* Sets the environment variable `$COFFEE` to coffee's _parent_ directory.
* Sets other environment variables:
  * Add `$COFFEE/*/bin` to `$PATH`
  * Add `$COFFEE/*/lib` to `$PYTHONPATH` that contain python scripts.
  * Add `$COFFEE/*/lib` to `$TCLLIBPATH` that contain pkgIndex.tcl.
* Sets up vim such that:
  * `$COFFEE/*/etc/vimrc` are automatically loaded.
  * `$COFFEE/*` vim plugins are automatically loaded.

The idea is to be able to unpack packages into `$COFFEE` to automatically set
it up for use in your UNIX environment.  In that spirit, `etc/bashrc` also
sources any `$COFFEE/*/etc/bashrc`.  This also means that you must be careful
to **only unpack trusted packages in `$COFFEE`.**

