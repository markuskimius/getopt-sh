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

    for p in "${COFFEE}"/*/lib; do
        [[ -d "${p}" ]] || continue                           # Not a directory
        [[ ":${extra}:" == *":${p}:"* ]] && continue          # Already in $extra
        [[ ":${TCLLIBPATH-}:" == *":${p}:"* ]] && continue    # Already in $TCLLIBPATH
        ls "${p}"/pkgIndex.tcl &> /dev/null || continue       # No pkgIndex.tcl in the directory

        extra=${extra-}${extra+:}${p}
    done

    export TCLLIBPATH=${extra}${extra+${TCLLIBPATH+:}}${TCLLIBPATH-}
}

coffee::main "$@"


##############################################################################
# TEST CODE

if (( ${#BASH_SOURCE[@]} == 1 )); then
    function main() {
        echo "TCLLIBPATH=$TCLLIBPATH"
    }

    main "$@"
fi
