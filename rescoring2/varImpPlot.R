#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
v=args[1]
trn=args[2]
labels=c("gauss1_inter","gauss2_inter","repulsion_inter","hydrophobic_inter","hydrogenbonding_inter","gauss1_intra","gauss2_intra","repulsion_intra","hydrophobic_intra","hydrogenbonding_intra","flexibility")
imp=read.table(file("stdin"))
h=580
if (nrow(imp) > 11)
{
	labels=c(6.6,7.6,8.6,16.6,6.7,7.7,8.7,16.7,6.8,7.8,8.8,16.8,6.16,7.16,8.16,16.16,6.15,7.15,8.15,16.15,6.9,7.9,8.9,16.9,6.17,7.17,8.17,16.17,6.35,7.35,8.35,16.35,6.53,7.53,8.53,16.53,labels)
	h=900
}
ord=order(imp)
tiff(sprintf("pdbbind-%s-trn-%s-varimpplot.tiff",v,trn), compression="lzw", height=h)
par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
dotchart(imp[ord,1], labels=labels[ord], xlab="%IncMSE", main="Variable Importance")
