# Rescoring models 2

Several models for ranking protein-ligand complexes according to predicted binding affinity in the presence of pose generation error are evaluated and compared on six schemes of five training-test set partitions.

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

## Schemes

In the schemes below, different poses are chosen to calculate the features.

### Scheme 1

The chosen pose is the crystal pose.

### Scheme 2

The chosen pose is the docked pose with the lowest Vina score.

### Scheme 3

The chosen pose is the docked pose with the lowest RMSD.

### Scheme 4

The chosen pose is the docked pose with a Vina score closest the measured binding affinity of that complex.

### Scheme 5

The chosen poses are all the 9 docked poses. If a structure produces less than 9 docked poses, the features of the pose with the lowest Vina score are repeated, e.g. 1 + 1 + 1 + 2 + 3 + 4 + 5 + 6 + 7. Therefore there are 10 * 9 + 1 = 91 features for model 2 and 3, and (36 + 10) * 9 + 1 = 415 features for model 4.

### Scheme 6

The chosen poses are the 2 docked poses with the lowest and the second lowest Vina score. If a structure produces less than 2 docked poses, the features of the pose with the lowest Vina score are repeated, e.g. 1 + 1. Therefore there are 10 * 2 + 1 = 21 features for model 2 and 3, and (36 + 10) * 2 + 1 = 93 features for model 4.

## Experiments

By combining the 4 models and the 6 schemes, 32 combinations are evaluated:

* 1 models (1) \* 1 training schemes (1) \* 2 test schemes (1, 2) = 2 combinations
* 3 models (2, 3, 4) \* 4 training schemes (1, 2, 3, 4) \* 2 test schemes (1, 2) = 24 combinations
* 3 models (2, 3, 4) \* 1 training schemes (5) \* 1 test schemes (5) = 3 combinations
* 3 models (2, 3, 4) \* 1 training schemes (6) \* 1 test schemes (6) = 3 combinations

There are 5 training-test set partitions, so altogether there are 32 * 5 = 160 sets of performance measures.

For model 2, the sampling range for wNrot is extended to [0.000 to 0.030] with a step size of 0.001 because of more variability in the 6 schemes.

For models 3 and 4, the mtry values are exhausted from 1 to the number of features.

## Files

The folders and files are organized hierarchically. Model-specific files are in the model{1,2,3,4} folders. Cross-model files are in the set{1,2} folders.

For data files, their nomenclature are as follows:

* i means PDB ID
* y means measured pKd
* p means predicted pKd
* d means RMSD

For example,

* `set1/tst-1-iy.csv` means the [PDB,pbindaff] file of the test set in scheme 1 of dataset 1, i.e. the PDB ID and measured pKd of the crystal poses of PDBbind v2007 core set.
* `set1/tst-2-id.csv` means the [PDB,RMSD1] file of the test set in scheme 2 of dataset 1, i.e. the PDB ID and RMSD of the docked pose with the lowest Vina score of PDBbind v2007 core set.
* `model3/set1/89757/pdbbind-2007-trn-3-tst-2-iyp.csv` means the [PDB,pbindaff,predicted] file of model 3 on dataset 1 and PDBbind v2007 trained in scheme 3 with seed 89757 and tested in scheme 2.
* `model3/set1/pdbbind-2007-trn-4-tst-1-stat.csv` means the [seed,n,rmse,sdev,pcor,scor,kcor] file of model 3 on dataset 1 and PDBbind v2007 trained in scheme 4 and tested in scheme 1, over all seeds.
* `model3/set1/tst-stat.csv` means the [v,trn,tst,w,n,rmse,sdev,pcor,scor,kcor] file of model 3 on dataset 1, over all PDBbind versions, all training schemes and all test schemes. For each [v,trn,tst] combination, only the best seed for models 3 and 4 or the best weight for model 2 is shown in the w column.

For script files, their functions and execution orders are as follows:

