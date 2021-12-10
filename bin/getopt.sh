##############################################################################
# getopt-sh: getopt wrapper for bash.
# https://github.com/markuskimius/getopt-sh
#
# Copyright (c)2020-2021 Mark K. Kim
# Released under GNU General Public License version 2.
# https://github.com/markuskimius/getopt-sh/blob/master/LICENSE
##############################################################################

function getopt-sh() {
    local shortopts=$1 && shift
    local longopts=$1 && shift
    local eof=0

    # Set up the positional parameters
    if [[ -z "${OPTOPT-}" ]]; then
        local optstring

        optstring=$(
            #
            # Use GNU "getopt" if available, otherwise fall back to "getopts" built-in.
            # GNU gives us long options but it's not always available.
            #

            if command -v getopt >/dev/null && getopt -T >/dev/null; (( $? == 4 )); then
                getopt -o "$shortopts" --long "$longopts" -- "$@"
            else
                local OPTARG OPTERR OPTIND opt
                local output=()
                local isok=1

                while getopts "$shortopts" opt; do
                    output+=( "-${opt}" )
                    [[ "$shortopts" == *"${opt}:"* ]] && output+=( "$OPTARG" )
                    [[ "$shortopts" != *"${opt}"* ]] && isok=0
                done
                shift $(( OPTIND - 1 ))

                printf " %q" "${output[@]}" -- "$@"
                printf "\n"

                (( isok ))
            fi
        ) || eof=1

        eval set -- "$optstring"

        # Save the positional parameters
        OPTARG=( "" "$@" )
    fi

    # Next option
    if [[ "$OPTOPT" != "--" ]]; then

        #
        # OPTARG[0] contains the argument to the last option, so the next
        # option is OPTARG[1].  Also, we initially assume the option (if it is
        # an option) has no argument so we set OPTARG[0] to blank.
        #

        OPTOPT=${OPTARG[1]-"--"}

        if [[ "$OPTOPT" == "--" ]]; then
            OPTARG=( "${OPTARG[@]:2}" )
        else
            OPTARG=( "" "${OPTARG[@]:2}" )
        fi
    fi

    # Has argument?
    case "$OPTOPT" in
        --)     # End of parameters
                eof=1
                ;;

        -?)     # Short option
                if [[ "$shortopts" == *"${OPTOPT#-}:"* ]]; then
                    OPTARG=( "${OPTARG[@]:1}" )
                fi
                ;;

        --*)    # Long option
                if [[ ",$longopts" == *,"${OPTOPT#--}:"* ]]; then
                    OPTARG=( "${OPTARG[@]:1}" )
                fi
                ;;

        *)      # Bad option -- We shouldn't get here
                eof=1
                ;;
    esac

    (( ! eof ))
}


##############################################################################
# TEST CODE

if (( ${#BASH_SOURCE[@]} == 1 )); then
    function main() {
        local OPTOPT OPTARG

        while getopt-sh "ho:" "help,output:" "$@"; do
            echo "${OPTOPT}=${OPTARG}"
        done

        echo "args=${OPTARG[@]}"
    }

    main "$@"
fi


# vim:ft=bash
