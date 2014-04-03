#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
ntrn=args[1]
trn=read.csv(sprintf("../trn-%s-yxi.csv",ntrn))
c=coefficients(lm(pbindaff~Hydrophobic+Vdw+HBond+Ent+gauss1+gauss2+repulsion+hydrophobic+hydrogenbonding+flexibility,trn))
c[is.na(c)]=0
write.csv(c,quote=F,file=sprintf("trn-%s.csv",ntrn))
