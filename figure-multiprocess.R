works_with_R("3.2.2",
             "tdhock/ggplot2@a8b06ddb680acdcdbd927773b1011c562134e4d2")

load("multiprocess.RData")

p <- ggplot()+
  scale_y_continuous("megabytes used")+
  scale_x_continuous("length of second argument to map")+
  geom_point(aes(size, kilobytes/1024, color=fun.name),
             pch=1,
             data=multiprocess)+
  theme_bw()+
  theme(panel.margin=grid::unit(0, "cm"))+
  facet_grid(pfun.name ~ ., scales="free")

png("figure-multiprocess.png")
print(p)
dev.off()
