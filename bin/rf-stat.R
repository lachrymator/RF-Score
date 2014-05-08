#!/usr/bin/env Rscript
d=read.csv(file("stdin"))
n=nrow(d)
rmse=sqrt(sum((d["pbindaff"]-d["predicted"])^2)/n)
sdev=summary(lm(pbindaff~predicted,d))$sigma
pcor=cor(d["pbindaff"],d["predicted"],method="pearson")
scor=cor(d["pbindaff"],d["predicted"],method="spearman")
kcor=cor(d["pbindaff"],d["predicted"],method="kendall")
cat(sprintf("n,rmse,sdev,pcor,scor,kcor\n%d,%.2f,%.2f,%.3f,%.3f,%.3f\n",n,rmse,sdev,pcor,scor,kcor))
