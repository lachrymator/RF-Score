#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
trn=args[1]
d=read.csv(sprintf("../trn-%s-yxi.csv",trn))
c=coefficients(lm(pbindaff~Hydrophobic+Vdw+HBond+Ent+gauss1+gauss2+repulsion+hydrophobic+hydrogenbonding+flexibility,d))
c[is.na(c)]=0
write.csv(c,quote=F,file=sprintf("trn-%s.csv",trn))
