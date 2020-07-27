# getopt-sh
getopt wrapper for bash


## Why?

bash already has a few different getopt options, but each has a shortcoming:

* `getopts` builtin can only handle short options.
* `getopt` old binary, too, only handles short options.
* `getopt` enhanced binary can handle long options, but it requires running a
  few commands before and after that's not exactly intuitive to remember.

This library is a wrapper around the `getopt` enhanced binary to simplify using
long options in bash scripts.


## How to use

Here is a brief example:

```bash
while getopt-sh "ho:" "help,output:" "$@"; do
    case "$OPTOPT" in
        -h|--help)    usage          ;;
        -o|--output)  OUTPUT=$OPTARG ;;
        *)            iserror=1      ;;
    esac
done

INPUT=( "${OPTARRAY[@]}" )
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

[Apache 2.0]


[Apache 2.0]: <https://github.com/markuskimius/coffee/blob/master/LICENSE>

