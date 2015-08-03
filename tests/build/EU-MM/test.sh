#!/bin/sh
cd ../../../module
rm -f Build
if ! perl Makefile.PL ; then
    echo "perl Makefile.PL failed" 1>&2
    exit 1
fi
if ! make ; then
    echo "make failed" 1>&2
    exit 1
fi
if ! make test ; then
    echo "make test failed" 1>&2
    exit 1
fi
