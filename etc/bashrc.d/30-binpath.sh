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
    declare extra
    declare p

    for p in "${COFFEE}"/*/bin; do
        if [[ -d "$p" ]] && [[ ":${extra}${extra+${PATH+:}}${PATH-}:" != *":${p}:"* ]]; then
            extra=${extra-}${extra+:}${p}
        fi
    done

    export PATH=${extra}${extra+${PATH+:}}${PATH-}
}

coffee::main "$@"


##############################################################################
# TEST CODE

if (( ${#BASH_SOURCE[@]} == 1 )); then
    function main() {
        echo "PATH=$PATH"
    }

    main "$@"
fi
