#!/bin/bash

#!/bin/sh

usage() {
  cat << EOD

  Usage: $(basename "$0") [options]

  Run run_all.py

  Available options:
    -h          this message
    -r          OpSim runName

EOD
}

# get the options
while getopts hr: c; do
    case $c in
            h) usage ; exit 0 ;;
            r) RUNNAME="$OPTARG" ;;
            \?) usage ; exit 2 ;;
    esac
done

if [ -z "$RUNNAME" ]; then
    echo "You must provide a run name"
    exit 1
fi

source scl_source enable devtoolset-6; source /home/docmaf/stack/loadLSST.bash

cd /home/docmaf/repos/sims_maf
git pull
setup sims_maf git
scons
echo "Running the following: run_all.py --runName $RUNNAME --outDir /home/docmaf/maf_local/$RUNNAME/all /home/docmaf/maf_local/$RUNNAME/data/$RUNNAME.db"
run_all.py --runName $RUNNAME --outDir /home/docmaf/maf_local/$RUNNAME/all /home/docmaf/maf_local/$RUNNAME/data/$RUNNAME.db
