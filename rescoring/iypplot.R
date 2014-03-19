#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
v=args[1]
d=read.csv(sprintf("pdbbind-%s-tst-iyp.csv",v),check.names=F)
n=nrow(d)
se=sum((d[3] - d[2])^2)
rmse=sqrt(se/n)
sdev=sqrt(se/(n-1))
pcor=cor(d[3], d[2], method="pearson")
scor=cor(d[3], d[2], method="spearman")
kcor=cor(d[3], d[2], method="kendall")
xylim=c(2,14) # Set1's range.
if (n == 382) xylim=c(1,12) # Set2's range.
tiff(sprintf("pdbbind-%s-tst-iyp.tiff",v),compress="lzw")
par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
plot(d[,2], d[,3], xlim=xylim, ylim=xylim, xlab="Measured binding affinity (pKd)", ylab="Predicted binding affinity (pKd)", main=sprintf("N=%d, RMSE=%.2f, SD=%.2f, Rp=%.3f, Rs=%.3f", n, rmse, sdev, pcor, scor))
abline(lm(d[,3] ~ d[,2]))
grid()
