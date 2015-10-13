works_with_R("3.2.2",
             "tdhock/memtime@309c9ecd47675c7ef5b33bcc5c64fa01d13d274c")

library(parallel)

nothing.seq <- as.integer(seq(10, 1e5, l=20))

### Run mclapply inside of a for loop, ensuring that it never receives
### a first argument with a length more than maxjobs. This avoids some
### memory problems (swapping, or getting jobs killed on the cluster)
### when using mclapply(1:N, FUN) where N is large.
maxjobs.mclapply <- function(X, FUN, maxjobs=getOption("mc.cores", 1L)){
  maxjobs <- if(is.numeric(maxjobs) && length(maxjobs)==1){
    as.integer(maxjobs)
  }else{
    1L
  }
  if(maxjobs == 1L)return(lapply(X, FUN))
  N <- length(X)
  i.list <- splitIndices(N, N/maxjobs)
  result.list <- list()
  for(i in seq_along(i.list)){
    i.vec <- i.list[[i]]
    gc()
    result.list[i.vec] <- mclapply(X[i.vec], FUN)
    gc()
  }
  result.list
}

maxjobs.2cores <- function(...){
  options(mc.cores=2)
  maxjobs.mclapply(..., maxjobs=1000)
}

maxjobs.4cores <- function(...){
  options(mc.cores=4)
  maxjobs.mclapply(..., maxjobs=1000)
}

mclapply.2cores <- function(...){
  mclapply(..., mc.cores=2)
}

mclapply.4cores <- function(...){
  mclapply(..., mc.cores=4)
}

fun.name.vec <-
  c("maxjobs.2cores",
    "maxjobs.4cores",
    ##"maxjobs.1000",
    ##"mclapply",
    "mclapply.2cores",
    "mclapply.4cores",
    "lapply")

test.funs <- function(lapply.arg){
  memory.list <- list()
  for(i in seq_along(nothing.seq)){
    n.nothing <- nothing.seq[[i]]
    cat(sprintf("%4d / %4d sizes %d\n", i, length(nothing.seq), n.nothing))
    for(fun.name in fun.name.vec){
      LAPPLY <- get(fun.name)
      for(rep.num in 1:2){
        memtime.list <- memtime({
          result.list <- LAPPLY(1:n.nothing, lapply.arg)
        }, sleep.seconds=0.1)
        kilobytes <- memtime.list$memory["max.increase", "kilobytes"]
        memory.list[[paste(n.nothing, fun.name, rep.num)]] <-
          data.frame(rep.num, n.nothing, fun.name, kilobytes)
      }
    }
  }
  do.call(rbind, memory.list)
}

n.rows <- 100
df <- data.frame(i=1:n.rows, x=rnorm(n.rows))

pfun.list <- list(returnNULL=function(i){
  NULL
}, returnDF=function(i){
  df
})

kilobytes.used.list <- list()
for(pfun.name in names(pfun.list)){
  pfun <- pfun.list[[pfun.name]]
  mem.result <- test.funs(pfun)
  kilobytes.used.list[[pfun.name]] <-
    data.frame(pfun.name, mem.result)
}
kilobytes.used <- do.call(rbind, kilobytes.used.list)

save(kilobytes.used, file="kilobytes.used.RData")
