#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
ntrn=args[1]
labels2=c("Hydrophobic","Ent")
labels4=c("Hydrophobic","Vdw","HBond","Ent")
labels6=c("gauss1","gauss2","repulsion","hydrophobic","hydrogenbonding","flexibility")
labels36=c(6.6,7.6,8.6,16.6,6.7,7.7,8.7,16.7,6.8,7.8,8.8,16.8,6.16,7.16,8.16,16.16,6.15,7.15,8.15,16.15,6.9,7.9,8.9,16.9,6.17,7.17,8.17,16.17,6.35,7.35,8.35,16.35,6.53,7.53,8.53,16.53)
imp=read.table(file("stdin"))
n=nrow(imp)
if (n == 2) {
	labels=labels2;
	h=480
} else if (n == 4) {
	labels=labels4
	h=480
} else if (n == 4 + 6) {
	labels=c(labels4,labels6)
	h=480
} else if (n == 4 + 36) {
	labels=c(labels4,labels36)
	h=800
} else if (n == 4 + 6 + 36) {
	labels=c(labels4,labels6,labels36)
	h=800
}
ord=order(imp)
png(sprintf("trn-%s-varimp.png",ntrn),bg="transparent",width=960,height=h*2,res=120)
par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
dotchart(imp[ord,1], labels=labels[ord], xlab="%IncMSE", main="Variable Importance")
