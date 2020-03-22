#!/bin/bash

##############################################################################
# COFFEE: Buzz up your UNIX login
# https://github.com/markuskimius/coffee
#
# Copyright (c)2020 Mark K. Kim
# Released under the Apache license 2.0
# https://github.com/markuskimius/coffee/blob/master/LICENSE
##############################################################################

function usage() {
    cat <<EOF
A skeleton program.

Usage: ${SCRIPTNAME} [OPTIONS] [FILES]

Options:
  FILE                  File(s) to read.

EOF
}


##############################################################################
# PROGRAM BEGINS HERE

include "getopt.sh"

SCRIPTNAME=$(basename "${BASH_SOURCE}")


function main() {
    local OPTOPT OPTARG OPTERR OPTARRAY
    local errcount=0
    local file

    # Process options
    while coffee::getopt "h" "help" "$@"; do
        case "$OPTOPT" in
            -h|--help)  usage && exit 0          ;;
            *)          errcount=$((errcount+1)) ;;
        esac
    done

    # Sanity check
    if (( errcount )); then
        echo "Type '${SCRIPTNAME} -h' for help." 1>&2
        exit 1
    fi

    for file in "${OPTARRAY[@]}"; do
        do_my_thing "$file"
    done
}


function do_my_thing() {
    local file=$1

    echo "$file"
}


##############################################################################
# ENTRY POINT

main "$@"

