#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
ntrn=args[1]
ntst=args[2]
d=read.csv(sprintf("trn-%s-tst-%s-iyp.csv",ntrn,ntst))
r=lm(pbindaff~predicted,d)
d["regressed"]=fitted(r)
write.csv(c(d["PDB"],d["pbindaff"],d["predicted"],round(d["regressed"],2)),row.names=F,quote=F,file=sprintf("trn-%s-tst-%s-iypr.csv",ntrn,ntst))
n=nrow(d) # Number of samples.
xylim=c(2,12)
if (n == 195) xylim=c(0,14)
se=sum((d["regressed"] - d["pbindaff"])^2) # Square error.
rmse=sqrt(se/n)
sdev=sqrt(se/(n-2))
pcor=cor(d["regressed"], d["pbindaff"], method="pearson")
scor=cor(d["regressed"], d["pbindaff"], method="spearman")
kcor=cor(d["regressed"], d["pbindaff"], method="kendall")
cat(sprintf("n,rmse,sdev,pcor,scor,kcor\n%d,%.3f,%.3f,%.3f,%.3f,%.3f\n", n, rmse, sdev, pcor, scor, kcor), file=sprintf("trn-%s-tst-%s-stat.csv",ntrn,ntst))
tiff(sprintf("trn-%s-tst-%s-yr.tiff",ntrn,ntst),compress="lzw")
par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
plot(d[,"pbindaff"], d[,"regressed"], xlim=xylim, ylim=xylim, xlab="Measured binding affinity (pKd)", ylab="Predicted binding affinity (pKd)", main=sprintf("N=%d, RMSE=%.2f, SD=%.2f, Rp=%.3f, Rs=%.3f", n, rmse, sdev, pcor, scor))
abline(lm(d[,"regressed"]~d[,"pbindaff"]))
grid()
