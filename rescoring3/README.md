# Rescoring models 3

Several models for rescoring protein-ligand complexes are evaluated and compared on different protein families.

## Models

### Model 1

Vina

### Model 2

MLR::Vina

### Model 3

RF::Vina

### Model 4

RF::VinaElem

## Datasets

### Dataset 3

The test set 0) and the three training sets 1), 2), 3) are as follows:

0) PDBbind v2013 refined set (N = 2959) minus PDBbind v2010 refined set (N = 2061). Both sets have 1842 complexes in common. The 3rv4 protein consists of two Cs atoms which Vina does not support. The 2bo4 and 1xr8 complexes are excluded from PDBbind v2010 refined set, so they are added back to this test set. Therefore this test set has N = 2959 - 1842 - 1 + 2 = 1118 complexes.

1) PDBbind v2002 refined set (N = 800). The 1tha protein fails PDB-to-PDBQT conversion by prepare_receptor4.py. The 1lkk, 1mfi, 7std, 1cet, 2std, 1els, 1c3x ligands fail PDB-to-PDBQT conversion by prepare_ligand4.py. It and the test set have 29 complexes in common. Therefore this training set has N = 800 - 8 - 29 = 763 complexes.

2) PDBbind v2007 refined set (N = 1300). It and the test set have 3 complexes in common. Therefore this training set has N = 1300 - 3 = 1297 complexes.

3) PDBbind v2010 refined set (N = 2061). The 2bo4 protein fails PDB-to-PDBQT conversion by prepare_receptor4.py. The 1xr8 ligand is far away from its protein. Therefore this training set has N = 2061 - 2 = 2059 complexes.

Their intersections are as follows:

* |0 ∩ 1| = 0
* |0 ∩ 2| = 0
* |0 ∩ 3| = 0
* |1 ∩ 2| = 592
* |1 ∩ 3| = 536
* |2 ∩ 3| = 1178

## Files

The folders and files are organized hierarchically. Model-specific files are in the model{1,2,3,4} folders. Cross-model files are in the set3 folder.

For data files, their nomenclature are as follows:

*  0 means all
*  1 means HSP90
*  2 means CAH2
*  3 means TRY1
*  4 means HIVPR
*  5 means THRB
*  6 means all\HSP90
*  7 means all\CAH2
*  8 means all\TRY1
*  9 means all\HIVPR
* 10 means all\THRB
* 11 means the 10 nearest neighbours in PDBbind v2010 refined set for each HSP90 complex in the test set
* 12 means the 10 nearest neighbours in PDBbind v2010 refined set for each CAH2 complex in the test set
* 13 means the 10 nearest neighbours in PDBbind v2010 refined set for each TRY1 complex in the test set
* 14 means the 10 nearest neighbours in PDBbind v2010 refined set for each HIVPR complex in the test set
* 15 means the 10 nearest neighbours in PDBbind v2010 refined set for each THRB complex in the test set
* 16 means the 50 nearest neighbours in PDBbind v2010 refined set for each HSP90 complex in the test set
* 17 means the 50 nearest neighbours in PDBbind v2010 refined set for each CAH2 complex in the test set
* 18 means the 50 nearest neighbours in PDBbind v2010 refined set for each TRY1 complex in the test set
* 19 means the 50 nearest neighbours in PDBbind v2010 refined set for each HIVPR complex in the test set
* 20 means the 50 nearest neighbours in PDBbind v2010 refined set for each THRB complex in the test set
* 21 means the 100 nearest neighbours in PDBbind v2010 refined set for each HSP90 complex in the test set
* 22 means the 100 nearest neighbours in PDBbind v2010 refined set for each CAH2 complex in the test set
* 23 means the 100 nearest neighbours in PDBbind v2010 refined set for each TRY1 complex in the test set
* 24 means the 100 nearest neighbours in PDBbind v2010 refined set for each HIVPR complex in the test set
* 25 means the 100 nearest neighbours in PDBbind v2010 refined set for each THRB complex in the test set
* 26 means the 150 nearest neighbours in PDBbind v2010 refined set for each HSP90 complex in the test set
* 27 means the 150 nearest neighbours in PDBbind v2010 refined set for each CAH2 complex in the test set
* 28 means the 150 nearest neighbours in PDBbind v2010 refined set for each TRY1 complex in the test set
* 29 means the 150 nearest neighbours in PDBbind v2010 refined set for each HIVPR complex in the test set
* 30 means the 150 nearest neighbours in PDBbind v2010 refined set for each THRB complex in the test set
* 31 means the 200 nearest neighbours in PDBbind v2010 refined set for each HSP90 complex in the test set
* 32 means the 200 nearest neighbours in PDBbind v2010 refined set for each CAH2 complex in the test set
* 33 means the 200 nearest neighbours in PDBbind v2010 refined set for each TRY1 complex in the test set
* 34 means the 200 nearest neighbours in PDBbind v2010 refined set for each HIVPR complex in the test set
* 35 means the 200 nearest neighbours in PDBbind v2010 refined set for each THRB complex in the test set

For example,

* `set3/trn-0-tst-0-rmse.tiff` means the median plot of RMSE of the four models trained on all complexes of PDBbind v2002, v2007 and v2012 refined sets and tested on all complexes of PDBbind v2013\v2010 refined set.
* `set3/trn-0-tst-1-rmse.tiff` means the median plot of RMSE of the four models trained on all complexes of PDBbind v2002, v2007 and v2012 refined sets and tested on HSP90 complexes of PDBbind v2013\v2010 refined set.
* `set3/trn-2-tst-2-rmse.tiff` means the median plot of RMSE of the four models trained on CAH2, non-CAH2 and all complexes of PDBbind v2010 refined set and tested on CAH2 complexes of PDBbind v2013\v2010 refined set.
* `set3/trn-13-tst-3-rmse.tiff` means the median plot of RMSE of the four models trained on PDBbind v2010 refined set complexes identified as the 10, 50, 100, 150, 200 nearest neighbours of TRY1 complexes in the test set and tested on TRY1 complexes of PDBbind v2013\v2010 refined set.
