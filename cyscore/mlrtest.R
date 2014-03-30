#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
ntrn=args[1]
ntst=args[2]
c=read.csv(sprintf("trn-%s-coef.csv",ntrn))[,2]
d=read.csv(sprintf("../tst-%s-yxi.csv",ntst))
d["predicted"]=c[2]*d[2]+c[3]*d[3]+c[4]*d[4]+c[5]*d[5]
d["regressed"]=fitted(lm(pbindaff~predicted,d))
write.csv(c(d["PDB"],d["pbindaff"],d["predicted"],d["regressed"]),row.names=F,quote=F,file=sprintf("trn-%s-tst-%s-iypr.csv",ntrn,ntst))
n=nrow(d)
se=sum((d["regressed"] - d["pbindaff"])^2)
rmse=sqrt(se/n)
sdev=sqrt(se/(n-2))
pcor=cor(d["regressed"], d["pbindaff"], method="pearson")
scor=cor(d["regressed"], d["pbindaff"], method="spearman")
kcor=cor(d["regressed"], d["pbindaff"], method="kendall")
cat(sprintf("n,rmse,sdev,pcor,scor,kcor\n%d,%.3f,%.3f,%.3f,%.3f,%.3f\n", n, rmse, sdev, pcor, scor, kcor),file=sprintf("trn-%s-tst-%s-stat.csv",ntrn,ntst))
