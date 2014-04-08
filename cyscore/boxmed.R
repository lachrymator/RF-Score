#!/usr/bin/env Rscript
nx=6 # Number of features.
ntrns=7 # Number of training sets.
nc=4 # Number of performance measures.
xs=c(2,4,10,40,42,46)
trns=c(247,1105,2280,792,1300,2059,2897)
statc=c("rmse","sdev","pcor","scor")
statx=c("RMSE","SD","Rp","Rs")
for (m in c("mlr","rf"))
{
	for (tst in c(195,201,382))
	{
		box=array(list(),dim=c(nx,ntrns,nc))
		for (trni in 1:ntrns)
		{
			trn=trns[trni]
			for (xi in 1:nx)
			{
				stat=read.csv(sprintf("x%d/%s/trn-%d-tst-%d-stat.csv",xs[xi],m,trn,tst))
				for (ci in 1:nc)
				{
					box[xi,trni,ci]=stat[statc[ci]]
				}
			}
		}
		for (ci in 1:nc)
		{
			png(sprintf("%s/tst-%d-%s-boxplot.png",m,tst,statc[ci]),bg="transparent",width=960,height=960,res=120)
			par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
			for (xi in 1:nx)
			{
				boxplot(box[xi,,ci],xaxt="n",yaxt="n",xlab="",ylab="",border=xi)
				par(new=T)
			}
			title(xlab="Number of training complexes",ylab=statx[ci])
			legend(ifelse(ci<=2,"topright","bottomright"),title="Features",legend=xs,fill=1:nx,cex=1.3)
			axis(1,at=1:ntrns,labels=trns)
			axis(2)
			dev.off()
		}
	}
}
