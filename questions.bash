#!/bin/bash
# Copyright 2020 Liudng. All rights reserved.
# Use of this source code is governed by Apache License
# that can be found in the LICENSE file.

# trace ERR through pipes
set -o pipefail

# set -e : exit the script if any statement returns a non-true return value
set -o errexit

# The dev package version
declare -gr dev_global_version="1.0.0"

# The dev execution file path
declare -gr dev_global_self="$(realpath $0)"

# The dev execution base path
declare -gr dev_global_base="$(dirname $(dirname $dev_global_self))"

cmd_body() {
    #
    # Write your code here.
    #
    echo "This is a sample bash script."
    echo "Custom arguments: $@"

    while read -r line; do
        echo $line
    done <<< "$(apropos -s 1 .)"
}

dev_kernel_help_usage() {
    echo "Usage: $(basename $dev_global_self) [--trace] [--verbose] [custom-arguments...]"
    echo "       $(basename $dev_global_self) [--help] [--version]"
    echo ""
    echo "Optional arguments:"
    echo "  --help             Help topic and usage information"
    echo "  --trace            Print command traces before executing command"
    echo "  --verbose          Produce more output about what the program does"
    echo "  --version          Output version information and exit"

    #
    # Append your custom help here.
    #
}

dev_kernel_optional_arguments() {
    case "$1" in
        --help)
            dev_kernel_help_usage
            exit 0
            ;;
        --version)
            echo "$dev_global_version" >&2
            exit 0
            ;;
        --trace)
            declare -gr dev_global_trace="1"
            ;;
        --verbose)
            declare -gr dev_global_verbose="1"
            ;;

        #
        # Add your custom optional arguments here.
        #

        *)
            echo "Optional argument not found: $1" >&2
            ;;
    esac
}

dev_main() {
    while [[ $# -gt 0 && "${1:0:1}" == "-" ]]; do
        dev_kernel_optional_arguments "$1"
        shift
    done

    [[ "$dev_global_trace" -eq "1" ]] && set -o xtrace
    cmd_body $@
}

dev_main $@
