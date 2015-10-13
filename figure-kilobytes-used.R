works_with_R("3.2.2",
             "tdhock/ggplot2@a8b06ddb680acdcdbd927773b1011c562134e4d2")

load("kilobytes.used.RData")

p <- ggplot()+
  scale_y_continuous("megabytes used")+
  scale_x_continuous("length of first argument to (mc)?lapply")+
  geom_point(aes(n.nothing, kilobytes/1024, color=fun.name),
             pch=1,
             data=kilobytes.used)+
  theme_bw()+
  theme(panel.margin=grid::unit(0, "cm"))+
  facet_grid(pfun.name ~ ., scales="free")

png("figure-kilobytes-used.png")
print(p)
dev.off()
