#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
trn=args[1]
tst=args[2]
d=read.csv(sprintf("trn-%s-tst-%s-iyp.csv",trn,tst))
n=nrow(d) # Number of samples.
xylim=c(0,14)
rmse=sqrt(sum((d["predicted"] - d["pbindaff"])^2)/n)
sdev=summary(lm(pbindaff~predicted,d))$sigma
pcor=cor(d["predicted"], d["pbindaff"], method="pearson")
scor=cor(d["predicted"], d["pbindaff"], method="spearman")
kcor=cor(d["predicted"], d["pbindaff"], method="kendall")
cat(sprintf("n,rmse,sdev,pcor,scor,kcor\n%d,%.3f,%.3f,%.3f,%.3f,%.3f\n", n, rmse, sdev, pcor, scor, kcor), file=sprintf("trn-%s-tst-%s-stat.csv",trn,tst))
setEPS()
postscript(sprintf("trn-%s-tst-%s-yp.eps",trn,tst))
par(cex.lab=1.5,cex.axis=1.5,cex.main=1.5)
plot(d[,"pbindaff"], d[,"predicted"], xlim=xylim, ylim=xylim, xlab="Measured binding affinity (pKd)", ylab="Predicted binding affinity (pKd)", main=sprintf("N=%d, RMSE=%.2f, SD=%.2f, Rp=%.3f, Rs=%.3f", n, rmse, sdev, pcor, scor))
abline(lm(d[,"predicted"]~d[,"pbindaff"]))
grid()
