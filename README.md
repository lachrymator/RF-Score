RF-Score
========

RF-Score is a machine learning approach to predicting protein-ligand binding affinity.

The original RF-Score uses as features the number of occurrences of 36 particular protein-ligand atom type pairs interacting within a certain distance range.

The new RF-Score uses as features both the number of occurrences of 36 particular protein-ligand atom type pairs interacting within a certain distance range and the 6 Vina terms.


Compilation
-----------

Seven executables, `rf-prepare`, `rf-train`, `rf-test`, `rf-stat`, `rf-extract`, `rf-predict` and `rf-score`, will be compiled in the `bin` folder.

### Linux, Mac OS X, Solaris and FreeBSD

GCC 4.6 or higher is required.

	make

### Windows

Visual Studio 2012 or higher is required.

	msbuild RF-Score.sln /t:Build /p:Configuration=Release


Validation
----------

The original RF-Score is trained on the PDBbind 2007 refined set minus the core set (N = 1105), and tested on the PDBbind 2007 core set (N = 195). To reproduce the results presented in the original paper [DOI: 10.1093/bioinformatics/btq112], two csv files `pdbbind-2007-refined-core-yx36i.csv` and `pdbbind-2007-core-yx36i.csv` are provided and they contain the 36 RF-Score features only, without the 6 Vina terms.

	rf-train pdbbind-2007-refined-core-yx36i.csv pdbbind-2007-refined-core-x36.rf

	Training 13 random forests of 500 trees with mtry from 1 to 13 and seed 89757 on 1105 samples using 4 threads
	mtry = 5 yields the minimum MSE
	Mean of squared residuals: 2.298
		        Var explained: 0.486
	Var %incMSE   Tgini
	  0  25.707 646.700
	  1  24.066 577.479
	  2  25.916 561.010
	  3  23.443 211.246
	  4  21.741 296.573
	  5  23.080 271.297
	  6  19.788 243.718
	  7  15.659 114.332
	  8  22.466 229.825
	  9  21.606 219.621
	 10  23.650 209.345
	 11  17.457 158.976
	 12  14.425 120.943
	 13  17.040 121.586
	 14  12.362  98.677
	 15   9.773  33.328
	 16  14.706  77.483
	 17  14.983  70.677
	 18  12.683  65.962
	 19   7.589  32.437
	 20   6.193  20.916
	 21   7.172  23.771
	 22   4.946  19.955
	 23   4.033  11.297
	 24   4.587  20.789
	 25   3.506  19.360
	 26   4.205  18.031
	 27   2.378  13.677
	 28   5.304   9.090
	 29   5.038   8.711
	 30   5.119   8.538
	 31   5.658   6.269
	 32  -0.372   2.294
	 33   0.027   3.112
	 34   0.264   2.951
	 35   0.368   3.377

	rf-test pdbbind-2007-refined-core-x36.rf pdbbind-2007-refined-core-yx36i.csv pdbbind-2007-refined-core-iyp.csv

	n,rmse,sdev,pcor,scor,kcor
	1105,0.737,0.737,0.952,0.954,0.818

	rf-test pdbbind-2007-refined-core-x36.rf pdbbind-2007-core-yx36i.csv pdbbind-2007-core-iyp.csv

	n,rmse,sdev,pcor,scor,kcor
	195,1.575,1.579,0.778,0.761,0.566


Results
-------

The new RF-Score is trained and tested on the same data sets to make a fair comparison. Two csv files `pdbbind-2007-refined-core-yx42i.csv` and `pdbbind-2007-core-yx42i.csv` are provided and they contain both the 36 RF-Score features and the 6 Vina terms.

	rf-train pdbbind-2007-refined-core-yx42i.csv pdbbind-2007-refined-core-x42.rf

	Training 15 random forests of 500 trees with mtry from 1 to 15 and seed 89757 on 1105 samples using 4 threads
	mtry = 6 yields the minimum MSE
	Mean of squared residuals: 2.108
		        Var explained: 0.528
	Var %incMSE   Tgini
	  0  21.704 492.149
	  1  19.645 411.784
	  2  20.482 353.154
	  3  18.558 130.786
	  4  19.578 193.531
	  5  19.704 184.988
	  6  19.941 178.821
	  7  15.783  79.110
	  8  18.615 148.071
	  9  20.523 150.438
	 10  16.851 142.395
	 11  13.953 112.838
	 12  16.656 111.174
	 13  16.250 117.993
	 14  12.810  80.519
	 15   7.958  24.559
	 16  11.654  51.949
	 17  11.575  51.918
	 18   9.836  43.784
	 19   4.265  22.236
	 20   4.188  13.720
	 21   4.091  16.479
	 22   2.130  13.386
	 23   3.849   8.949
	 24   3.274  12.753
	 25   4.353  12.514
	 26   2.473  13.831
	 27  -0.963   9.464
	 28   2.194   7.133
	 29   2.579   7.290
	 30   2.552   5.870
	 31   1.817   5.119
	 32   1.677   1.487
	 33  -1.841   2.149
	 34  -0.979   1.595
	 35   1.149   1.801
	 36  17.850 319.967
	 37  16.272 370.106
	 38  15.952 153.848
	 39  24.639 314.574
	 40  17.829 172.813
	 41  17.801 167.038

	rf-test pdbbind-2007-refined-core-x42.rf pdbbind-2007-refined-core-yx42i.csv pdbbind-2007-refined-core-iyp.csv

	n,rmse,sdev,pcor,scor,kcor
	1105,0.645,0.645,0.965,0.967,0.847

	rf-test pdbbind-2007-refined-core-x42.rf pdbbind-2007-core-yx42i.csv pdbbind-2007-core-iyp.csv

	n,rmse,sdev,pcor,scor,kcor
	195,1.524,1.528,0.800,0.793,0.599

