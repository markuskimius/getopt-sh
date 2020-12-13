#!/bin/bash

##############################################################################
# getopt-sh: getopt wrapper for bash.
# https://github.com/markuskimius/getopt-sh
#
# Copyright (c)2020 Mark K. Kim
# Released under the Apache license 2.0
# https://github.com/markuskimius/getopt-sh/blob/master/LICENSE
##############################################################################

function getopt-sh() {
    local shortopts=$1
    local longopts=$2
    local isok=1
    local eof=0
    shift 2

    # Set up the positional parameters
    if [[ -z "${OPTARRAY[*]-}" ]]; then
        local optstring
        
        optstring=$(\getopt -o "$shortopts" --long "$longopts" -- "$@") || isok=0
        eval set -- "$optstring"

        # Save the positional parameters
        OPTARRAY=( "$@" )
    fi

    # Next option
    (( $isok )) && OPTOPT=${OPTARRAY[0]} && OPTARRAY=( "${OPTARRAY[@]:1}" ) || OPTOPT=?
    OPTARG=""

    # Has argument?
    case "$OPTOPT" in
        --)  # End of parameters
             OPTOPT=-1
             eof=1
             ;;

        -?)  # Short option
             if [[ "$shortopts" == *"${OPTOPT#-}:"* ]]; then
                 OPTARG=${OPTARRAY[0]} && OPTARRAY=( "${OPTARRAY[@]:1}" )
             fi
             ;;

        --*) # Long option
             if [[ ",$longopts" == *,"${OPTOPT#--}:"* ]]; then
                 OPTARG=${OPTARRAY[0]} && OPTARRAY=( "${OPTARRAY[@]:1}" )
             fi
             ;;

        *)   # Bad option -- We shouldn't get here
             OPTOPT=?
             ;;
    esac

    (( ! eof ))
}


##############################################################################
# TEST CODE

if (( ${#BASH_SOURCE[@]} == 1 )); then
    function main() {
        local OPTOPT OPTARG OPTARRAY

        while getopt-sh "ho:" "help,output:" "$@"; do
            echo "${OPTOPT}=${OPTARG}"
        done

        echo "args=${OPTARRAY[@]}"
    }

    main "$@"
fi
