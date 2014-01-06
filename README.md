RF-Score
========

RF-Score is a machine learning approach to predicting protein-ligand binding affinity.

The original RF-Score uses as features the number of occurrences of 36 particular protein-ligand atom type pairs interacting within a certain distance range.

The new RF-Score uses as features both the number of occurrences of 36 particular protein-ligand atom type pairs interacting within a certain distance range and the 6 Vina terms.


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

The original RF-Score is trained on the PDBbind 2007 refined set minus the core set (N = 1105), and tested on the PDBbind 2007 core set (N = 195). To reproduce the results presented in the original paper [DOI: 10.1093/bioinformatics/btq112], two csv files `pdbbind2007-refined-core-yx36i.csv` and `pdbbind2007-core-yx36i.csv` are provided and they contain the 36 RF-Score features only, without the 6 Vina terms.

	rf-train pdbbind2007-refined-core-yx36i.csv pdbbind2007-refined-core-x36.rf

	Training 13 random forests of 500 trees with mtry from 1 to 13 and seed 89757 using 4 threads
	mtry = 4 yields the minimum MSE
	Mean of squared residuals: 2.301
		        Var explained: 0.485
	Var %incMSE   Tgini
	  0  26.164 621.519
	  1  23.905 554.511
	  2  24.408 518.618
	  3  25.432 205.484
	  4  22.116 289.809
	  5  20.306 247.300
	  6  19.495 240.324
	  7  17.961 109.529
	  8  22.250 214.313
	  9  19.536 204.726
	 10  19.018 211.767
	 11  18.881 154.099
	 12  14.733 114.316
	 13  15.313 118.103
	 14  14.545 102.707
	 15   9.883  35.830
	 16  14.244  79.191
	 17  15.433  72.213
	 18  11.154  59.153
	 19   7.155  34.209
	 20   5.888  24.767
	 21   6.419  25.161
	 22   4.153  23.133
	 23   3.965  12.435
	 24   3.447  20.416
	 25   4.753  18.495
	 26   5.551  20.016
	 27   5.264  14.582
	 28   3.728  10.901
	 29   3.065   7.803
	 30   5.365   8.106
	 31   5.062   6.758
	 32  -0.510   3.391
	 33   0.698   3.532
	 34  -0.235   3.380
	 35   1.380   3.250

	rf-test pdbbind2007-refined-core-x36.rf pdbbind2007-refined-core-yx36i.csv pdbbind2007-refined-core-iyp.csv

	n,rmse,sdev,pcor,scor,kcor
	1105,0.796,0.797,0.943,0.944,0.800

	rf-test pdbbind2007-refined-core-x36.rf pdbbind2007-core-yx36i.csv pdbbind2007-core-iyp.csv

	n,rmse,sdev,pcor,scor,kcor
	195,1.589,1.594,0.775,0.760,0.566


Results
-------

The new RF-Score is trained and tested on the same data sets to make a fair comparison. Two csv files `pdbbind2007-refined-core-yx42i.csv` and `pdbbind2007-core-yx42i.csv` are provided and they contain both the 36 RF-Score features and the 6 Vina terms.

	rf-train pdbbind2007-refined-core-yx42i.csv pdbbind2007-refined-core-x42.rf

	Training 15 random forests of 500 trees with mtry from 1 to 15 and seed 89757 using 4 threads
	mtry = 9 yields the minimum MSE
	Mean of squared residuals: 2.128
		        Var explained: 0.524
	Var %incMSE   Tgini
	  0  21.755 550.266
	  1  17.598 438.100
	  2  19.657 373.636
	  3  17.243 133.640
	  4  19.444 198.714
	  5  19.721 174.132
	  6  17.926 153.351
	  7  14.230  70.972
	  8  17.174 141.562
	  9  19.377 147.133
	 10  18.503 136.075
	 11  12.324 109.298
	 12  15.398 115.930
	 13  16.713 119.591
	 14  13.023  83.390
	 15   8.315  21.282
	 16   9.978  44.357
	 17  11.073  47.533
	 18   9.712  43.058
	 19   4.909  19.091
	 20   1.567  10.963
	 21   4.232  14.235
	 22   3.021  11.361
	 23   3.412   8.474
	 24   1.806  11.733
	 25   0.922  10.777
	 26   2.978  13.660
	 27   3.512   9.201
	 28   2.472   6.546
	 29   2.447   6.091
	 30   3.093   6.100
	 31   2.876   4.858
	 32   0.874   1.437
	 33   0.982   1.432
	 34   0.082   1.548
	 35  -0.034   1.508
	 36  20.893 332.244
	 37  17.516 392.059
	 38  13.692 159.278
	 39  22.114 295.859
	 40  15.090 183.206
	 41  17.639 155.409

	rf-test pdbbind2007-refined-core-x42.rf pdbbind2007-refined-core-yx42i.csv pdbbind2007-refined-core-iyp.csv

	n,rmse,sdev,pcor,scor,kcor
	1105,0.621,0.622,0.968,0.969,0.853

	rf-test pdbbind2007-refined-core-x42.rf pdbbind2007-core-yx42i.csv pdbbind2007-core-iyp.csv

	n,rmse,sdev,pcor,scor,kcor
	195,1.530,1.534,0.794,0.788,0.591

