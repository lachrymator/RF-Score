#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
ntrn=args[1]
trn=read.csv(sprintf("../trn-%s-yxi.csv",ntrn))
c=coefficients(lm(pbindaff~Hydrophobic+Vdw+HBond+Ent,trn))
write.csv(c,quote=F,file=sprintf("trn-%s-coef.csv",ntrn))
