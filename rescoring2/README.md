Rescoring models 2
==================

Several models for ranking protein-ligand complexes according to predicted binding affinity in the presence of pose generation error are evaluated and compared on five schemes of five training-test set partitions, and these models are evaluated in terms of discriminating between active and inactive ligands on the DUD-E benchmark.


Scheme 1
--------

11 features are calculated for the crystal structure.


Scheme 2
--------

11 features are calculated for the docking pose with the lowest Vina score.


Scheme 3
--------

11 features are calculated for the docking pose with the lowest RMSD.


Scheme 4
--------

11 features are calculated for the docking pose with a Vina score closest the measured binding affinity of that complex.


Scheme 5
--------

91=10*9+1 features are calculated for the 9 docking poses. If the docking output has less than 9 poses, the 10 features of the pose with the lowest Vina score are be repeated, e.g. 1 + 1 + 1 + 2 + 3 + 4 + 5 + 6 + 7.


Dataset 1
---------

The test set 0) and the training set 1) are as follows:

0) PDBbind v2007 core set (N = 195). This test set is the one used in the RF-Score paper. Therefore it has N = 195.

1) PDBbind v2007 refined set (N = 1300) minus PDBbind v2007 core set (N = 195). This training set is the one used in the RF-Score paper. Therefore it has N = 1105. Note that every complex in the test set has complexes involving the same protein in this training set.

Their intersections are as follows:

* |0 ∩ 1| = 0


Dataset 2
---------

The test set 0) and the four training sets 1), 2), 3), 4) are as follows:

0) PDBbind v2013 refined set (N = 2959) minus PDBbind v2012 refined set (N = 2897). Both sets have 2576 complexes in common. The 3rv4 protein consists of two Cs atoms which Vina does not support. Therefore this test set has N = 2959 - 2576 - 1 = 382 complexes.

1) PDBbind v2002 refined set (N = 800). The 1tha protein fails PDB-to-PDBQT conversion by prepare_receptor4.py. The 1lkk, 1mfi, 7std, 1cet, 2std, 1els, 1c3x ligands fail PDB-to-PDBQT conversion by prepare_ligand4.py. Therefore this training set has N = 800 - 8 = 792 complexes. Note that in 584 *_protein.pdbqt's (e.g. 1gvu, 1bxo) the Ho atom type is incorrectly assigned to the HOCA atom, which is a polar hydrogen atom bonded to the OXT atom of the last residue. Therefore these *_protein.pdbqt's are curated by sed 's/Ho/HD/g' in batch. Also note that in 39 *_ligand.mol2's (e.g. 1cil, 1duv) the x, y, z coordinates are of 14.8 format instead of the official 10.4 format.

2) PDBbind v2007 refined set (N = 1300). This training set has N = 1300 complexes.

3) PDBbind v2010 refined set (N = 2061). The 2bo4 protein fails PDB-to-PDBQT conversion by prepare_receptor4.py. The 1xr8 ligand is far away from its protein. The 2rio protein contains Sr atoms and the 2ov4 protein contains Cs atoms, which cannot be recognized by Vina. Therefore this training set has N = 2061 - 4 = 2057 complexes.

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
