#!/usr/bin/env Rscript
vs=read.table(file("stdin"))
ntrn=c()
rmse=c()
sdev=c()
pcor=c()
scor=c()
kcor=c()
for (i in 1:nrow(vs))
{
	v=vs[i,1]
	trn_stat=read.csv(sprintf("pdbbind-%s-trn-stat.csv",v))
	tst_stat=read.csv(sprintf("pdbbind-%s-tst-stat.csv",v))
	ntrn=c(ntrn,trn_stat["n"][1,1])
	rmse=c(rmse,tst_stat["rmse"])
	sdev=c(rmse,tst_stat["sdev"])
	pcor=c(rmse,tst_stat["pcor"])
	scor=c(rmse,tst_stat["scor"])
	kcor=c(rmse,tst_stat["kcor"])
}
names(rmse)=ntrn
names(sdev)=ntrn
names(pcor)=ntrn
names(scor)=ntrn
names(kcor)=ntrn
#pdf("tst-rmse.pdf")
tiff("tst-rmse.tiff",compression="lzw")
boxplot(rmse,main="Boxplot of RMSE",xlab="Number of training complexes",ylab="Root Mean Square Error (Å)")
#pdf("tst-sdev.pdf")
tiff("tst-sdev.tiff",compression="lzw")
boxplot(sdev,main="Boxplot of SD",xlab="Number of training complexes",ylab="Standard Deviation (Å)")
#pdf("tst-pcor.pdf")
tiff("tst-pcor.tiff",compression="lzw")
boxplot(pcor,main="Boxplot of Rp",xlab="Number of training complexes",ylab="Pearson correlation coefficient")
#pdf("tst-scor.pdf")
tiff("tst-scor.tiff",compression="lzw")
boxplot(scor,main="Boxplot of Rs",xlab="Number of training complexes",ylab="Spearman correlation coefficient")
#pdf("tst-kcor.pdf")
tiff("tst-kcor.tiff",compression="lzw")
boxplot(kcor,main="Boxplot of Rk",xlab="Number of training complexes",ylab="Kendall correlation coefficient")
