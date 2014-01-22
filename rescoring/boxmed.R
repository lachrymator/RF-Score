#!/usr/bin/env Rscript
nm=4 # Number of models.
ns=2 # Number of datasets.
nv=4 # Number of training sets per dataset.
nc=5 # Number of performance measures.
setv=array(dim=c(ns,nv))
setv[1,]=c(2004,2007,2010,2013)
setv[2,]=c(2002,2007,2010,2012)
statc=c("rmse","sdev","pcor","scor","kcor")
statx=c("RMSE","SD","Rp","Rs","Rk")
# Plot figures with y axis being the performance measure and x axis being the numbers of training complexes.
cat(sprintf("xtrn\n"))
for (m in 2:5)
{
	cat(sprintf("model%d\n",m))
	for (s in 1:ns)
	{
		cat(sprintf("set%d\n",s))
		ntrn=array(dim=nv)
		box=array(list(),dim=c(nc,nv))
		med=array(dim=c(nc,nv))
		for (vi in 1:nv)
		{
			v=setv[s,vi]
			trn_stat=read.csv(sprintf("model%d/set%d/pdbbind-%s-trn-stat.csv",m,s,v))
			tst_stat=read.csv(sprintf("model%d/set%d/pdbbind-%s-tst-stat.csv",m,s,v))
			ntrn[vi]=trn_stat["n"][1,]
			for (si in 1:nc)
			{
				box[si,vi]=tst_stat[statc[si]]
				med[si,vi]=median(tst_stat[statc[si]][,])
			}
		}
		for (si in 1:nc)
		{
			tiff(sprintf("model%d/set%d/tst-%s-boxplot.tiff",m,s,statc[si]),compression="lzw")
			par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
			boxplot(box[si,],main=sprintf("Boxplot of %s",statx[si]),xlab="Number of training complexes",ylab=statx[si],range=0,xaxt="n")
			axis(1,at=1:nv,labels=ntrn)
			dev.off()
			tiff(sprintf("model%d/set%d/tst-%s-median.tiff",m,s,statc[si]),compression="lzw")
			par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
			plot(ntrn,med[si,],main=sprintf("Median of %s",statx[si]),xlab="Number of training complexes",ylab=statx[si],pch=3)
			dev.off()
		}
	}
}
# Plot figures with y axis being the performance measure and x axis being the models trained on a specific training set.
cat(sprintf("xmdl\n"))
for (s in 1:ns)
{
	cat(sprintf("set%d\n",s))
	for (vi in 1:nv)
	{
		v=setv[s,vi]
		cat(sprintf("v%d\n",v))
		box=array(list(),dim=c(nc,nm))
		med=array(dim=c(nc,nm))
		for (m in 1:nm)
		{
			tst_stat=read.csv(sprintf("model%d/set%s/pdbbind-%s-tst-stat.csv",m,s,ifelse(m==1,2007,v)))
			for (si in 1:nc)
			{
				box[si,m]=tst_stat[statc[si]]
				med[si,m]=median(tst_stat[statc[si]][,])
			}
		}
		for (si in 1:nc)
		{
			tiff(sprintf("set%d/pdbbind-%s-tst-%s-boxplot.tiff",s,v,statc[si]),compression="lzw")
			par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
			boxplot(box[si,],main=sprintf("Boxplot of %s",statx[si]),xlab="Model",ylab=statx[si],range=0)
			dev.off()
			tiff(sprintf("set%d/pdbbind-%s-tst-%s-median.tiff",s,v,statc[si]),compression="lzw")
			par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
			plot(1:4,med[si,],main=sprintf("Median of %s",statx[si]),xlab="Model",ylab=statx[si],pch=3,xaxt="n")
			axis(1,1:4)
			dev.off()
		}
	}
}
# Plot figures with y axis being the performance measure, x axis being the numbers of training complexes, and legends being the models.
cat(sprintf("mtrn\n"))
for (s in 1:ns)
{
	cat(sprintf("set%d\n",s))
	ntrn=array(dim=nv)
	for (vi in 1:nv)
	{
		v=setv[s,vi]
		trn_stat=read.csv(sprintf("model%d/set%s/pdbbind-%s-trn-stat.csv",2,s,v))
		ntrn[vi]=trn_stat["n"][1,1]
	}
}
