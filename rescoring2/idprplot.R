#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
v=args[1]
trn=args[2]
tst=args[3]
d=read.csv(sprintf("pdbbind-%s-trn-%s-tst-%s-idpr.csv",v,trn,tst))
n=nrow(d)
ylim=c(2,14) # Set1's range.
if (n == 382) ylim=c(1,12) # Set2's range.
tiff(sprintf("pdbbind-%s-trn-%s-tst-%s-idpr.tiff",v,trn,tst),compress="lzw")
par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
plot(d[,"RMSD1"], d[,"regressed"], xlim=c(0,15), ylim=ylim, xlab="RMSD (Å)", ylab="Predicted binding affinity (pKd)", main=sprintf("N=%d", n))
axis(1,at=2)
abline(v=2,lty=3)
grid()
