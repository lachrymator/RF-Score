#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
v=args[1]
t=args[2]
c=read.csv(sprintf("pdbbind-%s-trn-coef.csv",v))[,2]
d=read.csv(sprintf("pdbbind-%s-%s-iyp.csv",v,t))
d["regressed"]=c[1]+c[2]*d["predicted"]
write.csv(c(d["PDB"],d["pbindaff"],d["predicted"],round(d["regressed"],2)),row.names=F,quote=F,file=sprintf("pdbbind-%s-%s-iypr.csv",v,t))
n=nrow(d)
sdev=summary(lm(pbindaff~predicted,d))$sigma
pcor=cor(d["predicted"], d["pbindaff"], method="pearson")
scor=cor(d["predicted"], d["pbindaff"], method="spearman")
kcor=cor(d["predicted"], d["pbindaff"], method="kendall")
xylim=c(0,14)
if (n == 382) xylim=c(0,12)
for (p in c("predicted","regressed"))
{
	rmse=sqrt(sum((d[p]-d["pbindaff"])^2)/n)
	if (p == "predicted")
	{
		cat(sprintf("n,rmse,sdev,pcor,scor,kcor\n%d,%.3f,%.3f,%.3f,%.3f,%.3f\n", n, rmse, sdev, pcor, scor, kcor), file=sprintf("pdbbind-%s-%s-stat.csv",v,t))
	}
	l=substr(p,1,1)
	tiff(sprintf("pdbbind-%s-%s-y%s.tiff",v,t,l),compress="lzw")
	par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
	plot(d[,"pbindaff"], d[,p], xlim=xylim, ylim=xylim, xlab="Measured binding affinity (pKd)", ylab="Predicted binding affinity (pKd)", main=sprintf("N=%d, RMSE=%.2f, SD=%.2f, Rp=%.3f, Rs=%.3f", n, rmse, sdev, pcor, scor))
	abline(lm(d[,p]~d[,"pbindaff"]))
	grid()
	dev.off()
}