Here is a comparison of prediction performance of the original and the new RF-Score.

<table>
  <tr>
    <th></th><th>RF-Score with 36 features</th><th>RF-Score with 42 features</th>
  </tr>
  <tr>
    <td colspan="3">Evaluation on OOB (out-of-bag) data</td>
  </tr>
  <tr>
    <td>mse</td><td>2.301</td><td>2.128</td>
  </tr>
  <tr>
    <td>rsq</td><td>0.485</td><td>0.524</td>
  </tr>
  <tr>
    <td colspan="3">Evaluation on training samples (N = 1105)</td>
  </tr>
  <tr>
    <td>rmse</td><td>0.796</td><td>0.621</td>
  </tr>
  <tr>
    <td>sdev</td><td>0.797</td><td>0.622</td>
  </tr>
  <tr>
    <td>pcor</td><td>0.943</td><td>0.968</td>
  </tr>
  <tr>
    <td>scor</td><td>0.944</td><td>0.969</td>
  </tr>
  <tr>
    <td>kcor</td><td>0.800</td><td>0.853</td>
  </tr>
  <tr>
    <td colspan="3">Evaluation on testing samples (N = 195)</td>
  </tr>
  <tr>
    <td>rmse</td><td>1.589</td><td>1.530</td>
  </tr>
  <tr>
    <td>sdev</td><td>1.594</td><td>1.534</td>
  </tr>
  <tr>
    <td>pcor</td><td>0.775</td><td>0.794</td>
  </tr>
  <tr>
    <td>scor</td><td>0.760</td><td>0.788</td>
  </tr>
  <tr>
    <td>kcor</td><td>0.566</td><td>0.591</td>
  </tr>
</table>


Usage
-----

RF-Score can be easily re-trained and re-tested on newer version of PDBbind (e.g. v2012) for prospective prediction purpose.

### rf-prepare

It traverses the PDBbind folder to load proteins and ligands in pdbqt format, and extracts 36 RF-Score features and 6 Vina terms to a csv file.

It requires PDBbind and MGLTools as prerequisites.

	curl -O http://pdbbind.org.cn/download/pdbbind_v2012.tar.gz
	tar zxf pdbbind_v2012.tar.gz
	curl -O http://mgltools.scripps.edu/downloads/downloads/tars/releases/REL1.5.6/mgltools_x86_64Linux2_1.5.6.tar.gz
	tar zxf mgltools_x86_64Linux2_1.5.6.tar.gz
	cd mgltools_x86_64Linux2_1.5.6
	./install.sh -c 1

It requires pdbqt as input format in order to extract the 6 Vina terms.

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
	rf-prepare pdbbind2012-core-iy.csv pdbbind2012-core-yx42i.csv

Here shows how to prepare training samples from the PDBbind 2012 refined set minus the core set.

	core=$(tail -n +6 INDEX_core_data.2012 | cut -d' ' -f1);\
	tail -n +6 INDEX_refined_data.2012 | while read -r line; do
		if [[ 1 = $(echo ${core} | grep ${line:0:4} | wc -l) ]]; then continue; fi
		echo $line | cut -d' ' -f1,4 --output-delimiter=, >> pdbbind2012-refined-core-iy.csv
	done
	rf-prepare pdbbind2012-refined-core-iy.csv pdbbind2012-refined-core-yx42i.csv

### rf-train

It trains multiple random forests of different mtry values in parallel, selects the best one with the minimum MSE, outputs its statistics, and saves it to a binary file.

	rf-train pdbbind2012-refined-core-yx42i.csv pdbbind2012-refined-core-x42.rf

### rf-test

It loads a random forest from a binary file, predicts the RF-Score values of testing samples, saves them to a csv file, and evaluates the prediction performance.

	rf-test pdbbind2012-refined-core-x42.rf pdbbind2012-refined-core-yx42i.csv pdbbind2012-refined-core-iyp.csv
	rf-test pdbbind2012-refined-core-x42.rf pdbbind2012-core-yx42i.csv pdbbind2012-core-iyp.csv

### rf-stat

It loads two vectors of values from standard input and computes their n, rmse, sdev, pcor, scor and kcor.

	tail -n +2 pdbbind2012-core-iyp.csv | cut -d',' -f2,3 | rf-stat

### rf-score

It loads a random forest from a binary file, parses a receptor and multiple conformations of a ligand, generates their RF-Score features and Vina terms, and score them.

	rf-score pdbbind2012-refined-core-x42.rf receptor.pdbqt ligand.pdbqt


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