# Rescoring models 2

Several models for ranking protein-ligand complexes according to predicted binding affinity in the presence of pose generation error are evaluated and compared on five schemes of five training-test set partitions, and these models are evaluated in terms of discriminating between active and inactive ligands on the DUD-E benchmark.

## Models

### Model 1

Vina

### Model 2

MLR::Vina

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

### Dataset 2

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
* |3 ∩ 4| = 2030

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

* 1 models (i.e. 1) \* 2 test schemes (i.e. 1, 2) \* 1 training schemes (i.e. 1) = 2 variants
* 3 models (i.e. 2, 3, 4) \* 2 test schemes (i.e. 1, 2) \* 4 training schemes (i.e. 1, 2, 3, 4) = 24 variants
* 3 models (i.e. 2, 3, 4) \* 1 test schemes (i.e. 5) \* 1 training schemes (i.e. 5) = 3 variants

There are 29 variants and 5 training-test set partitions, so altogether there are 29 * 5 = 145 sets of performance measures.

The folders are organized hierarchically, e.g. model3/set1/tst1/trn1 means model 3 using dataset 1, test scheme 1 and training scheme 1.
