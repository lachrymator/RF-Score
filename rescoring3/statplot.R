#!/usr/bin/env Rscript
nm=4 # Number of models.
nv=3 # Number of training sets per dataset.
nc=4 # Number of performance measures.
setv=c(2002,2007,2010)
statc=c("rmse","sdev","pcor","scor")
statx=c("RMSE","SD","Rp","Rs")
for (trn in 0:0)
{
	cat(sprintf("trn%s\n",trn))
	tsts = 0:5
	for (tst in tsts)
	{
		# Plot figures with y axis being the performance measure, x axis being the numbers of training complexes, and legends being the models.
		cat(sprintf("set$s/trn-$trn-tst-$tst-$c.tiff\n"))
		s=3
		{
			cat(sprintf("set%d\n",s))
			ntrn=array(dim=nv)
			med=array(dim=c(nm,nv,nc))
			for (vi in 1:nv)
			{
				v=setv[vi]
				trn_stat=read.csv(sprintf("model%d/set%s/pdbbind-%s-trn-%s-trn-%s-stat.csv",2,s,v,trn,trn))
				ntrn[vi]=trn_stat["n"][1,1]
				for (m in 1:nm)
				{
					tst_stat=read.csv(sprintf("model%d/set%s/pdbbind-%s-trn-%s-tst-%s-stat.csv",m,s,ifelse(m==1,2007,v),ifelse(m==1,1,trn),tst))
					for (ci in 1:nc)
					{
						med[m,vi,ci]=median(tst_stat[statc[ci]][,])
					}
				}
			}
			for (ci in 1:nc)
			{
				ylim=c(min(med[,,ci],na.rm=T),max(med[,,ci],na.rm=T))
				tiff(sprintf("set%d/trn-%s-tst-%s-%s.tiff",s,trn,tst,statc[ci]),compression="lzw")
				par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
				for (m in 2:nm)
				{
					plot(ntrn,med[m,,ci],ylim=ylim,type="b",xaxt="n",yaxt="n",xlab="",ylab="",pch=m,col=m)
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
	}
}
