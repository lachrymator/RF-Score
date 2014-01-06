#!/usr/bin/env Rscript
g=-0.73349480509 # Conversion factor from kcal/mol to pKd.
w=c(-0.035579,-0.005156,0.840245,-0.035069,-0.587439,0.05846) # Vina's 6 weights.
d=read.csv('pdbbind2007-refined-yxi.csv') # d[1] is pbindaff in pKd unit, d[2] to d[6] are Vina's 5 unweighted terms, d[7] and d[8] are N(ActTors) and N(InactTors).
d['t']=1+w[6]*(d[7]+0.5*d[8]) # Flexibility penalty = 1 + w * Nrot. In Vina's implementation, active torsions are counted as 1, while inactive torsions (i.e. -OH,-NH2,-CH3) are counted as 0.5.
d['v']=(d[2]*w[1]+d[3]*w[2]+d[4]*w[3]+d[5]*w[4]+d[6]*w[5])/d['t']*g # Vina score is computed as the weighted sum of the first 5 terms divided by the flexibility penalty. Multiplying g converts it from kcal/mol to pKd. Therefore d['v'] is Vina score in pKd unit.
d['z']=d['pbindaff']/g*d['t'] # Measured pKd converted to kcal/mol times the flexibility penalty.
r=lm(z~gauss1+gauss2+repulsion+hydrophobic+hydrogenbonding,d) # Linear regression of Vina's 5 unweighted terms.
#coefficients(r) # Print the trained weights, which are very different compared to Vina's weights, i.e. w[1] to w[5]
d['p']=fitted(r)/d['t']*g # Binding affinity predicted by the newly-trained model, with kcal/mol converted to pKd.
#write.table(c(round(d['pbindaff'],2),round(d['p'],2)),row.names=F,col.names=F,sep=',') # Write the measured binding affinities and the predicted ones in CSV format without header.
n=nrow(d) # Number of training samples. For PDBbind v2007 refined set, n = 1300.
for (i in c('v','p')) # For both the Vina score and the newly-trained model, print their RMSE, standard deviation, Pearson/Spearman/Kendall correlation coefficients.
{
	se=sum((d[i] - d[1])^2)
	rmse=sqrt(se/n)
	sdev=sqrt(se/(n-1))
	pcor=cor(d[i], d[1], method="pearson")
	scor=cor(d[i], d[1], method="spearman")
	kcor=cor(d[i], d[1], method="kendall")
	print(paste("N", n))
	print(paste("rmse", round(rmse,3)))
	print(paste("sdev", round(sdev,3)))
	print(paste("pcor", round(pcor,3)))
	print(paste("scor", round(scor,3)))
	print(paste("kcor", round(kcor,3)))
}
