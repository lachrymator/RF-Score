#!/usr/bin/env Rscript
nm=6 # Number of models.
ns=3 # Number of datasets.
nv=7 # Number of training sets per dataset.
nc=4 # Number of performance measures.
nx=c(2,4,10,40,42,46)
ntsts=c(195,201,382)
ntrns=c(247,1105,2280,792,1300,2059,2897)
statc=c("rmse","sdev","pcor","scor")
statx=c("RMSE","SD","Rp","Rs")
for (ntsti in 1:3)
{
	ntst=ntsts[ntsti]
	box=array(list(),dim=c(nm,nv,nc))
	for (ntrni in 1:nv)
	{
		ntrn=ntrns[ntrni]
		for (m in 1:nm)
		{
			stat=read.csv(sprintf("x%d/mlr/trn-%d-tst-%d-stat.csv",nx[m],ntrn,ntst))
			for (ci in 1:nc)
			{
				box[m,vi,ci]=stat[statc[ci]]
			}
		}
	}
	for (ci in 1:nc)
	{
		png(sprintf("tst-%d-%s-boxplot.png",ntst,statc[ci]),bg="transparent",width=960,height=960,res=120)
		par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
#		ylim=c(min(med[,,ci]),max(med[,,ci]))
		for (m in 1:nm)
		{
			boxplot(box[m,,ci],xaxt="n",yaxt="n",xlab="",ylab="",border=m)
			par(new=T)
		}
		title(main=sprintf("Boxplot of %s",statx[ci]),xlab="Number of training complexes",ylab=statx[ci])
		legend(ifelse(ci<=2,"topright","bottomright"),title="Models",legend=1:nm,fill=1:nm,cex=1.3)
		axis(1,at=1:nv,labels=ntrns)
		axis(2)
		dev.off()
	}
}
