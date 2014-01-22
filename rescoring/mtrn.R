#!/usr/bin/env Rscript
a=commandArgs(trailingOnly=T)
s=a[1]
vs=read.table(file("stdin")) # vs[,1]=c(2004,2007,2010,2013) for set1 and vs[,1]=c(2002,2007,2010,2012) for set2.
# Read the number of training complexes.
ntrn=c()
for (i in 1:nrow(vs))
{
	v=vs[i,1]
	trn_stat=read.csv(sprintf("model%d/set%s/pdbbind-%s-trn-stat.csv",2,s,v))
	ntrn=c(ntrn,trn_stat["n"][1,1])
}
# Read the statistics of models 2,3,4.
rmsem=array(dim=c(4,4))
for (m in 2:4)
{
	for (i in 1:nrow(vs))
	{
		v=vs[i,1]
		tst_stat=read.csv(sprintf("model%d/set%s/pdbbind-%s-tst-stat.csv",m,s,v))
		rmsem[m,i]=median(tst_stat["rmse"][,1])
	}
}
# Read the statistics of model 1.
tst_stat=read.csv(sprintf("model%d/set%s/pdbbind-%s-tst-stat.csv",1,s,2007))
rmsem[1,1]=tst_stat["rmse"][,1]
# Use plot() to create tst-*-median.tiff
tiff("tst-rmse-median.tiff",compression="lzw")
par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
for (m in 2:4)
{
	plot(ntrn,rmsem[m,],ylim=c(1.4,2.4),type="b",xaxt="n",yaxt="n",xlab="",ylab="",pch=m,col=m)
	par(new=T)
}
abline(h=rmsem[1,1])
title(main="Median of RMSE",xlab="Number of training complexes",ylab="RMSE")
legend("topright",title="Models",legend=1:4,fill=1:4)
axis(1)
axis(2)
