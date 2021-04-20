#!/bin/bash

set +ex
env

if [[ $QUALIFIER != *:n308* && $QUALIFIER != *:n309* ]]
then
    echo Unspecified nutools version in qualifier $QUALIFIER -- must be n308 or n309
    exit 1
fi

if [[ $QUALIFIER != *e19* && $QUALIFIER != *e20* && $QUALIFIER != *c7* ]]
then
    echo Unknown compiler in qualifier $QUALIFIER -- must be e19, e20, or c7
    exit 1
fi

if [[ $QUALIFIER != *debug* && $QUALIFIER != *prof* ]]
then
    echo Unknown optimization level in qualifier $QUALIFIER -- must be debug or prof
    exit 1
fi

if [[ x$STAN != *stan* ]]
then
    echo Must specify stan or stanfree in STAN variable $STAN
    exit 1
fi

if [[ $EXPERIMENT == *n308* ]]
then
    source /cvmfs/nova.opensciencegrid.org/externals/setup || exit 1
else
    source /cvmfs/dune.opensciencegrid.org/products/dune/setup_dune.sh || exit 1
fi


# Looping over lines is a total pain in bash. Easier to just send it to a file
TMPFILE=`mktemp`
# Expect to be run in the directory one above....
jenkins/dependencies.sh $QUALIFIER:$STAN | sed 's/^/setup /' > $TMPFILE
cat $TMPFILE
source $TMPFILE


make clean # don't trust my build system
time make -j || exit 2


mkdir -p OscLib/ups
jenkins/make_table.sh > OscLib/ups/osclib.table
