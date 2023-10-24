#!/bin/bash

# Centralize all the logic about what versions to depend on in this one file

if [ $# != 1 ]
then
    echo Usage: dependencies QUALIFIER >&2
    exit 1
fi

QUAL=$1

if [[ $QUAL == *:n313* ]]; then NQUAL=n313; QUAL=${QUAL/:n313/}; fi
if [[ $QUAL == *:n315* ]]; then NQUAL=n315; QUAL=${QUAL/:n315/}; fi

WANTSTAN=yes
if [[ $QUAL == *:stanfree ]]; then WANTSTAN=no; QUAL=${QUAL/:stanfree/}; else QUAL=${QUAL/:stan/}; fi

if [[ $NQUAL == n313 ]]
then
    # These are the current (May 2023) nova versions (nutools v3_13_04b)
    echo root v6_22_08d -q${QUAL}:p392
    echo boost v1_75_0 -q$QUAL
else
    # These are the current (July 2023) sbn versions (nutools v3_15_03)
    echo root v6_26_06b -q${QUAL}:p3913
    echo boost v1_80_0 -q$QUAL
fi

echo eigen v3_4_0

if [ $WANTSTAN == yes ]
then
    echo stan_math v4_5_0a
    echo sundials v6_5_0
fi
