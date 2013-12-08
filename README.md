RF-Score
========

RF-Score is a machine learning approach to predicting protein-ligand binding affinity.

The original RF-Score uses as features the number of occurrences of 36 particular protein-ligand atom type pairs interacting within a certain distance range.

The new RF-Score uses as features both the number of occurrences of 36 particular protein-ligand atom type pairs interacting within a certain distance range and the 5 Vina terms.


Compilation
-----------

Five executables, `rf-prepare`, `rf-train`, `rf-test`, `rf-stat` and `rf-score`, will be compiled in the `bin` folder.

### Linux, Mac OS X, Solaris and FreeBSD

GCC 4.6 or higher is required.

	make

### Windows

Visual Studio 2012 or higher is required.

	msbuild RF-Score.sln /t:Build /p:Configuration=Release


Validation
----------

The original RF-Score is trained on the PDBbind 2007 refined set minus the core set (N = 1105), and tested on the PDBbind 2007 core set (N = 195). To reproduce the results presented in the original paper [DOI: 10.1093/bioinformatics/btq112], two csv files `pdbbind2007-refined-core-yx36i.csv` and `pdbbind2007-core-yx36i.csv` are provided and they contain the 36 RF-Score features only, without the 5 Vina terms.

	rf-train pdbbind2007-refined-core-yx36i.csv pdbbind2007-refined-core-x36.rf

	Training 10 random forests of 500 trees with mtry from 1 to 10 and seed 89757 using 4 threads
	mtry = 5 yields the minimum MSE
	Mean of squared residuals: 2.302
		        Var explained: 0.485
	Var %incMSE   Tgini
	  0  25.935 642.539
	  1  24.288 602.268
	  2  25.544 545.174
	  3  22.687 217.975
	  4  22.638 294.269
	  5  21.110 258.209
	  6  20.850 246.132
	  7  18.806 116.258
	  8  23.999 223.278
	  9  24.044 226.904
	 10  22.484 214.130
	 11  17.475 156.319
	 12  15.090 128.506
	 13  17.245 113.058
	 14  14.720  97.564
	 15   9.433  34.583
	 16  14.510  76.825
	 17  14.990  72.074
	 18  11.962  62.495
	 19   5.183  33.337
	 20   4.752  19.646
	 21   6.724  23.967
	 22   4.169  18.251
	 23   3.834  11.693
	 24   3.341  18.307
	 25   3.726  17.843
	 26   2.288  18.412
	 27   6.616  14.567
	 28   4.257   9.090
	 29   3.712   8.617
	 30   5.405   8.909
	 31   3.787   6.518
	 32  -1.710   3.140
	 33  -2.608   2.629
	 34  -1.333   2.478
	 35   1.526   2.951

	rf-test pdbbind2007-refined-core-x36.rf pdbbind2007-refined-core-yx36i.csv pred-ipy.csv

	N 1105
	rmse 0.738
	sdev 0.545
	pcor 0.952
	scor 0.953
	kcor 0.817

	rf-test pdbbind2007-refined-core-x36.rf pdbbind2007-core-yx36i.csv pred-ipy.csv

	N 195
	rmse 1.584
	sdev 2.520
	pcor 0.775
	scor 0.760
	kcor 0.566


Results
-------

The new RF-Score is trained and tested on the same data sets to make a fair comparison. Two csv files `pdbbind2007-refined-core-yx41i.csv` and `pdbbind2007-core-yx41i.csv` are provided and they contain both the 36 RF-Score features and the 5 Vina terms.

	rf-train pdbbind2007-refined-core-yx41i.csv pdbbind2007-refined-core-x41.rf

	Training 11 random forests of 500 trees with mtry from 1 to 11 and seed 89757 using 4 threads
	mtry = 5 yields the minimum MSE
	Mean of squared residuals: 2.152
		        Var explained: 0.519
	Var %incMSE   Tgini
	  0  21.487 465.368
	  1  19.547 402.833
	  2  19.361 347.540
	  3  19.890 143.541
	  4  20.534 230.964
	  5  18.461 192.873
	  6  17.987 165.694
	  7  13.532  84.628
	  8  18.819 153.822
	  9  21.225 166.770
	 10  17.900 146.185
	 11  13.699 119.640
	 12  14.680 107.858
	 13  15.297  94.251
	 14  13.273  97.268
	 15   8.955  28.373
	 16  11.676  54.727
	 17  11.134  52.022
	 18  10.644  52.076
	 19   4.133  27.430
	 20   3.856  16.642
	 21   3.663  20.207
	 22   3.519  15.770
	 23   4.014  10.507
	 24   2.337  14.060
	 25   2.326  13.154
	 26   3.888  15.627
	 27   2.724  10.550
	 28   3.698   7.677
	 29   4.867   6.127
	 30   3.049   6.524
	 31   2.348   5.455
	 32  -0.973   1.925
	 33   0.112   2.214
	 34  -0.637   1.498
	 35  -0.594   1.942
	 36  18.707 332.743
	 37  17.558 397.357
	 38  18.260 162.003
	 39  22.403 312.299
	 40  17.186 169.003

	rf-test pdbbind2007-refined-core-x41.rf pdbbind2007-refined-core-yx41i.csv pred-ipy.csv

	N 1105
	rmse 0.668
	sdev 0.447
	pcor 0.963
	scor 0.963
	kcor 0.838

	rf-test pdbbind2007-refined-core-x41.rf pdbbind2007-core-yx41i.csv pred-ipy.csv

	N 195
	rmse 1.554
	sdev 2.423
	pcor 0.787
	scor 0.775
	kcor 0.582

Here is a comparison of prediction performance of the original and the new RF-Score.

