#!/bin/bash
set -o errexit
file=$1
rm -f $file $file.DONE
while [ ! -f "$file.DONE" ] ; do
  free -k >> $file
done
