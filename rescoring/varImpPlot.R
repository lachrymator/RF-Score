#!/usr/bin/env Rscript
v=commandArgs(trailingOnly=T)[1]
labels=c("gauss1","gauss2","repulsion","hydrophobic","hydrogenbonding","flexibility")
imp=read.table(file("stdin"))
if (nrow(imp) > 6) labels=c(6.6,7.6,8.6,16.6,6.7,7.7,8.7,16.7,6.8,7.8,8.8,16.8,6.16,7.16,8.16,16.16,6.15,7.15,8.15,16.15,6.9,7.9,8.9,16.9,6.17,7.17,8.17,16.17,6.35,7.35,8.35,16.35,6.53,7.53,8.53,16.53,labels)
ord=order(imp)
tiff(sprintf("pdbbind-%s-trn-varimpplot.tiff",v), compression="lzw")
dotchart(imp[ord,1], labels=labels[ord], xlab="%IncMSE", main="Variable Importance")
