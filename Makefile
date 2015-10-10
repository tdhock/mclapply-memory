figure-multiprocess.png: figure-multiprocess.R multiprocess.RData
	R --no-save < $<
multiprocess.RData: multiprocess.R
	R --no-save < $<
figure-megabytes-used.png: figure-megabytes-used.R
	R --no-save < $<
