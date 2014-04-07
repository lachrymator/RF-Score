#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
trn=args[1]
trn=read.csv(sprintf("../trn-%s-yxi.csv",trn))
c=coefficients(lm(pbindaff~gauss1+gauss2+repulsion+hydrophobic+hydrogenbonding+flexibility+X6.6+X7.6+X8.6+X16.6+X6.7+X7.7+X8.7+X16.7+X6.8+X7.8+X8.8+X16.8+X6.16+X7.16+X8.16+X16.16+X6.15+X7.15+X8.15+X16.15+X6.9+X7.9+X8.9+X16.9+X6.17+X7.17+X8.17+X16.17+X6.35+X7.35+X8.35+X16.35+X6.53+X7.53+X8.53+X16.53,trn))
c[is.na(c)]=0
write.csv(c,quote=F,file=sprintf("trn-%s.csv",trn))
