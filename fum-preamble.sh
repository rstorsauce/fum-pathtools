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
# -h, --home          - override base home directory
#
# --force-zip-output  - forces the output to be stored as a zip file, in the case when only one file is output
#
#  METADATA           - return METADATA.  METADATA could be one of the following:
#                       - /script/.METADATA
#                       - /METADATA
#                       - empty object {}
#                       /METADATA should be a static json file, .METADATA if
#                       executable, should augment the /METADATA json and add
#                       further dependencies, outputting to standard out, or
#                       could be a static json file itself.


home_dir=~
input_dir="/input"
script_dir="/script"
output_dir="/output"
force_zip_output="no"

metadata(){
  if [ -f "$script_dir/.METADATA" ]; then
    if [ -x "$script_dir/.METADATA" ]; then
      "$script_dir/.METADATA"
    else
      cat "$script_dir/.METADATA"
    fi
  elif [ -f "/METADATA" ]; then
    cat "/METADATA"
  else
    echo "{}"
  fi
  exit
}

while true; do
  case "$1" in
    -i | --input)  input_dir="$2"; shift; shift;;
    -s | --script) script_dir="$2"; shift; shift;;
    -o | --output) output_dir="$2"; shift; shift;;
    -h | --home)   home_dir="$2"; shift; shift;;
    "") break;;
    --force-zip-output) force_zip_output="yes"; shift;;
    METADATA) metadata;;
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

if [ ! "$output_dir" = "/output" ] && [ ! "$output_dir" = "/output/output" ]; then
  usr_output="$output_dir"
  output_dir=`mktemp -d`
fi

export input_dir
export script_dir
export output_dir
export home_dir
export usr_output
export force_zip_output
