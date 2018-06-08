# fum-pathtools
tools for fum path substitution

these tools implement substitution of fum input/script/output.  In some cases,
bindmounting a container with the appropriate /input, /script, and /output
directories may not be permitted due to IT restrictions.  fum-pathtools should
*generally* be included in a fum-container and implements container runscript
parameter checking enabling command-line substitution of these directories.

## USING THIS REPO

### When building a container def file

    %runscript

    . path/to/scripts/fum-preamble.sh

    ...
    < normal runscript code using $input_dir, $script_dir, $output_dir variables >
    ...

    path/to/scripts/fum-coda.sh


### When running a container (typical usage)


    path/to/container -i <input_dir> -s <script_dir> -o <desired_output_name>


you may also use long parameters --input, --script, and --output.


### other key parameters

* --force-zip-output

By default, a container outputting a single file into its output directory
will place it into the home directory; you can change this behavior and force it
into a zip file instead by using this parameter.

* -h <home_dir>

Sometimes IT will force singularity container to be run in "contained" mode,
with a separate directory issued as a storage plane; you may override the use of
the home directory for these purposes by using this parameter.  You may also 
use the long parameter --home

* REQUIREMENTS

outputs the requirements of the container as a JSON array.  During the %post
phase, the file /REQUIREMENTS should be created which contains this JSON array.  A nonexistent REQUIREMENTS file implies that there are no requirements and the
container should run on almost any platform
