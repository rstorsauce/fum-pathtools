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

* ARCHITECTURE, INPUT, OUTPUT, SCRIPT

sends to stdout various requirements and specs of the container as a JSON array.
During the %post phase, corresponding files in the root directory (/) should
contain the responses.  A nonexistent files implies that matching requirements
is the responsibility of the user.
