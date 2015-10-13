#!/bin/bash
set -o errexit
DATA_DIR="multiprocess-data/$(date +%s)"
mkdir -p $DATA_DIR
# seq from R: as.integer(seq(10, 1e5, l=20))
for width in 10   5272  10535  15797  21060  26323  31585  36848  42111  47373 52636  57898  63161  68424  73686  78949  84212  89474  94737 100000; do
    for height in 1 100; do
	for cores in 2maxjobs 1 2 4 4maxjobs; do
	    echo width=$width height=$height cores=$cores
	    file=$DATA_DIR/$width-$height-$cores
	    bash free.sh $file &
	    sleep 1
	    time python multiprocess.py $width $height $cores
	    sleep 1
	    touch $file.DONE
	    sleep 1
	    rm $file.DONE
	done
    done
done
