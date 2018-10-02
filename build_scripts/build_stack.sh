#!/bin/sh

DATE=`date +%Y%m%d`
# Update the default hub to match your docker hub account and repo
# e.g user_name/repo_name
DEFAULT_HUB='maf'

usage() {
  cat << EOD

  Usage: $(basename "$0") [options]

  This command builds a base image which includes only stack prerequisites.

  Available options:
    -h          this message
    -t          Tag name. Defaults to $DEFAULT_TAG
    -r          Docker hub repo: Defaults to $DEFAULT_HUB

EOD
}

# get the options
while getopts h:t:r: c; do
    case $c in
            h) usage ; exit 0 ;;
            t) TAG="$OPTARG" ;;
            r) DOCKERHUB="$OPTARG" ;;
            \?) usage ; exit 2 ;;
    esac
done

shift "$((OPTIND-1))"

if [ $# -ne 0 ] ; then
    usage
    exit 2
fi

if [ -z $DOCKERHUB ]  ; then
    # Use default docker hub repo
    DOCKERHUB=$DEFAULT_HUB
fi

if [ -z $TAG ]  ; then
    # Use default tag
    TAG=$DOCKERHUB:'stack'-$DATE
else
    TAG=$DOCKERHUB:$TAG
fi

# Build the stack image

printf "Building MAF stack image with tag: %s\n" $TAG
docker build  --tag="$TAG" docker/maf
