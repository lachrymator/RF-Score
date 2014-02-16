#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
v=args[1]
trn=args[2]
w=as.numeric(args[3])
d=read.csv(sprintf("../pdbbind-%s-trn-%s-yxi.csv",v,trn)) # d[1] is pbindaff in pKd unit, d[2] to d[11] are Vina's 10 unweighted terms, d[12] and d[13] are N(ActTors) and N(InactTors).
d["t"]=1+w*(d["nacttors"]+0.5*d["ninacttors"]) # Flexibility penalty = 1 + w * Nrot. In Vina's implementation, active torsions are counted as 1, while inactive torsions (i.e. -OH,-NH2,-CH3) are counted as 0.5.
d["z"]=d["pbindaff"]*d["t"] # Measured pKd times the flexibility penalty.
r=lm(z~gauss1_inter+gauss2_inter+repulsion_inter+hydrophobic_inter+hydrogenbonding_inter+gauss1_intra+gauss2_intra+repulsion_intra+hydrophobic_intra+hydrogenbonding_intra,d) # Linear regression of Vina's 10 unweighted terms.
c=coefficients(r) # Trained weights.
write.csv(round(c,6),quote=F,file=sprintf("pdbbind-%s-trn-%s-coef.csv",v,trn))
