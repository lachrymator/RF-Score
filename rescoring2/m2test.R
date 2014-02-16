#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
v=args[1]
trn=args[2]
tst=args[3]
w=as.numeric(args[4])
t=args[5]
c=read.csv(sprintf("pdbbind-%s-trn-%s-coef.csv",v,trn))[,2]
d=read.csv(ifelse(t=="tst",sprintf("../tst-%s-yxi.csv",tst),sprintf("../pdbbind-%s-trn-%s-yxi.csv",v,trn))) # d[1] is pbindaff in pKd unit, d[2] to d[11] are Vina's 10 unweighted terms, d[12] and d[13] are N(ActTors) and N(InactTors).
d["t"]=1+w*(d["nacttors"]+0.5*d["ninacttors"]) # Flexibility penalty = 1 + w * Nrot. In Vina's implementation, active torsions are counted as 1, while inactive torsions (i.e. -OH,-NH2,-CH3) are counted as 0.5.
d["predicted"]=(c[1]+d[2]*c[2]+d[3]*c[3]+d[4]*c[4]+d[5]*c[5]+d[6]*c[6]+d[7]*c[7]+d[8]*c[8]+d[9]*c[9]+d[10]*c[10]+d[11]*c[11])/d["t"] # Binding affinity predicted by the newly-trained model, with kcal/mol converted to pKd.
write.csv(c(d["PDB"],round(d["pbindaff"],2),round(d["predicted"],2)),row.names=F,quote=F,file=sprintf("pdbbind-%s-trn-%s-%s-%s-iyp.csv",v,trn,t,ifelse(t=="tst",tst,trn))) # Write the measured binding affinities and the predicted ones in CSV format.
# Print RMSE, standard deviation, Pearson/Spearman/Kendall correlation coefficients.
n=nrow(d) # Number of samples.
se=sum((d["predicted"] - d[1])^2) # Square error.
rmse=sqrt(se/n)
sdev=sqrt(se/(n-1))
pcor=cor(d["predicted"], d[1], method="pearson")
scor=cor(d["predicted"], d[1], method="spearman")
kcor=cor(d["predicted"], d[1], method="kendall")
cat(sprintf("n,rmse,sdev,pcor,scor,kcor\n%d,%.3f,%.3f,%.3f,%.3f,%.3f\n", n, rmse, sdev, pcor, scor, kcor), file=sprintf("pdbbind-%s-trn-%s-%s-%s-stat.csv",v,trn,t,ifelse(t=="tst",tst,trn)))
