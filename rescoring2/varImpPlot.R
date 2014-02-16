#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
v=args[1]
trn=args[2]
labels10=c("gauss1_inter","gauss2_inter","repulsion_inter","hydrophobic_inter","hydrogenbonding_inter","gauss1_intra","gauss2_intra","repulsion_intra","hydrophobic_intra","hydrogenbonding_intra")
labels46=c("6.6","7.6","8.6","16.6","6.7","7.7","8.7","16.7","6.8","7.8","8.8","16.8","6.16","7.16","8.16","16.16","6.15","7.15","8.15","16.15","6.9","7.9","8.9","16.9","6.17","7.17","8.17","16.17","6.35","7.35","8.35","16.35","6.53","7.53","8.53","16.53",labels10)
labels=c();
imp=read.table(file("stdin"))
nr=nrow(imp)
if (nr == 11) {
	labels=labels10
	h=580
} else if (nr == 47) {
	labels=labels46
	h=900
} else if (nr == 91) {
	for (p in 1:9)
	{
		for (f in labels10)
		{
			labels=c(labels,sprintf("%s_%d",f,p))
		}
	}
	h=1780
} else if (nr == 415) {
	for (p in 1:9)
	{
		for (f in labels46)
		{
			labels=c(labels,sprintf("%s_%d",f,p))
		}
	}
	h=8260
} else {
	write(sprintf("nr=%d is unsupported",nr), stderr())
	quit()
}
labels=c(labels,"flexibility");
ord=order(imp)
tiff(sprintf("pdbbind-%s-trn-%s-varimpplot.tiff",v,trn), compression="lzw", height=h)
par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
dotchart(imp[ord,1], labels=labels[ord], xlab="%IncMSE", main="Variable Importance")