* `pdbbind.sh` does file format conversion, binding site detection, docking by Vina, RMSD computation, and finding the corresponding pose in schemes 1, 2, 3, 4, all in the PDBbind folder.
* `model1prepare.sh` generates model1/set{1,2}/pdbbind-2007-trn-1-tst-{1,2}-iyp.csv.
* `model4prepare.sh` generates model4/set{1,2}/{tst-{1,2,3,4,5,6}-yxi.csv,pdbbind-$v-trn-{1,2,3,4,5,6}-yxi.csv}.
* `model1.sh` tests model 1 and generates model1/set{1,2}/pdbbind-2007-trn-1-tst-{1,2}-stat.csv.
* `model2.sh` trains and tests model 2 with a grid search of wNrot in [0.000 to 0.030] with a step size of 0.001, and generates model2/set{1,2}/tst-stat.csv.
* `model3.sh` trains and tests models 3 and 4 with 10 seeds, and generates model{3,4}/set{1,2}/tst-stat.csv.
* `maxerr.sh` finds the top 10 complexes with the largest absolute error between measured pKd and model 1 pKd and between measured pKd and model 4 pKd in test schemes 1 and 2. Its output is saved to maxerr.csv.
* `mlrtrain.R` trains model 2 on model2/set{1,2}/$w/pdbbind-$v-trn-{1,2,3,4,5,6}-yxi.csv using multiple linear regression, and writes the coefficients to model2/set{1,2}/$w/pdbbind-$v-trn-{1,2,3,4,5,6}-coef.csv.
* `mlrtest.R` tests model 2 on model2/set{1,2}/tst-{1,2}-yxi.csv, and writes the statistics to model2/set{1,2}/$w/pdbbind-$v-trn-{1,2,3,4,5,6}-tst-{1,2}-stat.csv.
* `iypplot.R` plots models{1,2,3,4}/set{1,2}/pdbbind-$v-trn-{1,2,3,4,5,6}-tst-{1,2}-iyp.tiff.
* `idpplot.R` plots models{1,2,3,4}/set{1,2}/pdbbind-$v-trn-{1,2,3,4,5,6}-tst-{1,2}-idp.tiff.
* `varImpPlot.R` plots models{3,4}/set{1,2}/$w/pdbbind-$v-trn-{1,2,3,4,5,6}-varimpplot.tiff.
* `boxmed.R` plots model{2,3,4}/set{1,2}/trn-{1,2,3,4,5,6}-tst-{1,2,5,6}-{rmse,sdev,pcor,scor,kcor}-{boxplot,median}.tiff, set{1,2}/pdbbind-$v-trn-{1,2,3,4,5,6}-tst-{1,2,5,6}-{rmse,sdev,pcor,scor,kcor}-{boxplot,median}.tiff, and set{1,2}/trn-{1,2,3,4,5,6}-tst-{1,2,5,6}-{rmse,sdev,pcor,scor,kcor}-{boxplot,median}.tiff. This R script is self contained and requires no command line arguments. It is not called in any bash scripts and therefore should be called in the end.

## Results

### Rescoring docked poses on dataset 1

Having the test set docked by Vina, the number of complexes where the pose with the lowest Vina score has RMSD < 2.0 is 100 (100 / 195 = 51%).

The numbers of complexes whose docked pose with the ith (i=0,1,...,9) best model score has the lowest RMSD are as follows:

#### For model 1

* |RMSD1 = RMSDmin| = 93
* |RMSD2 = RMSDmin| = 27
* |RMSD3 = RMSDmin| = 13
* |RMSD4 = RMSDmin| = 14
* |RMSD5 = RMSDmin| = 10
* |RMSD6 = RMSDmin| = 11
* |RMSD7 = RMSDmin| = 14
* |RMSD8 = RMSDmin| = 6
* |RMSD9 = RMSDmin| = 7

Therefore, the % of complexes where the pose with the best model 1 score (i.e. the lowest Vina score) also has the lowest RMSD is 93 / 195 = 48%.

#### For model 2, trained on scheme 1 using the best weight 0.015

* |RMSD1 = RMSDmin| = 60
* |RMSD2 = RMSDmin| = 28
* |RMSD3 = RMSDmin| = 19
* |RMSD4 = RMSDmin| = 23
* |RMSD5 = RMSDmin| = 16
* |RMSD6 = RMSDmin| = 12
* |RMSD7 = RMSDmin| = 11
* |RMSD8 = RMSDmin| = 11
* |RMSD9 = RMSDmin| = 15

Therefore, the % of complexes where the pose with the best model 2 score also has the lowest RMSD is 60 / 195 = 31%.

#### For model 3, trained on scheme 1 using the best seed 10642

* |RMSD1 = RMSDmin| = 33
* |RMSD2 = RMSDmin| = 30
* |RMSD3 = RMSDmin| = 19
* |RMSD4 = RMSDmin| = 19
* |RMSD5 = RMSDmin| = 24
* |RMSD6 = RMSDmin| = 22
* |RMSD7 = RMSDmin| = 14
* |RMSD8 = RMSDmin| = 14
* |RMSD9 = RMSDmin| = 20

Therefore, the % of complexes where the pose with the best model 3 score also has the lowest RMSD is 33 / 195 = 17%.

#### For model 4, trained on scheme 1 using the best seed 89757

* |RMSD1 = RMSDmin| = 39
* |RMSD2 = RMSDmin| = 29
* |RMSD3 = RMSDmin| = 23
* |RMSD4 = RMSDmin| = 15
* |RMSD5 = RMSDmin| = 20
* |RMSD6 = RMSDmin| = 22
* |RMSD7 = RMSDmin| = 19
* |RMSD8 = RMSDmin| = 16
* |RMSD9 = RMSDmin| = 12

Therefore, the % of complexes where the pose with the best model 3 score also has the lowest RMSD is 39 / 195 = 20%.

### Rescoring docked poses on dataset 2

Having the test set docked by Vina, the number of complexes where the pose with the lowest Vina score has RMSD < 2.0 is 219 (219 / 382 = 57%), and the numbers of complexes whose ith (i=0,1,...,9) docked pose has the lowest RMSD are as follows:

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
