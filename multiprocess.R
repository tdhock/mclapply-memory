works_with_R("3.2.2", data.table="1.9.6",
             "tdhock/namedCapture@6ed1257fa0d5c985931de24c3516a0f32a9323cf")

pattern <- paste0(
  "(?<trial>[0-9]+)",
  "/",
  "(?<size>[0-9]+)",
  "-",
  "(?<height>1|100)",
  "-",
  "(?<cores>[0-9])",
  "(?<maxjobs>maxjobs)?")
out.file.vec <- Sys.glob("multiprocess-data/*/*")
match.mat <- str_match_named(out.file.vec, pattern)
match.df <-
  data.frame(fun.name=ifelse(match.mat[, "cores"]==1, "map",
               ifelse(match.mat[, "maxjobs"]=="maxjobs", "maxjobs_map",
                      "Pool.map")),
             trial=match.mat[, "trial"],
             cores=as.numeric(match.mat[, "cores"]),
             pfun.name=ifelse(match.mat[, "height"]==1, "returnNone", "returnList"),
             size=as.numeric(match.mat[, "size"]))

firstValue <- function(txt){
  value <- sub(".*? ([0-9]+) .*", "\\1", txt)
  as.numeric(value)
}

increase.list <- list()
for(file.i in seq_along(out.file.vec)){
  out.file <- out.file.vec[[file.i]]
  match.row <- match.df[file.i,]
  free.lines <- readLines(out.file)
  used.lines <- grep("-/+", free.lines, value=TRUE)
  used.values <- firstValue(used.lines)
  first <- used.values[1]
  max.mem <- max(used.values)
  kilobytes <- 
    c(first.used=first,
      max.used=max.mem,
      last.used=used.values[length(used.values)],
      max.increase=max.mem-first,
      total=firstValue(free.lines[2]))
  megabytes <- as.integer(kilobytes/1024)
  increase.list[[file.i]] <- 
    data.frame(match.row,kilobytes=kilobytes[["max.increase"]])
}
multiprocess <- do.call(rbind, increase.list)

save(multiprocess, file="multiprocess.RData")
