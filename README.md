# Building MAF docker images

The overall order of operations is to build the lsst `stack` image,
and then use that as a base image to make a `MAF` iamge.

These instructions will assume you have clone this repository and it
is your current working directory.

### Building the `stack` image.

The `stack` images can be built from the `build_stack.sh` script
found in the `build_scripts` directory in this repo. Without any
command line options this script will build an image with the `name:tag`,
`maf:stack-YYYYMMDD`. The date information will automatically be filled in by script.
So if today is October, 4th 2018, running this script will produce a Docker image
called `maf:stack-20181004`

The `stack` Docker file includes doing a `newinstall` and `eups distrib install`
`lsst_sims`, so it will take quite a while to finish.

To build the stack imagerun the following command:

~~~
build_scripts/buil_stack.sh
~~~

When it is finished note the name and tag of the image because it is needed
for the `MAF`image.

### Building the `MAF` image.

After the `stack` image has finished building, open the `MAF` Docker file found
in `docker/maf`. You will need to edit the first line of this Docker file to
match the `stack` image you created in the previous step. Again, assuming today
is October, 4th 2018, the first line of this Docker file will need to be

~~~
FROM maf:stack-20181004
~~~

Once you have edited and saved the MAF docker file you are read to run
the `build_maf.sh` script.

~~~
build_scripts/buil_maf.sh
~~~

Without any command line options this script will build an image with the `name:tag`,`maf:YYYYMMDD`. So in the case of our date example this would be
`maf:20181004`.

This script will run much faster that the `build_stack.sh` script. The `MAF`
Docker file is just cloning `sims_maf` and installing `sims_movingObject`.

The docker image that results from `build_scripts/buil_maf.sh` is what you
will want to use when running MAF.

~~~
docker run -it maf:20181004
~~~

### Run the `run_all.py` batch in MAF

In the `bin` directory there is a script, that when mounted in a MAF docker image
will run `run_all.py` from MAF, and save the output to your local machine. For this
example we will assume we have a local directory called `maf_local` and in the directory
is a run directory and its run database.

~~~
mkdir maf_local
cd maf_local
mkdir -p pontus_2556/data
mv pontus_2556.db pontus_2556/data/pontus_2556 (or moved it from where ever you might have it)
~~~

Now you need to make sure that the `bin/setup_runall.sh` script is in the `maf_local`
directory, so if you did `ls` you would see the folowing:

~~~
pontus_2556/ setup_runall.sh
~~~

If this is all setup up correctly you can use a docker run command similar to this
to run the metrics in a non-interactive docker container. In this command replace
`/home/oboberg` with the full path to your `maf_local` directory and change `oboberg/maf:latest`
to the MAF docker image you would like to use.

~~~
docker run --rm -v /home/oboberg/maf_local/:/home/docmaf/maf_local \
                   oboberg/maf:latest \
                   /home/docmaf/maf_local/setup_runall.sh -r pontus_2556 &
~~~
