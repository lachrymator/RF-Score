#!/usr/bin/env Rscript
d=read.table(file("stdin"),sep=",",header=F)
n=nrow(d)
rmse=sqrt(sum((d[1]-d[2])^2)/n)
sdev=summary(lm(V1~V2,d))$sigma
pcor=cor(d[1],d[2],method="pearson")
scor=cor(d[1],d[2],method="spearman")
kcor=cor(d[1],d[2],method="kendall")
cat(sprintf("n,rmse,sdev,pcor,scor,kcor\n%d,%.2f,%.2f,%.3f,%.3f,%.3f\n",n,rmse,sdev,pcor,scor,kcor))
