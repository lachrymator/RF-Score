#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
v=args[1]
t=args[2]
c=read.csv(sprintf("pdbbind-%s-trn-coef.csv",v))[,2]
d=read.csv(sprintf("pdbbind-%s-%s-iyp.csv",v,t))
d["regressed"]=c[1]+c[2]*d["predicted"]
write.csv(c(d["PDB"],d["pbindaff"],d["predicted"],round(d["regressed"],2)),row.names=F,quote=F,file=sprintf("pdbbind-%s-%s-iypr.csv",v,t))
n=nrow(d) # Number of samples.
xylim=c(0,14)
if (n == 382) xylim=c(0,12)
for (p in c("predicted","regressed"))
{
	l=substr(p,1,1)
	se=sum((d[p] - d["pbindaff"])^2) # Square error.
	rmse=sqrt(se/n)
	sdev=sqrt(se/(n-2))
	pcor=cor(d[p], d["pbindaff"], method="pearson")
	scor=cor(d[p], d["pbindaff"], method="spearman")
	kcor=cor(d[p], d["pbindaff"], method="kendall")
	if (p == "regressed")
	{
		cat(sprintf("n,rmse,sdev,pcor,scor,kcor\n%d,%.3f,%.3f,%.3f,%.3f,%.3f\n", n, rmse, sdev, pcor, scor, kcor), file=sprintf("pdbbind-%s-%s-stat.csv",v,t))
	}
	tiff(sprintf("pdbbind-%s-%s-y%s.tiff",v,t,l),compress="lzw")
	par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
	plot(d[,"pbindaff"], d[,p], xlim=xylim, ylim=xylim, xlab="Measured binding affinity (pKd)", ylab="Predicted binding affinity (pKd)", main=sprintf("N=%d, RMSE=%.2f, SD=%.2f, Rp=%.3f, Rs=%.3f", n, rmse, sdev, pcor, scor))
	abline(lm(d[,p]~d[,"pbindaff"]))
	grid()
}
