RF-Score
========

A machine learning approach to predicting protein-ligand binding affinity.


Compilation
-----------

Four executables, `rf-prepare`, `rf-train`, `rf-test` and `rf-score`, will be compiled.

### Linux, Mac OS X, Solaris and FreeBSD

GCC 4.6 or higher is required.

	make

### Windows

Visual Studio 2012 or higher is required.

	msbuild RF-Score.sln /t:Build /p:Configuration=Release


Validation
----------

Two csv files, `rf-train.csv` and `rf-test.csv`, are provided in order to reproduce the results as presented in the original paper [DOI: 10.1093/bioinformatics/btq112]. They are extracted from PDBbind 2007, and contain the 36 RF-Score features only, without the 5 Vina terms.

	rf-train rf-train.csv rf.data

	Training 10 random forests of 500 trees with mtry from 1 to 10 and seed 89757 using 4 threads
	mtry = 6 yields the minimum MSE
	Mean of squared residuals: 2.295
		        Var explained: 0.487
	Var %incMSE   Tgini
	  0  26.754 706.563
	  1  24.746 571.341
	  2  25.498 562.224
	  3  25.468 214.609
	  4  24.218 314.675
	  5  21.091 250.225
	  6  21.956 264.612
	  7  18.045 109.038
	  8  22.495 229.941
	  9  23.605 219.915
	 10  22.769 215.147
	 11  18.024 161.819
	 12  17.378 120.783
	 13  18.027 129.200
	 14  14.495  99.326
	 15  10.538  34.460
	 16  15.303  75.130
	 17  14.033  73.445
	 18  13.181  66.374
	 19   6.880  31.776
	 20   4.395  22.980
	 21   4.921  23.319
	 22   3.231  17.694
	 23   3.685  10.843
	 24   4.204  18.543
	 25   2.578  17.949
	 26   2.979  19.666
	 27   4.526  11.598
	 28   4.155   9.643
	 29   3.946   8.970
	 30   3.641   8.237
	 31   3.335   6.444
	 32   0.106   1.771
	 33   1.493   2.695
	 34  -2.125   2.554
	 35   1.524   3.278

	rf-test rf.data rf-train.csv rf-pred.csv

	N 1105
	rmse 0.701
	sdev 0.492
	pcor 0.957
	scor 0.958
	kcor 0.827

	rf-test rf.data rf-test.csv rf-pred.csv

	N 195
	rmse 1.582
	sdev 2.513
	pcor 0.772
	scor 0.762
	kcor 0.566


Usage
-----

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
		bin/pythonsh MGLToolsPckgs/AutoDockTools/Utilities24/prepare_receptor4.py -r ../v2012/${code}/${code}_protein.pdb
		bin/pythonsh MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py -l ../v2012/${code}/${code}_ligand.mol2
	done

Here shows how to prepare testing samples from the PDBbind 2012 core set.

	cd ../v2012
	tail -n +6 INDEX_core_data.2012 | while read -r line; do
		echo $line | cut -d' ' -f1,4 >> rf_core_data.2012
	done
	rf-prepare rf_core_data.2012 rf-test.csv

Here shows how to prepare training samples from the PDBbind 2012 refined set minus the core set.

	core=$(tail -n +6 INDEX_core_data.2012 | cut -d' ' -f1);\
	tail -n +6 INDEX_refined_data.2012 | while read -r line; do
		if [[ 1 = $(echo ${core} | grep ${line:0:4} | wc -l) ]]; then continue; fi
		echo $line | cut -d' ' -f1,4 >> rf_refined-core_data.2012
	done
	rf-prepare rf_refined-core_data.2012 rf-train.csv

### rf-train

It trains multiple random forests of different mtry values in parallel, selects the best one with the minimum MSE, outputs its statistics, and saves it to a binary file.

	rf-train rf-train.csv rf.data

### rf-test

It loads a random forest from a binary file, predicts the RF-Score values of testing samples, saves them to a csv file, and evaluates the prediction performance.

	rf-test rf.data rf-train.csv rf-pred.csv
	rf-test rf.data rf-test.csv rf-pred.csv

### rf-score

It loads a random forest from a binary file, parses a receptor and multiple conformations of a ligand, generates their RF-Score features and Vina terms, and score them.

	rf-score rf.data receptor.pdbqt ligand.pdbqt


