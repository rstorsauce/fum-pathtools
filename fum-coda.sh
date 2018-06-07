#!/bin/sh

################################################################################
# FUM CONTAINER CODA
#
# provides support for non-bindmounting deploys, such as command line and
# alfredo deployments
#
# depends on output_dir and force_zip_output shell variables
#
# only takes action if a custom output is specified

# zip the output directory for packaging as an object.

if [ ! "$output_dir" = "/output" ]; then

  filecount=`ls $output_dir | wc -l`

  cd "$output_dir"
  if [ "$filecount" -eq 1 ] && [ "$force_zip_output" = "no" ]; then
    cp * "$home_dir"
  else
    zip -r "$home_dir/$usr_output.zip" .
  fi
fi
