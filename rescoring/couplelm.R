#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
v=args[1]
d=read.csv(sprintf("pdbbind-%s-trn-iyp.csv",v))
r=lm(pbindaff~predicted,d)
c=coefficients(r)
write.csv(c,quote=F,file=sprintf("pdbbind-%s-trn-coef.csv",v))