Here is a comparison of prediction performance of the original and the new RF-Score.

<table>
  <tr>
    <th></th><th>RF-Score with 36 features</th><th>RF-Score with 42 features</th>
  </tr>
  <tr>
    <td colspan="3">Evaluation on OOB (out-of-bag) data</td>
  </tr>
  <tr>
    <td>mse</td><td>2.298</td><td>2.108</td>
  </tr>
  <tr>
    <td>rsq</td><td>0.486</td><td>0.528</td>
  </tr>
  <tr>
    <td colspan="3">Evaluation on training samples (N = 1105)</td>
  </tr>
  <tr>
    <td>rmse</td><td>0.737</td><td>0.645</td>
  </tr>
  <tr>
    <td>sdev</td><td>0.737</td><td>0.645</td>
  </tr>
  <tr>
    <td>pcor</td><td>0.952</td><td>0.965</td>
  </tr>
  <tr>
    <td>scor</td><td>0.954</td><td>0.967</td>
  </tr>
  <tr>
    <td>kcor</td><td>0.818</td><td>0.847</td>
  </tr>
  <tr>
    <td colspan="3">Evaluation on testing samples (N = 195)</td>
  </tr>
  <tr>
    <td>rmse</td><td>1.575</td><td>1.524</td>
  </tr>
  <tr>
    <td>sdev</td><td>1.579</td><td>1.528</td>
  </tr>
  <tr>
    <td>pcor</td><td>0.778</td><td>0.800</td>
  </tr>
  <tr>
    <td>scor</td><td>0.761</td><td>0.793</td>
  </tr>
  <tr>
    <td>kcor</td><td>0.566</td><td>0.599</td>
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
		echo $line | cut -d' ' -f1,4 --output-delimiter=, >> pdbbind-2012-core-iy.csv
	done
	rf-prepare pdbbind-2012-core-iy.csv pdbbind-2012-core-yx42i.csv

Here shows how to prepare training samples from the PDBbind 2012 refined set minus the core set.

	core=$(tail -n +6 INDEX_core_data.2012 | cut -d' ' -f1);\
	tail -n +6 INDEX_refined_data.2012 | while read -r line; do
		if [[ 1 = $(echo ${core} | grep ${line:0:4} | wc -l) ]]; then continue; fi
		echo $line | cut -d' ' -f1,4 --output-delimiter=, >> pdbbind-2012-refined-core-iy.csv
	done
	rf-prepare pdbbind-2012-refined-core-iy.csv pdbbind-2012-refined-core-yx42i.csv

### rf-train

It trains multiple random forests of different mtry values in parallel, selects the best one with the minimum MSE, outputs its statistics, and saves it to a binary file.

	rf-train pdbbind-2012-refined-core-yx42i.csv pdbbind-2012-refined-core-x42.rf

### rf-test

It loads a random forest from a binary file, predicts the RF-Score values of testing samples, saves them to a csv file, and evaluates the prediction performance.

	rf-test pdbbind-2012-refined-core-x42.rf pdbbind-2012-refined-core-yx42i.csv pdbbind-2012-refined-core-iyp.csv
	rf-test pdbbind-2012-refined-core-x42.rf pdbbind-2012-core-yx42i.csv pdbbind-2012-core-iyp.csv

### rf-stat

It loads two vectors of values from standard input and computes their n, rmse, sdev, pcor, scor and kcor.

	tail -n +2 pdbbind-2012-core-iyp.csv | cut -d',' -f2,3 | rf-stat

### rf-extract

It parses a receptor and multiple conformations of a ligand, and extracts their RF-Score features and Vina terms.

	rf-extract receptor.pdbqt ligand.pdbqt

### rf-predict

It loads a random forest from a binary file, reads features from standard input, and score them.

	rf-predict pdbbind-2012-refined-core-x42.rf < x.csv

### rf-score

It loads a random forest from a binary file, parses a receptor and multiple conformations of a ligand, extracts their RF-Score features and Vina terms, and score them.

	rf-score pdbbind-2012-refined-core-x42.rf receptor.pdbqt ligand.pdbqt

rf-score is a streamlined combination of rf-extract and rf-predict. The above command is equivalent to

	rf-extract receptor.pdbqt ligand.pdbqt | tail -n +2 | rf-predict pdbbind-2012-refined-core-x42.rf


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