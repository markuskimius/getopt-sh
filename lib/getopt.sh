#!/bin/bash

##############################################################################
# getopt-sh: getopt wrapper for bash.
# https://github.com/markuskimius/getopt-sh
#
# Copyright (c)2020-2021 Mark K. Kim
# Released under the Apache license 2.0
# https://github.com/markuskimius/getopt-sh/blob/master/LICENSE
##############################################################################

function getopt-sh() {

    #
    # getopt-sh() is really just a wrapper around the getopt binary.  We prefer
    # the enhanced getopt binary which can handle long options, but we also
    # want to be compatible with the old getopts built-in function which can't
    # handle long options (the caller will be able to use only short options
    # with getopt-sh().)
    #
    # To be able to use either versions of getopt, we test to see which binary
    # is installed.  This test can be performed by calling `getopt -T` which
    # returns `4` for the enhanced getopt, 0 for the old getopt.  Once we know
    # which version is installed, we redefine getopt-sh() function so that
    # subsequent calls to getopt-sh() calls the appropriate function directly
    # without re-running the test.
    #

    # Test getopt version
    if getopt -T >&/dev/null; (( $? == 4 )); then
        # Enhanced getopt
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
                     OPTOPT=""
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
    else
        # Old getopt
        function getopt-sh() {
            local shortopts=$1
            local longopts=$2
            shift 2

            # Preparse the positional parameters, save to OPTARRAY
            if [[ -z "${OPTARRAY[*]-}" ]]; then
                local OPTIND

                OPTARRAY=()

                while getopts "$shortopts" OPTOPT; do
                    [[ "$shortopts" == *"${OPTOPT}"* ]] && OPTOPT="-${OPTOPT}"

                    OPTARRAY+=( "$OPTOPT" "$OPTARG" )
                done
                shift $((OPTIND - 1))

                OPTARRAY+=( "" "" "$@" )
            fi

            # Next option
            OPTOPT=${OPTARRAY[0]} && OPTARG=${OPTARRAY[1]} && OPTARRAY=( "${OPTARRAY[@]:2}" )

            [[ -n "$OPTOPT" ]]
        }
    fi

    # Finally, call the newly instantiated getopt-sh() on the initial call
    getopt-sh "$@"
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
