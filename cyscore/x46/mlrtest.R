#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
ntrn=args[1]
ntst=args[2]
c=read.csv(sprintf("trn-%s.csv",ntrn))[,2]
d=read.csv(sprintf("../tst-%s-yxi.csv",ntst))
d["predicted"]=c[2]*d[2]+c[3]*d[3]+c[4]*d[4]+c[5]*d[5]+c[6]*d[6]+c[7]*d[7]+c[8]*d[8]+c[9]*d[9]+c[10]*d[10]+c[11]*d[11]+c[12]*d[12]+c[13]*d[13]+c[14]*d[14]+c[15]*d[15]+c[16]*d[16]+c[17]*d[17]+c[18]*d[18]+c[19]*d[19]+c[20]*d[20]+c[21]*d[21]+c[22]*d[22]+c[23]*d[23]+c[24]*d[24]+c[25]*d[25]+c[26]*d[26]+c[27]*d[27]+c[28]*d[28]+c[29]*d[29]+c[30]*d[30]+c[31]*d[31]+c[32]*d[32]+c[33]*d[33]+c[34]*d[34]+c[35]*d[35]+c[36]*d[36]+c[37]*d[37]+c[38]*d[38]+c[39]*d[39]+c[40]*d[40]+c[41]*d[41]+c[42]*d[42]+c[43]*d[43]+c[44]*d[44]+c[45]*d[45]+c[46]*d[46]+c[47]*d[47]
d["regressed"]=fitted(lm(pbindaff~predicted,d))
write.csv(c(d["PDB"],d["pbindaff"],round(d["predicted"],2)),row.names=F,quote=F,file=sprintf("trn-%s-tst-%s-iyp.csv",ntrn,ntst))
