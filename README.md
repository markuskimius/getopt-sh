# getopt-sh
getopt wrapper for bash


## Why?

bash already has a few different getopt options, but each has a shortcoming:

* `getopts` builtin can only handle short options.
* `getopt` old binary, too, only handles short options.
* `getopt` enhanced binary can handle long options, but it requires running a
  few commands before and after that's not exactly intuitive to remember.

This library is a wrapper around the `getopt` enhanced binary to simplify using
long options in bash scripts.  It falls back to using `getopts` should the
enhanced `getopt` binary not available.


## How to use

Here is a brief example:

```bash
source "getopt-sh"

while getopt-sh "ho:" "help,output:" "$@"; do
    case "$OPTOPT" in
        -h|--help)    usage          ;;
        -o|--output)  OUTPUT=$OPTARG ;;
        *)            iserror=1      ;;
    esac
done

INPUT=( "${OPTARG[@]}" )
```

A similar example using the enhanced binary directly is:

```bash
optstring=$(getopt -o "ho:" --long "help,output:" -- "$@") || iserror=1
eval set -- "$optstring"

while (( $# )); do
    [[ "$1" == "--" ]] && shift && break

    case "$1" in
        -h|--help)    usage              ;;
        -o|--output)  OUTPUT=$2 && shift ;;
    esac

    shift
done

INPUT=( "$@" )
```

... which is a little less intuitive to read.


## License

[GPLv2]


[GPLv2]: <https://github.com/markuskimius/getopt-sh/blob/master/LICENSE>

