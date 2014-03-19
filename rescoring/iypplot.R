#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
v=args[1]
t=args[2]
d=read.csv(sprintf("pdbbind-%s-%s-iyp.csv",v,t))
r=lm(pbindaff~predicted,d)
d["regressed"]=fitted(r)
write.csv(c(d["PDB"],d["pbindaff"],d["predicted"],round(d["regressed"],2)),row.names=F,quote=F,file=sprintf("pdbbind-%s-%s-iypr.csv",v,t))
n=nrow(d) # Number of samples.
se=sum((d["regressed"] - d["pbindaff"])^2) # Square error.
rmse=sqrt(se/n)
sdev=sqrt(se/(n-2))
pcor=cor(d["regressed"], d["pbindaff"], method="pearson")
scor=cor(d["regressed"], d["pbindaff"], method="spearman")
kcor=cor(d["regressed"], d["pbindaff"], method="kendall")
cat(sprintf("n,rmse,sdev,pcor,scor,kcor\n%d,%.3f,%.3f,%.3f,%.3f,%.3f\n", n, rmse, sdev, pcor, scor, kcor), file=sprintf("pdbbind-%s-%s-stat.csv",v,t))
xylim=c(2,14) # Set1's range.
if (n == 382) xylim=c(1,12) # Set2's range.
tiff(sprintf("pdbbind-%s-%s-iyr.tiff",v,t),compress="lzw")
par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
plot(d[,"pbindaff"], d[,"regressed"], xlim=xylim, ylim=xylim, xlab="Measured binding affinity (pKd)", ylab="Predicted binding affinity (pKd)", main=sprintf("N=%d, RMSE=%.2f, SD=%.2f, Rp=%.3f, Rs=%.3f", n, rmse, sdev, pcor, scor))
abline(lm(d[,"regressed"]~d[,"pbindaff"]))
grid()
