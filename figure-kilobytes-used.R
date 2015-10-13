works_with_R("3.2.2",
             "tdhock/ggplot2@a8b06ddb680acdcdbd927773b1011c562134e4d2")

load("kilobytes.used.RData")
kilobytes.used$fun.fac <-
  factor(sub("[.].*", "", kilobytes.used$fun.name),
         c("mclapply", "maxjobs", "lapply"))
kilobytes.used$cores.fac <-
  factor(gsub("[^0-9]", "", kilobytes.used$fun.name),
         c("4", "2", ""), c("4", "2", "1"))

p <- ggplot()+
  scale_y_continuous("megabytes used")+
  scale_x_continuous("length of first argument to (mc)?lapply")+
  ## geom_point(aes(n.nothing, kilobytes/1024, color=fun.name),
  ##            pch=1,
  ##            data=kilobytes.used)+
  geom_line(aes(n.nothing, kilobytes/1024,
                group=interaction(rep.num, fun.fac, cores.fac),
                linetype=fun.fac,
                color=cores.fac),
            pch=1,
            data=kilobytes.used)+
  scale_color_discrete("cores")+
  scale_linetype_manual("function", values=c(lapply="dotted",
                          mclapply="solid", maxjobs="dashed"))+
  theme_bw()+
  theme(panel.margin=grid::unit(0, "cm"))+
  facet_grid(pfun.name ~ ., scales="free")

png("figure-kilobytes-used.png")
print(p)
dev.off()
