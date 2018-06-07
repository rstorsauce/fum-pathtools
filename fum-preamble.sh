#!/bin/sh

################################################################################
# FUM CONTAINER PREAMBLE
# provides support for non-bindmounting deploys, such as command line and
# alfredo deployments
#
# the following execution parameters are supported:
#
# -i, --input         - override /input  as an input directory and take a file or archive as input
# -s, --script        - override /script as a script directory and take a file or archive as input
# -o, --output        - override /output as a result directory and store to an archive or file
#
# --force-zip-output  - forces the output to be stored as a zip file, in the case when only one file is output
#

home_dir=~
input_dir="/input"
script_dir="/script"
output_dir="/output"
force_zip_output="no"

while true; do
  case "$1" in
    -i | --input)  input_dir="$2"; shift; shift;;
    -s | --script) script_dir="$2"; shift; shift;;
    -o | --output) output_dir="$2"; shift; shift;;
    -h | --home)   home_dir="$2"; shift; shift;;
    "") break;;
    --force-zip-output) force_zip_output="yes"; shift;;
    *) shift;;
  esac
done

# unzip input and script

unpack(){
  uname=`mktemp -d`
  case `echo $1 | sed s/\.\*\\\.//` in
    zip) unzip "$1" -d "$uname";;
    gz)  tar -xf "$1" -C "$uname";;
    bz)  tar -xf "$1" -C "$uname";;
    *)   cp "$1" "$uname";;
  esac
}

cd ~

if [ ! -d "$input_dir" ]; then
  unpack "$input_dir"
  input_dir="$uname"
fi

if [ ! -d "$script_dir" ]; then
  unpack "$script_dir"
  script_dir="$uname"
fi

if [ ! "$output_dir" = "/output" ]; then
  usr_output="$output_dir"
  output_dir=`mktemp -d`
fi

export input_dir
export script_dir
export output_dir
export home_dir
export usr_output
export force_zip_output