<table>
  <tr>
    <th></th><th>original RF-Score</th><th>new RF-Score</th>
  </tr>
  <tr>
    <td colspan="3">Evaluation on OOB (out-of-bag) data</td>
  </tr>
  <tr>
    <td>mse</td><td>2.302</td><td>2.152</td>
  </tr>
  <tr>
    <td>rsq</td><td>0.485</td><td>0.519</td>
  </tr>
  <tr>
    <td colspan="3">Evaluation on training samples (N = 1105)</td>
  </tr>
  <tr>
    <td>rmse</td><td>0.738</td><td>0.668</td>
  </tr>
  <tr>
    <td>sdev</td><td>0.545</td><td>0.447</td>
  </tr>
  <tr>
    <td>pcor</td><td>0.952</td><td>0.963</td>
  </tr>
  <tr>
    <td>scor</td><td>0.953</td><td>0.963</td>
  </tr>
  <tr>
    <td>kcor</td><td>0.817</td><td>0.838</td>
  </tr>
  <tr>
    <td colspan="3">Evaluation on testing samples (N = 195)</td>
  </tr>
  <tr>
    <td>rmse</td><td>1.584</td><td>1.554</td>
  </tr>
  <tr>
    <td>sdev</td><td>2.520</td><td>2.423</td>
  </tr>
  <tr>
    <td>pcor</td><td>0.775</td><td>0.787</td>
  </tr>
  <tr>
    <td>scor</td><td>0.760</td><td>0.775</td>
  </tr>
  <tr>
    <td>kcor</td><td>0.566</td><td>0.582</td>
  </tr>
</table>


Usage
-----

RF-Score can be easily re-trained and re-tested on newer version of PDBbind (e.g. v2012) for prospective prediction purpose.

### rf-prepare

It traverses the PDBbind folder to load proteins and ligands in pdbqt format, and extracts 36 RF-Score features and 5 Vina terms to a csv file.

It requires PDBbind and MGLTools as prerequisites.

	curl -O http://pdbbind.org.cn/download/pdbbind_v2012.tar.gz
	tar zxf pdbbind_v2012.tar.gz
	curl -O http://mgltools.scripps.edu/downloads/downloads/tars/releases/REL1.5.6/mgltools_x86_64Linux2_1.5.6.tar.gz
	tar zxf mgltools_x86_64Linux2_1.5.6.tar.gz
	cd mgltools_x86_64Linux2_1.5.6
	./install.sh -c 1

It requires pdbqt as input format in order to extract the 5 Vina terms.

	tail -n +6 ../v2012/INDEX_refined_data.2012 | while read -r line; do
		code=${line:0:4}
		bin/pythonsh MGLToolsPckgs/AutoDockTools/Utilities24/prepare_receptor4.py -r ../v2012/${code}/${code}_protein.pdb -U nphs_lps_waters_deleteAltB
		bin/pythonsh MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py -l ../v2012/${code}/${code}_ligand.mol2
	done

Here shows how to prepare testing samples from the PDBbind 2012 core set.

	cd ../v2012
	tail -n +6 INDEX_core_data.2012 | while read -r line; do
		echo $line | cut -d' ' -f1,4 --output-delimiter=, >> pdbbind2012-core-iy.csv
	done
	rf-prepare pdbbind2012-core-iy.csv pdbbind2012-core-yx41i.csv

Here shows how to prepare training samples from the PDBbind 2012 refined set minus the core set.

	core=$(tail -n +6 INDEX_core_data.2012 | cut -d' ' -f1);\
	tail -n +6 INDEX_refined_data.2012 | while read -r line; do
		if [[ 1 = $(echo ${core} | grep ${line:0:4} | wc -l) ]]; then continue; fi
		echo $line | cut -d' ' -f1,4 --output-delimiter=, >> pdbbind2012-refined-core-iy.csv
	done
	rf-prepare pdbbind2012-refined-core-iy.csv pdbbind2012-refined-core-yx41i.csv

### rf-train

It trains multiple random forests of different mtry values in parallel, selects the best one with the minimum MSE, outputs its statistics, and saves it to a binary file.

	rf-train pdbbind2012-refined-core-yx41i.csv pdbbind2012-refined-core-x41.rf

### rf-test

It loads a random forest from a binary file, predicts the RF-Score values of testing samples, saves them to a csv file, and evaluates the prediction performance.

	rf-test pdbbind2012-refined-core-x41.rf pdbbind2012-refined-core-yx41i.csv pred-ipy.csv
	rf-test pdbbind2012-refined-core-x41.rf pdbbind2012-core-yx41i.csv pred-ipy.csv

### rf-stat

It loads two vectors of values from standard input and computes their rmse, sdev, pcor, scor and kcor.

	tail -n +2 pred-ipy.csv | cut -d',' -f2,3 | rf-stat

### rf-score

It loads a random forest from a binary file, parses a receptor and multiple conformations of a ligand, generates their RF-Score features and Vina terms, and score them.

	rf-score pdbbind2012-refined-core-x41.rf receptor.pdbqt ligand.pdbqt


Author
------

[Hongjian Li]


License
-------

[Apache License 2.0]


Reference
---------

Pedro J. Ballester and John B. O. Mitchell. A machine learning approach to predicting protein-ligand binding affinity with applications to molecular docking. Bioinformatics, 26(9):1169-1175,2010. [DOI: 10.1093/bioinformatics/btq112]


[Hongjian Li]: http://www.cse.cuhk.edu.hk/~hjli
[Apache License 2.0]: http://www.apache.org/licenses/LICENSE-2.0
[DOI: 10.1093/bioinformatics/btq112]: http://dx.doi.org/10.1093/bioinformatics/btq112