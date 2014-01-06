#!/usr/bin/env Rscript
w=as.numeric(commandArgs(trailingOnly=T)[1])
d=read.csv('pdbbind2007-refined-core-yxi.csv') # d[1] is pbindaff in pKd unit, d[2] to d[6] are Vina's 5 unweighted terms, d[7] and d[8] are N(ActTors) and N(InactTors).
d['t']=1+w*(d[7]+0.5*d[8]) # Flexibility penalty = 1 + w * Nrot. In Vina's implementation, active torsions are counted as 1, while inactive torsions (i.e. -OH,-NH2,-CH3) are counted as 0.5.
d['z']=d['pbindaff']*d['t'] # Measured pKd times the flexibility penalty.
r=lm(z~gauss1+gauss2+repulsion+hydrophobic+hydrogenbonding,d) # Linear regression of Vina's 5 unweighted terms.
c=coefficients(r) # Trained weights.

# Evaluate on training set.
d['p']=(c[1]+d[2]*c[2]+d[3]*c[3]+d[4]*c[4]+d[5]*c[5]+d[6]*c[6])/d['t'] # Binding affinity predicted by the newly-trained model, with kcal/mol converted to pKd.
#write.table(c(round(d['pbindaff'],2),round(d['p'],2)),row.names=F,col.names=F,sep=',') # Write the measured binding affinities and the predicted ones in CSV format without header.
# Print RMSE, standard deviation, Pearson/Spearman/Kendall correlation coefficients.
n=nrow(d) # Number of samples.
se=sum((d['p'] - d[1])^2) # Square error
rmse=sqrt(se/n)
sdev=sqrt(se/(n-1))
pcor=cor(d['p'], d[1], method="pearson")
scor=cor(d['p'], d[1], method="spearman")
kcor=cor(d['p'], d[1], method="kendall")
print(paste("N", n))
print(paste("rmse", round(rmse,3)))
print(paste("sdev", round(sdev,3)))
print(paste("pcor", round(pcor,3)))
print(paste("scor", round(scor,3)))
print(paste("kcor", round(kcor,3)))

# Evaluate on test set.
d=read.csv('pdbbind2007-core-yxi.csv') # d[1] is pbindaff in pKd unit, d[2] to d[6] are Vina's 5 unweighted terms, d[7] and d[8] are N(ActTors) and N(InactTors).
d['t']=1+w*(d[7]+0.5*d[8]) # Flexibility penalty = 1 + w * Nrot. In Vina's implementation, active torsions are counted as 1, while inactive torsions (i.e. -OH,-NH2,-CH3) are counted as 0.5.
d['p']=(c[1]+d[2]*c[2]+d[3]*c[3]+d[4]*c[4]+d[5]*c[5]+d[6]*c[6])/d['t'] # Binding affinity predicted by the newly-trained model, with kcal/mol converted to pKd.
#write.table(c(round(d['pbindaff'],2),round(d['p'],2)),row.names=F,col.names=F,sep=',') # Write the measured binding affinities and the predicted ones in CSV format without header.
# Print RMSE, standard deviation, Pearson/Spearman/Kendall correlation coefficients.
n=nrow(d) # Number of samples.
se=sum((d['p'] - d[1])^2) # Square error
rmse=sqrt(se/n)
sdev=sqrt(se/(n-1))
pcor=cor(d['p'], d[1], method="pearson")
scor=cor(d['p'], d[1], method="spearman")
kcor=cor(d['p'], d[1], method="kendall")
print(paste("N", n))
print(paste("rmse", round(rmse,3)))
print(paste("sdev", round(sdev,3)))
print(paste("pcor", round(pcor,3)))
print(paste("scor", round(scor,3)))
print(paste("kcor", round(kcor,3)))
