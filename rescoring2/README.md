# Rescoring models 2

Several models for ranking protein-ligand complexes according to predicted binding affinity in the presence of pose generation error are evaluated and compared on five schemes of five training-test set partitions, and these models are evaluated in terms of discriminating between active and inactive ligands on the DUD-E benchmark.

## Models

### Model 1

Vina

### Model 2

MLR::Vina. The sampling range for wNrot is extended to [0.000 to 0.030] with a step size of 0.001 because of more variability in the 5 schemes.

### Model 3

RF-Score::Vina

### Model 4

RF-Score::VinaUElem

## Datasets

### Dataset 1

The test set 0) and the training set 1) are as follows:

0) PDBbind v2007 core set (N = 195). This test set is the one used in the RF-Score paper. Therefore it has N = 195.

1) PDBbind v2007 refined set (N = 1300) minus PDBbind v2007 core set (N = 195). This training set is the one used in the RF-Score paper. Therefore it has N = 1105. Note that every complex in the test set has complexes involving the same protein in this training set.

Their intersections are as follows:

* |0 ∩ 1| = 0

Having the test set docked by Vina, the number of complexes where the pose with the lowest Vina score has RMSD < 2.0 is 100 (100 / 195 = 51%), and the numbers of complexes whose ith (i=0,1,...,9) docking pose has the lowest RMSD are as follows:

* |RMSD1 = RMSDmin| = 93
* |RMSD2 = RMSDmin| = 27
* |RMSD3 = RMSDmin| = 13
* |RMSD4 = RMSDmin| = 14
* |RMSD5 = RMSDmin| = 10
* |RMSD6 = RMSDmin| = 11
* |RMSD7 = RMSDmin| = 14
* |RMSD8 = RMSDmin| = 6
* |RMSD9 = RMSDmin| = 7

Therefore, the % of complexes where the pose with the lowest Vina score also has the lowest RMSD is 93 / 195 = 48%.

### Dataset 2

The test set 0) and the four training sets 1), 2), 3), 4) are as follows:

0) PDBbind v2013 refined set (N = 2959) minus PDBbind v2012 refined set (N = 2897). Both sets have 2576 complexes in common. The 3rv4 protein consists of two Cs atoms which Vina does not support. Therefore this test set has N = 2959 - 2576 - 1 = 382 complexes.

1) PDBbind v2002 refined set (N = 800). The 1tha protein fails PDB-to-PDBQT conversion by prepare_receptor4.py. The 1lkk, 1mfi, 7std, 1cet, 2std, 1els, 1c3x ligands fail PDB-to-PDBQT conversion by prepare_ligand4.py. Therefore this training set has N = 800 - 8 = 792 complexes. Note that in 584 \*\_protein.pdbqt's (e.g. 1gvu, 1bxo) the Ho atom type is incorrectly assigned to the HOCA atom, which is a polar hydrogen atom bonded to the OXT atom of the last residue. Therefore these \*\_protein.pdbqt's are curated by sed 's/Ho/HD/g' in batch. Also note that in 39 \*\_ligand.mol2's (e.g. 1cil, 1duv) the x, y, z coordinates are of 14.8 format instead of the official 10.4 format.

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
* |3 ∩ 4| = 2030

Having the test set docked by Vina, the number of complexes where the pose with the lowest Vina score has RMSD < 2.0 is 219 (219 / 382 = 57%), and the numbers of complexes whose ith (i=0,1,...,9) docking pose has the lowest RMSD are as follows:

* |RMSD1 = RMSDmin| = 208
* |RMSD2 = RMSDmin| = 52
* |RMSD3 = RMSDmin| = 34
* |RMSD4 = RMSDmin| = 17
* |RMSD5 = RMSDmin| = 19
* |RMSD6 = RMSDmin| = 13
* |RMSD7 = RMSDmin| = 16
* |RMSD8 = RMSDmin| = 9
* |RMSD9 = RMSDmin| = 14

Therefore, the % of complexes where the pose with the lowest Vina score also has the lowest RMSD is 208 / 382 = 54%.

## Schemes

There are 11 features from Vina for each pose, either crystal of docked. They are gauss1, gauss2, repulsion, hydrophobic, hydrogenbonding from e_inter and e_intra, and Nrot, which is independent of pose.

There are 36 features from RF-Score for each pose.

### Scheme 1

Features are calculated for the crystal structure.

### Scheme 2

Features are calculated for the docking pose with the lowest Vina score.

### Scheme 3

Features are calculated for the docking pose with the lowest RMSD.

### Scheme 4

Features are calculated for the docking pose with a Vina score closest the measured binding affinity of that complex.

### Scheme 5

Features are calculated for all the 9 docking poses. If a structure produces less than 9 docking poses, the features of the pose with the lowest Vina score are repeated, e.g. 1 + 1 + 1 + 2 + 3 + 4 + 5 + 6 + 7. Therefore there are 10 * 9 + 1 = 91 features for model 2 and 3, and (36 + 10) * 9 + 1 = 415 features for model 4.

## Benchmarks

* 1 models (1) \* 1 training schemes (1) \* 2 test schemes (1, 2) = 2 variants
* 3 models (2, 3, 4) \* 4 training schemes (1, 2, 3, 4) \* 2 test schemes (1, 2) = 24 variants
* 3 models (2, 3, 4) \* 1 training schemes (5) \* 1 test schemes (5) = 3 variants

There are 29 variants and 5 training-test set partitions, so altogether there are 29 * 5 = 145 sets of performance measures.

The folders and files are organized hierarchically, e.g. model3/set1/pdbbind-2007-trn-1-tst-2-stat.csv means the statistics CSV of model 3 on dataset 1 and PDBbind v2007 trained in scheme 1 and tested in scheme 2.
