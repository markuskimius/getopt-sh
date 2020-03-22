#!/bin/bash

##############################################################################
# COFFEE: Buzz up your UNIX login
# https://github.com/markuskimius/coffee
#
# Copyright (c)2020 Mark K. Kim
# Released under the Apache license 2.0
# https://github.com/markuskimius/coffee/blob/master/LICENSE
##############################################################################

# This script runs only in interactive mode
[[ "$-" == *i* ]] || return

alias vim='vim -u "${COFFEE}/coffee/etc/vimrc"'
