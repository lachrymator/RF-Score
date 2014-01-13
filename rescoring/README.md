Rescoring models
================

Several models for rescoring protein-ligand binding affinity are evaluated and compared in terms of prediction performance on the PDBbind v2007 core set (N = 195).


Model 1
-------

Model 1 is the Vina score, whose parameters are tuned by nonlinear optimization on PDBbind v2007 refined set (N = 1300). Its functional form is e = (w1*gauss1 + w2*gauss2 + w3*repulsion + w4*hydrophobic + w5*hydrogenbonding) / (1 + w6*Nrot), with w = [-0.035579,-0.005156,0.840245,-0.035069,-0.587439,0.05846] and cutoff = 8A. Vina identifies inactive torsions (i.e. -OH, -NH2, -CH3) and active torsions (i.e. other than the 3 types), and implements Nrot = N(ActTors) + 0.5*N(InactTors), i.e. active torsions are counted as 1 while inactive torsions are counted as 0.5.


Model 2
-------

Model 2 is a multiple linear regression model with the same functional form and cutoff as the Vina score. The denominator (1 + w6*Nrot) is moved to the left hand side, yielding the MLR equation z = e * (1 + w6*Nrot) = w1*gauss1 + w2*gauss2 + w3*repulsion + w4*hydrophobic + w5*hydrogenbonding. For w6, multiple values are sampled from 0 to 1 with a step size of 0.1 and from 0.01 to 0.02 with a step size of 0.0001. When the PDBbind v2007 refined set minus core set (N = 1105) is used as the training set, w6 = 0.0165 yields the best prediction performance with rmsd = 1.920, sdev = 1.925, pcor = 0.604, scor = 0.663 and kcor = 0.472. Therefore w6 = 0.0165 is used in all the subsequent experiments.

It is separately trained on four training sets:

### PDBbind v2004 refined set (N = 1091) minus PDBbind v2007 core set (N = 195)

There are 138 complexes in common in both sets. The 1oko protein fails PDB-to-PDBQT conversion because of a ZeroDivisionError raised by prepare_receptor4.py. Therefore this training set has N = 1091 - 138 - 1 = 952 complexes.

### PDBbind v2007 refined set (N = 1300) minus PDBbind v2007 core set (N = 195)

This training set is the one used in the RF-Score paper. Therefore it has N = 1105.

### PDBbind v2010 refined set (N = 2061) minus PDBbind v2007 core set (N = 195)

There are 181 complexes in common in both sets. The 2bo4 protein fails PDB-to-PDBQT conversion because of a ZeroDivisionError raised by prepare_receptor4.py. The 1xr8 ligand is far away from its protein. Therefore this training set has N = 2061 - 181 - 2 = 1878 complexes.

### PDBbind v2013 refined set (N = 2959) minus PDBbind v2007 core set (N = 195)

There are 165 complexes in common in both sets. Therefore this training set has N = 2959 - 165 = 2794 complexes.


Model 3
-------

Model 3 is a random forest of 500 trees using 6 Vina features, i.e. gauss1, gauss2, repulsion, hydrophobic, hydrogenbonding and Nrot. It is separately trained on the same four training sets as in model 2 and each with 10 different seeds, i.e. 89757,35577,51105,72551,10642,69834,47945,52857,26894,99789. For a given seed, 6 random forests are trained with mtry = 1 to 6, and the one with the minimum RMSE(OOB) is chosen.

The prediction performance on the PDBbind v2007 core set (N = 195) are in four files: pdbbind2004-core-statistics.csv, pdbbind2007-core-statistics.csv, pdbbind2010-core-statistics.csv and pdbbind2013-core-statistics.csv.


Model 4
-------

Model 5 is a random forest of 500 trees trained on PDBbind v2007 refined set minus core set (N = 1105) using 36 RF-Score features and 6 Vina features. It is separately trained with the same 10 seeds as used in model 3. For a given seed, 15 random forests are trained with mtry = 1 to 15, and the one with the minimum RMSE(OOB) is chosen.


Model 5
-------

Model 5 is a random forest of 500 trees trained on PDBbind v2007 refined set minus core set (N = 1105) using 5 Vina features, i.e. gauss1, gauss2, repulsion, hydrophobic and hydrogenbonding. It is separately trained with the same 10 seeds as used in model 3. For a given seed, 5 random forests are trained with mtry = 1 to 5, and the one with the minimum RMSE(OOB) is chosen.
