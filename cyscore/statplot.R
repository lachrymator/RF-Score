#!/usr/bin/env Rscript
ms=c("mlr","rf","rf","rf")
xs=c(4,4,10,46)
ts=c("MLR::Cyscore","RF::Cyscore","RF::CyscoreVina","RF::CyscoreVinaElem")
trns=c(247,1105) # 247,1105 247,2696 592,1184,1776,2367
tst=195 # 195 201 592
statc=c("rmse","sdev","pcor","scor")
statx=c("RMSE","SD","Rp","Rs")
nm=length(ms) # Number of models.
ntrn=length(trns) # Number of training sets.
nc=length(statc) # Number of performance measures.
setEPS()
med=array(dim=c(nm,ntrn,nc))
for (trni in 1:ntrn)
{
	trn=trns[trni]
	for (mi in 1:nm)
	{
		stat=read.csv(sprintf("x%d/%s/trn-%d-tst-%d-stat.csv",xs[mi],ms[mi],trn,tst))
		for (ci in 1:nc)
		{
			med[mi,trni,ci]=stat[statc[ci]][,]
		}
	}
}
for (ci in 1:nc)
{
	ylim=c(min(med[,,ci],na.rm=T),max(med[,,ci],na.rm=T))
	postscript(sprintf("tst-%d-%s.eps",tst,statc[ci]))
	par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
	for (mi in 1:nm)
	{
		plot(trns,med[mi,,ci],ylim=ylim,type="b",xaxt="n",yaxt="n",xlab="",ylab="",pch=mi,col=mi)
		par(new=T)
	}
	title(xlab=sprintf("Number of training complexes (N=%s)",paste(trns,collapse=",")),ylab=statx[ci])
	legend(ifelse(ci<=2,"bottomleft","topleft"),title="Models",legend=ts,fill=1:nm,cex=1.3)
	axis(1)
	axis(2)
	dev.off()
}
