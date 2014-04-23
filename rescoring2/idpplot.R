#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
v=args[1]
trn=args[2]
tst=args[3]
s=args[4]
p=read.csv(sprintf("pdbbind-%s-trn-%s-tst-%s-iyp.csv",v,trn,tst))
id=sprintf("../../set%s/tst-2-id.csv",s) # model 1
if (!file.exists(id)) id=paset("../",id,sep="") # models 2,3,4
d=read.csv(id)
n=nrow(d)
tiff(sprintf("pdbbind-%s-trn-%s-tst-%s-dp.tiff",v,trn,tst),compress="lzw")
par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
plot(d[,"RMSD1"], p[,"predicted"], xlim=c(0,15), ylim=c(0,14), xlab="RMSD (Å)", ylab="Predicted binding affinity (pKd)", main=sprintf("N=%d", n))
axis(1,at=2)
abline(v=2,lty=3)
grid()
