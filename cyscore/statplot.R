#!/usr/bin/env Rscript
ms=c("mlr","rf","rf","rf")
xs=c(4,4,10,46)
trns=c(592,1184,1776,2367)
tst=592
statc=c("rmse","sdev","pcor","scor")
statx=c("RMSE","SD","Rp","Rs")
nm=length(ms) # Number of models.
ntrn=length(trns) # Number of training sets.
nc=length(statc) # Number of performance measures.
ts=array(nm)
for (mi in 1:nm)
{
	ts[mi]=paste(toupper(ms[mi]),xs[mi],sep="-x")
}
#setEPS()
med=array(dim=c(nm,ntrn,nc))
for (trni in 1:ntrn)
{
	trn=trns[trni]
	for (mi in 1:nm)
	{
		stat=read.csv(sprintf("x%d/%s/trn-%d-tst-%d-stat.csv",xs[mi],ms[mi],trn,tst))
		for (ci in 1:nc)
		{
			med[mi,trni,ci]=median(stat[statc[ci]][,])
		}
	}
}
for (ci in 1:nc)
{
	ylim=c(min(med[,,ci],na.rm=T),max(med[,,ci],na.rm=T))
	png(sprintf("tst-%d-%s.png",tst,statc[ci]),bg="transparent",width=960,height=960,res=120)
	par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
	for (mi in 1:nm)
	{
		plot(trns,med[mi,,ci],ylim=ylim,type="b",xaxt="n",yaxt="n",xlab="",ylab="",pch=mi,col=mi)
		par(new=T)
	}
	title(xlab="Number of training complexes",ylab=statx[ci])
	legend("right",title="Models",legend=ts,fill=1:nm,cex=1.3)
	axis(1)
	axis(2)
	dev.off()
}
