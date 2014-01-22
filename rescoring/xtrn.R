#!/usr/bin/env Rscript
statc=c("rmse","sdev","pcor","scor","kcor")
statx=c("RMSE","SD","Rp","Rs","Rk")
ns=length(statc)
vs=read.table(file("stdin"))[,]
nv=length(vs)
ntrn=array(dim=nv)
box=array(list(),dim=c(ns,nv))
med=array(dim=c(ns,nv))
for (vi in 1:nv)
{
	v=vs[vi]
	trn_stat=read.csv(sprintf("pdbbind-%s-trn-stat.csv",v))
	tst_stat=read.csv(sprintf("pdbbind-%s-tst-stat.csv",v))
	ntrn[vi]=trn_stat["n"][1,]
	for (si in 1:ns)
	{
		box[si,vi]=tst_stat[statc[si]]
		med[si,vi]=median(tst_stat[statc[si]][,])
	}
}
for (si in 1:ns)
{
	tiff(sprintf("tst-%s-boxplot.tiff",statc[si]),compression="lzw")
	par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
	boxplot(box[si,],main="Boxplot of RMSE",xlab="Number of training complexes",ylab="RMSE",range=0,xaxt="n")
	axis(1,at=1:nv,labels=ntrn)
	tiff(sprintf("tst-%s-median.tiff",statc[si]),compression="lzw")
	par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
	plot(ntrn,med[si,],main=sprintf("Median of %s",statx[si]),xlab="Number of training complexes",ylab=statx[si],pch=3)
}
