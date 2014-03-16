#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
d=read.csv(args[1])
r=lm(pbindaff~predicted,d)
c=coefficients(r)
d["regressed"]=c[1]+c[2]*d["predicted"]
n=nrow(d) # Number of samples.
se=sum((d["regressed"] - d["pbindaff"])^2) # Square error.
rmse=sqrt(se/n)
sdev=sqrt(se/(n-1))
pcor=cor(d["regressed"], d["pbindaff"], method="pearson")
scor=cor(d["regressed"], d["pbindaff"], method="spearman")
kcor=cor(d["regressed"], d["pbindaff"], method="kendall")
cat(sprintf("n,rmse,sdev,pcor,scor,kcor\n%d,%.3f,%.3f,%.3f,%.3f,%.3f\n", n, rmse, sdev, pcor, scor, kcor))
