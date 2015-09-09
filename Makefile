figure-megabytes-used.png: figure-megabytes-used.R megabytes.used.RData
	R --no-save < $<
megabytes.used.RData: megabytes.used.R
	R --no-save < $<