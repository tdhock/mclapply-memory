works_with_R("3.2.2",
             "tdhock/memtime@309c9ecd47675c7ef5b33bcc5c64fa01d13d274c",
             "tdhock/ggplot2@a8b06ddb680acdcdbd927773b1011c562134e4d2")
library(parallel)

nothing.seq <- as.integer(seq(10, 1e5, l=20))

test.funs <- function(lapply.arg){
  memory.list <- list()
  for(i in seq_along(nothing.seq)){
    n.nothing <- nothing.seq[[i]]
    cat(sprintf("%4d / %4d sizes %d\n", i, length(nothing.seq), n.nothing))
    for(fun.name in c("mclapply", "lapply")){
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

mem.results.list <- list()
for(pfun.name in names(pfun.list)){
  pfun <- pfun.list[[pfun.name]]
  mem.result <- test.funs(pfun)
  mem.results.list[[pfun.name]] <-
    data.frame(pfun.name, mem.result)
}
mem.results <- do.call(rbind, mem.results.list)

p <- ggplot()+
  scale_y_continuous("megabytes used")+
  scale_x_continuous("length of first argument to (mc)?lapply")+
  geom_point(aes(n.nothing, kilobytes/1024, color=fun.name),
             pch=1,
             data=mem.results)+
  theme_bw()+
  theme(panel.margin=grid::unit(0, "cm"))+
  facet_grid(pfun.name ~ ., scales="free")

png("figure-megabytes-used.png")
print(p)
dev.off()
