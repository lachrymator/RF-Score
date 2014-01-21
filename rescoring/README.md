Rescoring models
================

Several models for rescoring protein-ligand binding affinity are evaluated and compared in terms of prediction performance on two datasets, both of which consist of four training sets and one test set. For each of the two datasets, the test set has no overlapping complexes in either of the four training sets.


Dataset 1
---------

The test set 0) and the four training sets 1), 2), 3), 4) are as follows:

0) PDBbind v2007 core set (N = 195). This test set is the one used in the RF-Score paper. Therefore it has N = 195.

1) PDBbind v2004 refined set (N = 1091) minus PDBbind v2007 core set (N = 195). Both sets have 138 complexes in common. The 1oko protein fails PDB-to-PDBQT conversion by prepare_receptor4.py. Therefore this training set has N = 1091 - 138 - 1 = 952 complexes.

2) PDBbind v2007 refined set (N = 1300) minus PDBbind v2007 core set (N = 195). This training set is the one used in the RF-Score paper. Therefore it has N = 1105. Note that every complex in the test set has complexes involving the same protein in this training set.

3) PDBbind v2010 refined set (N = 2061) minus PDBbind v2007 core set (N = 195). Both sets have 181 complexes in common. The 2bo4 protein fails PDB-to-PDBQT conversion by prepare_receptor4.py. The 1xr8 ligand is far away from its protein. Therefore this training set has N = 2061 - 181 - 2 = 1878 complexes.

4) PDBbind v2013 refined set (N = 2959) minus PDBbind v2007 core set (N = 195). Both sets have 165 complexes in common. Therefore this training set has N = 2959 - 165 = 2794 complexes.

Their intersections are as follows:

* |0 ∩ 1| = 0
* |0 ∩ 2| = 0
* |0 ∩ 3| = 0
* |0 ∩ 4| = 0
* |1 ∩ 2| = 786
* |1 ∩ 3| = 708
* |1 ∩ 4| = 695
* |2 ∩ 3| = 997
* |2 ∩ 4| = 909
* |3 ∩ 4| = 1676


Dataset 2
---------

The test set 0) and the four training sets 1), 2), 3), 4) are as follows:

0) PDBbind v2013 refined set (N = 2959) minus PDBbind v2012 refined set (N = 2897). Both sets have 2576 complexes in common. The 3rv4 protein consists of two Cs atoms which Vina does not support. Therefore this test set has N = 2959 - 2576 - 1 = 382 complexes.

1) PDBbind v2002 refined set (N = 800). The 1tha protein fails PDB-to-PDBQT conversion by prepare_receptor4.py. The 1lkk, 1mfi, 7std, 1cet, 2std, 1els, 1c3x ligands fail PDB-to-PDBQT conversion by prepare_ligand4.py. Therefore this training set has N = 800 - 8 = 792 complexes.

2) PDBbind v2007 refined set (N = 1300). This training set has N = 1300 complexes.

3) PDBbind v2010 refined set (N = 2061). The 2bo4 protein fails PDB-to-PDBQT conversion by prepare_receptor4.py. The 1xr8 ligand is far away from its protein. Therefore this training set has N = 2061 - 2 = 2059 complexes.

4) PDBbind v2012 refined set (N = 2897). This training set has N = 2897 complexes.

Their intersections are as follows:

* |0 ∩ 1| = 0
* |0 ∩ 2| = 0
* |0 ∩ 3| = 0
* |0 ∩ 4| = 0
* |1 ∩ 2| = 592
* |1 ∩ 3| = 536
* |1 ∩ 4| = 565
* |2 ∩ 3| = 1178
* |2 ∩ 4| = 1173
* |3 ∩ 4| = 2032


Model 1
-------

Model 1 is the Vina score, whose parameters are tuned by nonlinear optimization on PDBbind v2007 refined set (N = 1300). Its functional form is e = (w1*gauss1 + w2*gauss2 + w3*repulsion + w4*hydrophobic + w5*hydrogenbonding) / (1 + w6*Nrot), where e is free energy in kcal/mol and w = [-0.035579,-0.005156,0.840245,-0.035069,-0.587439,0.05846] and cutoff = 8A. Vina identifies inactive torsions (i.e. -OH, -NH2, -CH3) and active torsions (i.e. other than the 3 types), and implements Nrot = N(ActTors) + 0.5*N(InactTors), i.e. active torsions are counted as 1 while inactive torsions are counted as 0.5. The free energy in kcal/mol is converted to binding affinity in pKd by multiplying -0.73349480509.


Model 2
-------

Model 2 is a multiple linear regression model with the same functional form and cutoff as the Vina score. The denominator (1 + w6*Nrot) is moved to the left hand side, transforming the equation into z = e * (1 + w6*Nrot) = w1*gauss1 + w2*gauss2 + w3*repulsion + w4*hydrophobic + w5*hydrogenbonding. To find the optimal value of w6, 11 values are sampled from 0.005 to 0.020 with a step size of 0.001. The range [0.01, 0.02] is chosen because the optimal value of w6 always falls in it for all the eight training sets of the two datasets.


Model 3
-------

Model 3 is a random forest of 500 trees using 6 Vina features, i.e. gauss1, gauss2, repulsion, hydrophobic, hydrogenbonding and Nrot. It is separately trained on the same four training sets as in model 2 and each with 10 different seeds, i.e. 89757,35577,51105,72551,10642,69834,47945,52857,26894,99789. For a given seed, 6 random forests are trained with mtry = 1 to 6, and the one with the minimum RMSE(OOB) is chosen.


Model 4
-------

Model 4 is the same as model 3, except that it uses 36 RF-Score features and 6 Vina features. For a given seed, 42 random forests are trained with mtry = 1 to 42, and the one with the minimum RMSE(OOB) is chosen.


Model 5
-------

Model 5 is the same as model 3, except that it uses 5 Vina features, i.e. gauss1, gauss2, repulsion, hydrophobic and hydrogenbonding. For a given seed, 5 random forests are trained with mtry = 1 to 5, and the one with the minimum RMSE(OOB) is chosen.
