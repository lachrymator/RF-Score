RF-Score
========

RF-Score is a machine learning approach to predicting protein-ligand binding affinity.

The original RF-Score uses as features the number of occurrences of 36 particular protein-ligand atom type pairs interacting within a certain distance range.

The new RF-Score uses as features both the number of occurrences of 36 particular protein-ligand atom type pairs interacting within a certain distance range and the 5 Vina terms.


Compilation
-----------

Four executables, `rf-prepare`, `rf-train`, `rf-test` and `rf-score`, will be compiled in the `bin` folder.

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
	mtry = 6 yields the minimum MSE
	Mean of squared residuals: 2.288
		        Var explained: 0.489
	Var %incMSE   Tgini
	  0  27.145 694.927
	  1  26.064 631.766
	  2  25.287 534.830
	  3  22.775 218.108
	  4  22.531 319.658
	  5  22.694 243.093
	  6  20.228 250.335
	  7  16.408 111.282
	  8  26.192 224.810
	  9  23.324 226.473
	 10  21.817 214.546
	 11  18.760 160.839
	 12  16.031 122.119
	 13  17.509 132.622
	 14  14.212  98.977
	 15   8.868  31.616
	 16  14.311  78.965
	 17  14.456  74.805
	 18  10.695  61.024
	 19   6.791  29.388
	 20   5.351  18.906
	 21   5.996  22.805
	 22   4.501  16.311
	 23   4.827  11.587
	 24   3.588  17.133
	 25   4.251  17.087
	 26   4.088  19.714
	 27   4.045  13.816
	 28   4.234   9.368
	 29   3.134   8.808
	 30   4.447   9.262
	 31   4.361   7.159
	 32  -1.103   2.718
	 33   0.053   2.006
	 34  -1.519   2.465
	 35   2.013   2.356

	rf-test pdbbind2007-refined-core-x36.rf pdbbind2007-refined-core-yx36i.csv pred-ipy.csv

	N 1105
	rmse 0.701
	sdev 0.491
	pcor 0.957
	scor 0.958
	kcor 0.828

	rf-test pdbbind2007-refined-core-x36.rf pdbbind2007-core-yx36i.csv pred-ipy.csv

	N 195
	rmse 1.585
	sdev 2.522
	pcor 0.771
	scor 0.755
	kcor 0.562


Results
-------

The new RF-Score is trained and tested on the same data sets to make a fair comparison. Two csv files, `pdbbind2007-refined-core-yx41i.csv` and `pdbbind2007-core-yx41i.csv`, are provided and they contain both the 36 RF-Score features and the 5 Vina terms.

	rf-train pdbbind2007-refined-core-yx41i.csv pdbbind2007-refined-core-x41.rf

	Training 11 random forests of 500 trees with mtry from 1 to 11 and seed 89757 using 4 threads
	mtry = 6 yields the minimum MSE
	Mean of squared residuals: 2.165
		        Var explained: 0.516
	Var %incMSE   Tgini
	  0  23.094 522.200
	  1  18.493 389.844
	  2  20.699 355.149
	  3  19.118 146.437
	  4  20.324 225.023
	  5  19.036 181.106
	  6  20.942 183.265
	  7  16.495  83.164
	  8  18.468 157.290
	  9  20.248 154.510
	 10  18.812 151.513
	 11  14.699 116.381
	 12  13.942 115.347
	 13  13.736 108.732
	 14  13.419  90.339
	 15   8.078  25.094
	 16  11.583  55.075
	 17  10.755  55.469
	 18  11.589  54.571
	 19   6.473  22.722
	 20   2.747  16.329
	 21   5.937  17.453
	 22   3.212  15.115
	 23   3.097  10.341
	 24   2.283  13.952
	 25   4.499  14.221
	 26   2.758  15.725
	 27   3.554   9.449
	 28   3.296   6.674
	 29   3.050   6.655
	 30   1.817   7.444
	 31   3.886   5.304
	 32  -0.060   1.657
	 33  -1.413   1.630
	 34  -0.127   1.478
	 35  -1.639   2.357
	 36  19.473 323.774
	 37  17.644 406.938
	 38  18.471 164.638
	 39  23.297 310.548
	 40  15.854 175.989

	rf-test pdbbind2007-refined-core-x41.rf pdbbind2007-refined-core-yx41i.csv pred-ipy.csv

	N 1105
	rmse 0.652
	sdev 0.426
	pcor 0.965
	scor 0.965
	kcor 0.843

	rf-test pdbbind2007-refined-core-x41.rf pdbbind2007-core-yx41i.csv pred-ipy.csv

	N 195
	rmse 1.534
	sdev 2.361
	pcor 0.796
	scor 0.791
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
    <td>mse</td><td>2.288</td><td>2.165</td>
  </tr>
  <tr>
    <td>rsq</td><td>0.489</td><td>0.516</td>
  </tr>
  <tr>
    <td colspan="3">Evaluation on training samples (N = 1105)</td>
  </tr>
  <tr>
    <td>rmse</td><td>0.701</td><td>0.652</td>
  </tr>
  <tr>
    <td>sdev</td><td>0.491</td><td>0.426</td>
  </tr>
  <tr>
    <td>pcor</td><td>0.957</td><td>0.965</td>
  </tr>
  <tr>
    <td>scor</td><td>0.958</td><td>0.965</td>
  </tr>
  <tr>
    <td>kcor</td><td>0.828</td><td>0.843</td>
  </tr>
  <tr>
    <td colspan="3">Evaluation on testing samples (N = 195)</td>
  </tr>
  <tr>
    <td>rmse</td><td>1.585</td><td>1.534</td>
  </tr>
  <tr>
    <td>sdev</td><td>2.522</td><td>2.361</td>
  </tr>
  <tr>
    <td>pcor</td><td>0.771</td><td>0.796</td>
  </tr>
  <tr>
    <td>scor</td><td>0.755</td><td>0.791</td>
  </tr>
  <tr>
    <td>kcor</td><td>0.562</td><td>0.597</td>
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