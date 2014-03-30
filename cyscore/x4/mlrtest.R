#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
ntrn=args[1]
ntst=args[2]
c=read.csv(sprintf("trn-%s-coef.csv",ntrn))[,2]
d=read.csv(sprintf("../tst-%s-yxi.csv",ntst))
d["predicted"]=c[2]*d[2]+c[3]*d[3]+c[4]*d[4]+c[5]*d[5]
d["regressed"]=fitted(lm(pbindaff~predicted,d))
write.csv(c(d["PDB"],d["pbindaff"],round(d["predicted"],2)),row.names=F,quote=F,file=sprintf("trn-%s-tst-%s-iyp.csv",ntrn,ntst))