Results
-------

The original RF-Score was trained on the PDBbind 2007 refined set minus the core set (N = 1105), and tested on the PDBbind 2007 core set (N = 195). To make a fair comparison, two data files, `rf_core_data.2007` and `rf_refined-core_data.2007`, are provided to train and test the new RF-Score on the same data sets. Make sure the PDBbind 2007 proteins and ligands are converted into pdbqt format so that `rf-prepare` can parse them.

	cp rf_core_data.2007 rf_refined-core_data.2007 /path/to/PDBbind/v2007/
	rf-prepare rf_core_data.2007 rf-test.csv
	rf-prepare rf_refined-core_data.2007 rf-train.csv

	rf-train rf-train.csv rf.data

	Training 11 random forests of 500 trees with mtry from 1 to 11 and seed 89757 using 4 threads
	mtry = 5 yields the minimum MSE
	Mean of squared residuals: 2.162
		        Var explained: 0.517
	Var %incMSE   Tgini
	  0  19.082 461.253
	  1  19.882 411.288
	  2  20.106 351.164
	  3  20.694 150.350
	  4  20.417 215.061
	  5  19.269 194.120
	  6  16.765 183.650
	  7  14.441  87.017
	  8  19.079 151.351
	  9  19.186 158.218
	 10  18.818 151.019
	 11  14.305 118.435
	 12  14.572  99.395
	 13  14.788 110.918
	 14  13.376  85.232
	 15   8.641  30.188
	 16  12.765  60.977
	 17  12.274  54.225
	 18  11.445  47.570
	 19   5.269  26.083
	 20   3.035  17.883
	 21   5.719  18.147
	 22   3.535  15.541
	 23   5.162  10.938
	 24   2.093  13.466
	 25   2.956  13.487
	 26   3.926  14.521
	 27   2.506  11.228
	 28   4.563   6.742
	 29   3.773   6.456
	 30   1.756   6.464
	 31   3.377   6.164
	 32   0.361   1.538
	 33  -1.158   2.140
	 34  -0.728   1.689
	 35   1.275   1.679
	 36  18.756 320.278
	 37  16.420 401.151
	 38  16.531 155.744
	 39  23.531 324.131
	 40  17.172 172.968

	rf-test rf.data rf-train.csv rf-pred.csv

	N 1105
	rmse 0.672
	sdev 0.452
	pcor 0.962
	scor 0.963
	kcor 0.837

	rf-test rf.data rf-test.csv rf-pred.csv

	N 195
	rmse 1.535
	sdev 2.364
	pcor 0.796
	scor 0.789
	kcor 0.597

Here is a comparison of prediction performance of the original and the new RF-Score.

<table>
  <tr>
    <th></th><th>original RF-Score</th><th>new RF-Score</th>
  </tr>
  <tr>
    <td colspan="3">Evaluation on OOB (out-of-bag) data</td>
  </tr>
  <tr>
    <td>mse</td><td>2.295</td><td>2.162</td>
  </tr>
  <tr>
    <td>rsq</td><td>0.487</td><td>0.517</td>
  </tr>
  <tr>
    <td colspan="3">Evaluation on training samples (N = 1105)</td>
  </tr>
  <tr>
    <td>rmse</td><td>0.701</td><td>0.672</td>
  </tr>
  <tr>
    <td>sdev</td><td>0.492</td><td>0.452</td>
  </tr>
  <tr>
    <td>pcor</td><td>0.957</td><td>0.962</td>
  </tr>
  <tr>
    <td>scor</td><td>0.958</td><td>0.963</td>
  </tr>
  <tr>
    <td>kcor</td><td>0.827</td><td>0.837</td>
  </tr>
  <tr>
    <td colspan="3">Evaluation on testing samples (N = 195)</td>
  </tr>
  <tr>
    <td>rmse</td><td>1.582</td><td>1.535</td>
  </tr>
  <tr>
    <td>sdev</td><td>2.513</td><td>2.364</td>
  </tr>
  <tr>
    <td>pcor</td><td>0.772</td><td>0.796</td>
  </tr>
  <tr>
    <td>scor</td><td>0.762</td><td>0.789</td>
  </tr>
  <tr>
    <td>kcor</td><td>0.566</td><td>0.597</td>
  </tr>
</table>


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