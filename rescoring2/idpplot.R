#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
v=args[1]
trn=args[2]
tst=args[3]
d=read.csv(sprintf("pdbbind-%s-trn-%s-tst-%s-idp.csv",v,trn,tst))
n=nrow(d)
tiff(sprintf("pdbbind-%s-trn-%s-tst-%s-dp.tiff",v,trn,tst),compress="lzw")
par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
plot(d[,"RMSD1"], d[,"predicted"], xlim=c(0,15), ylim=c(0,14), xlab="RMSD (Å)", ylab="Predicted binding affinity (pKd)", main=sprintf("N=%d", n))
axis(1,at=2)
abline(v=2,lty=3)
grid()
