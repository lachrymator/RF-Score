Rescoring models
================

Several models for rescoring protein-ligand binding affinity are evaluated and compared in terms of prediction performance on PDBbind v2007 core set (N = 195).


Model 1
-------

Model 1 is the Vina score, whose parameters are tuned by nonlinear optimization on PDBbind v2007 refined set (N = 1300). Its functional form is e = (w1*gauss1 + w2*gauss2 + w3*repulsion + w4*hydrophobic + w5*hydrogenbonding) / (1 + w6*Nrot), with w = [-0.035579,-0.005156,0.840245,-0.035069,-0.587439,0.05846] and cutoff = 8A. Vina identifies inactive torsions (i.e. -OH, -NH2, -CH3) and active torsions (i.e. other than the 3 types), and implements Nrot = N(ActTors) + 0.5*N(InactTors), i.e. active torsions are counted as 1 while inactive torsions are counted as 0.5.


Model 2
-------

Model 2 is a multiple linear regression model with the same functional form and cutoff as the Vina score. It is trained on four training sets:

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




Model 4
-------




Model 5
-------


