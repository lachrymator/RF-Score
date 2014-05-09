#!/usr/bin/env Rscript
nm=4 # Number of models.
nc=4 # Number of performance measures.
statc=c("rmse","sdev","pcor","scor")
statx=c("RMSE","SD","Rp","Rs")
statplot = function(s,trn,tst,ntrn,med) {
	cat(sprintf("set%d/trn-%s-tst-%s-%s.tiff\n",s,trn,tst,"{rmse,sdev,pcor,scor}"))
	for (ci in 1:nc)
	{
		ylim=c(min(med[,,ci],na.rm=T),max(med[,,ci],na.rm=T))
		tiff(sprintf("set%d/trn-%s-tst-%s-%s.tiff",s,trn,tst,statc[ci]),compression="lzw")
		par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
		for (m in 2:nm)
		{
			plot(ntrn[m,],med[m,,ci],ylim=ylim,type="b",xaxt="n",yaxt="n",xlab="",ylab="",pch=m,col=m)
			par(new=T)
		}
		abline(h=med[1,,ci])
		title(main=sprintf("Median of %s",statx[ci]),xlab="Number of training complexes",ylab=statx[ci])
		legend(ifelse(ci<=2,"topright","bottomright"),title="Models",legend=1:nm,fill=1:nm,cex=1.3)
		axis(1)
		axis(2)
		dev.off()
	}
}
for (s in 3:3)
{
	cat(sprintf("set%d\n",s))
	vv=c(2002,2007,2010)
	nv=length(vv)
	for (tst in 0:5)
	{
		for (trn in 0:0)
		{
			ntrn=array(dim=c(nm,nv))
			med=array(dim=c(nm,nv,nc))
			for (vi in 1:nv)
			{
				v=vv[vi]
				for (m in 1:nm)
				{
					if (m > 1) ntrn[m,vi]=nrow(read.csv(sprintf("model%d/set%s/pdbbind-%s-trn-%s-yxi.csv",m,s,v,trn)))
					tst_stat=read.csv(sprintf("model%d/set%s/pdbbind-%s-trn-%s-tst-%s-stat.csv",m,s,ifelse(m==1,2007,v),trn,tst))
					for (ci in 1:nc)
					{
						med[m,vi,ci]=median(tst_stat[statc[ci]][,])
					}
				}
			}
			statplot(s,trn,tst,ntrn,med)
		}
	}
	for (tst in 1:5)
	{
		tv=c(tst,tst+5,0)
		nt=length(tv)
		ntrn=array(dim=c(nm,nt))
		med=array(dim=c(nm,nt,nc))
		for (ti in 1:nt)
		{
			trn=tv[ti]
			for (v in c(2010))
			{
				for (m in 1:nm)
				{
					if (m > 1) ntrn[m,ti]=nrow(read.csv(sprintf("model%d/set%s/pdbbind-%s-trn-%s-yxi.csv",m,s,v,trn)))
					tst_stat=read.csv(sprintf("model%d/set%s/pdbbind-%s-trn-%s-tst-%s-stat.csv",m,s,ifelse(m==1,2007,v),ifelse(m==1,0,trn),tst))
					for (ci in 1:nc)
					{
						med[m,ti,ci]=median(tst_stat[statc[ci]][,])
					}
				}
			}
		}
		statplot(s,tst,tst,ntrn,med)
	}
	for (tst in 1:5)
	{
		tv=c(10+tst,15+tst,20+tst,25+tst,30+tst)
		nt=length(tv)
		ntrn=array(dim=c(nm,nt))
		med=array(dim=c(nm,nt,nc))
		for (ti in 1:nt)
		{
			trn=tv[ti]
			for (v in c(2010))
			{
				for (m in 1:nm)
				{
					if (m > 1) ntrn[m,ti]=nrow(read.csv(sprintf("model%d/set%s/pdbbind-%s-trn-%s-yxi.csv",m,s,v,trn)))
					tst_stat=read.csv(sprintf("model%d/set%s/pdbbind-%s-trn-%s-tst-%s-stat.csv",m,s,ifelse(m==1,2007,v),ifelse(m==1,0,trn),tst))
					for (ci in 1:nc)
					{
						med[m,ti,ci]=median(tst_stat[statc[ci]][,])
					}
				}
			}
		}
		statplot(s,10+tst,tst,ntrn,med)
	}
}
