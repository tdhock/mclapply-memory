figure-kilobytes-used.png: figure-kilobytes-used.R kilobytes.used.RData
	R --no-save < $<
kilobytes.used.RData: kilobytes.used.R
	R --no-save < $<