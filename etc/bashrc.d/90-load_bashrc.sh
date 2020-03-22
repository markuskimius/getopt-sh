#!/bin/bash

##############################################################################
# COFFEE: Buzz up your UNIX login
# https://github.com/markuskimius/coffee
#
# Copyright (c)2020 Mark K. Kim
# Released under the Apache license 2.0
# https://github.com/markuskimius/coffee/blob/master/LICENSE
##############################################################################

function coffee::main() {
    declare file

    for file in "${COFFEE}"/*/etc/bashrc; do
        if ! [[ "$file" -ef "${COFFEE}/coffee/etc/bashrc" ]]; then
            coffee::include "$file"
        fi
    done
}

coffee::main "$@"


##############################################################################
# TEST CODE

if (( ${#BASH_SOURCE[@]} == 1 )); then
    include "getopt.sh"
    include "getopt.sh"

    function main() {
        echo "__COFFEE_INCLUDED=$__COFFEE_INCLUDED"
    }

    main "$@"
fi
