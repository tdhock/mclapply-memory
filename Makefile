figure-multiprocess.png: figure-multiprocess.R multiprocess.RData
	R --no-save < $<
multiprocess.RData: multiprocess.R
	R --no-save < $<
figure-kilobytes-used.png: figure-kilobytes-used.R kilobytes.used.RData
	R --no-save < $<
kilobytes.used.RData: kilobytes.used.R
	R --no-save < $<
