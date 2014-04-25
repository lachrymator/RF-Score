RF-Score
========

RF-Score is a machine learning approach to predicting protein-ligand binding affinity.


Compilation
-----------

Eight executables, `rf-prepare`, `rf-train`, `rf-test`, `rf-stat`, `rf-extract`, `rf-predict`, `rf-score` and `rf-inspect`, will be compiled in the `bin` folder.

### Linux, Mac OS X, Solaris and FreeBSD

GCC 4.6 or higher is required.

	make

### Windows

Visual Studio 2012 or higher is required.

	msbuild RF-Score.sln /t:Build /p:Configuration=Release


Validation
----------

The original RF-Score is trained on the PDBbind 2007 refined set minus the core set (N = 1105), and tested on the PDBbind 2007 core set (N = 195). To reproduce the results presented in the original paper [DOI: 10.1093/bioinformatics/btq112], two csv files `pdbbind-2007-refined-core-yx36i.csv` and `pdbbind-2007-core-yx36i.csv` are provided and they contain the 36 RF-Score features only.

	rf-train pdbbind-2007-refined-core-yx36i.csv pdbbind-2007-refined-core-x36.rf

	Training 36 random forests of 500 trees with mtry from 1 to 36 and seed 89757 on 1105 samples using 4 threads
	mtry = 6 yields the minimum MSE
	Mean of squared residuals: 2.296
	            Var explained: 0.487
	Var %incMSE   Tgini
	  0  27.303 716.346
	  1  24.479 587.571
	  2  25.544 547.815
	  3  23.313 207.058
	  4  22.962 314.036
	  5  20.463 265.488
	  6  19.825 249.223
	  7  17.470 113.768
	  8  22.534 228.789
	  9  22.528 224.864
	 10  23.097 213.574
	 11  17.303 159.686
	 12  15.540 122.153
	 13  16.854 122.409
	 14  13.681  98.701
	 15   9.189  32.068
	 16  15.764  75.275
	 17  15.809  71.725
	 18  12.584  65.668
	 19   6.364  30.108
	 20   5.030  19.569
	 21   4.588  21.152
	 22   4.399  18.572
	 23   4.183  10.887
	 24   1.569  18.361
	 25   4.623  17.018
	 26   1.503  20.058
	 27   2.292  13.288
	 28   5.191   9.563
	 29   3.085   8.507
	 30   4.083   8.150
	 31   3.942   5.680
	 32  -1.858   3.095
	 33  -0.243   2.909
	 34  -0.683   2.624
	 35   0.046   2.256

	rf-test pdbbind-2007-refined-core-x36.rf pdbbind-2007-refined-core-yx36i.csv | tail -n +2 | cut -d, -f2,3 | rf-stat

	n,rmse,sdev,pcor,scor,kcor
	1105,0.619,0.620,0.956,0.958,0.826

	rf-test pdbbind-2007-refined-core-x36.rf pdbbind-2007-core-yx36i.csv | tail -n +2 | cut -d, -f2,3 | rf-stat

	n,rmse,sdev,pcor,scor,kcor
	195,1.506,1.514,0.773,0.759,0.564


Variants
--------

In addition to the original 36 RF-Score features, more can be used. Two csv files `pdbbind-2007-refined-core-yx42i.csv` and `pdbbind-2007-core-yx42i.csv` are provided and they contain the 36 RF-Score features, the 5 intermolecular Vina terms, and the flexibility Vina term [DOI: 10.1002/jcc.21334].

	rf-train pdbbind-2007-refined-core-yx42i.csv pdbbind-2007-refined-core-x42.rf

	Training 42 random forests of 500 trees with mtry from 1 to 42 and seed 89757 on 1105 samples using 4 threads
	mtry = 15 yields the minimum MSE
	Mean of squared residuals: 2.121
	            Var explained: 0.526
	Var %incMSE   Tgini
	  0  24.295 680.104
	  1  17.708 476.658
	  2  19.967 383.655
	  3  20.625 125.506
	  4  21.196 192.999
	  5  21.457 158.961
	  6  18.652 134.777
	  7  12.953  63.346
	  8  16.747 136.037
	  9  17.223 139.852
	 10  17.035 135.004
	 11  13.543 104.498
	 12  16.359 132.054
	 13  17.537 137.725
	 14  12.171  78.885
	 15   7.719  14.182
	 16   9.275  40.193
	 17   9.948  38.737
	 18   9.894  39.744
	 19   3.045  15.081
	 20   1.631  10.026
	 21   2.310  11.981
	 22   2.030   8.801
	 23   1.645   6.201
	 24   0.354   9.723
	 25   1.214  10.148
	 26   2.283  12.112
	 27   0.580   7.202
	 28   2.462   5.651
	 29   3.616   5.523
	 30   3.315   6.037
	 31   3.597   5.817
	 32  -0.237   1.187
	 33   0.406   1.056
	 34  -0.572   0.763
	 35   1.971   1.218
	 36  20.846 308.316
	 37  17.127 351.996
	 38  13.887 159.452
	 39  22.729 274.117
	 40  18.177 198.633
	 41  17.129 172.959

	rf-test pdbbind-2007-refined-core-x42.rf pdbbind-2007-refined-core-yx42i.csv | tail -n +2 | cut -d, -f2,3 | rf-stat

	n,rmse,sdev,pcor,scor,kcor
	1105,0.518,0.518,0.970,0.971,0.857

	rf-test pdbbind-2007-refined-core-x42.rf pdbbind-2007-core-yx42i.csv | tail -n +2 | cut -d, -f2,3 | rf-stat

	n,rmse,sdev,pcor,scor,kcor
	195,1.424,1.431,0.800,0.791,0.596

Another two csv files `pdbbind-2007-refined-core-yx47i.csv` and `pdbbind-2007-core-yx47i.csv` are provided and they contain the 36 RF-Score features, the 5 intermolecular Vina terms, the 5 intramolecular Vina terms and the flexibility Vina term.

	rf-train pdbbind-2007-refined-core-yx47i.csv pdbbind-2007-refined-core-x47.rf

	Training 47 random forests of 500 trees with mtry from 1 to 47 and seed 89757 on 1105 samples using 4 threads
	mtry = 12 yields the minimum MSE
	Mean of squared residuals: 2.106
	            Var explained: 0.529
	Var %incMSE   Tgini
	  0  22.459 600.050
	  1  17.400 400.325
	  2  17.287 341.899
	  3  15.637 103.776
	  4  20.844 168.332
	  5  17.555 135.993
	  6  17.291 130.322
	  7  13.460  57.575
	  8  16.694 114.634
	  9  16.527 122.487
	 10  15.981 115.503
	 11  12.078  95.173
	 12  16.323 118.737
	 13  17.416 125.161
	 14  12.160  79.593
	 15   7.455  14.617
	 16   9.834  40.672
	 17   9.562  35.798
	 18   7.812  32.743
	 19   2.286  14.311
	 20   2.910  11.542
	 21   2.243  10.193
	 22   3.169   8.642
	 23   1.459   5.807
	 24   2.384  10.107
	 25   2.225   9.172
	 26   2.675   9.644
	 27   2.251   6.462
	 28   2.997   6.780
	 29   2.281   5.879
	 30   2.492   5.066
	 31   3.801   3.441
	 32   1.722   0.880
	 33  -1.891   1.243
	 34  -1.200   1.072
	 35   1.120   1.174
	 36  18.326 274.812
	 37  16.230 377.279
	 38  14.376 131.867
	 39  20.477 221.890
	 40  18.660 163.409
	 41  16.514 122.612
	 42  14.727 149.597
	 43  12.839 105.897
	 44  14.866 146.066
	 45   8.189  39.389
	 46  15.070 119.821

	rf-test pdbbind-2007-refined-core-x47.rf pdbbind-2007-refined-core-yx47i.csv | tail -n +2 | cut -d, -f2,3 | rf-stat

	n,rmse,sdev,pcor,scor,kcor
	1105,0.517,0.517,0.970,0.971,0.857

	rf-test pdbbind-2007-refined-core-x47.rf pdbbind-2007-core-yx47i.csv | tail -n +2 | cut -d, -f2,3 | rf-stat

	n,rmse,sdev,pcor,scor,kcor
	195,1.425,1.432,0.800,0.795,0.601

Another two csv files `pdbbind-2007-refined-core-yx51i.csv` and `pdbbind-2007-core-yx51i.csv` are provided and they contain the 36 RF-Score features, the 11 Vina features, and the 4 Cyscore features [DOI: 10.1093/bioinformatics/btu104].

	rf-train pdbbind-2007-refined-core-yx51i.csv pdbbind-2007-refined-core-x51.rf

	Training 51 random forests of 500 trees with mtry from 1 to 51 and seed 89757 on 1105 samples using 4 threads
	mtry = 7 yields the minimum MSE
	Mean of squared residuals: 2.070
	            Var explained: 0.537
	Var %incMSE   Tgini
	  0  18.932 341.590
	  1  15.108 282.158
	  2  16.561 255.213
	  3  15.023  82.837
	  4  19.728 150.789
	  5  17.298 124.116
	  6  16.026 117.908
	  7   9.794  51.846
	  8  15.018 108.394
	  9  15.085 115.264
	 10  14.749 101.802
	 11  11.681  80.289
	 12  12.588  88.716
	 13  14.717  91.971
	 14  11.152  62.988
	 15   5.998  15.725
	 16  10.125  38.881
	 17   8.952  36.383
	 18   8.992  34.560
	 19   2.648  16.044
	 20   2.636  11.648
	 21   3.018  11.376
	 22   2.702  12.244
	 23   1.642   8.514
	 24   1.428   8.114
	 25   3.254   9.284
	 26   2.159   8.799
	 27   2.608   6.798
	 28   3.584   2.991
	 29   2.180   3.838
	 30   1.826   3.701
	 31   0.926   3.652
	 32  -1.213   1.218
	 33   1.008   1.123
	 34   0.143   0.925
	 35   0.175   0.971
	 36  16.119 201.329
	 37  13.666 243.712
	 38  12.096 106.192
	 39  18.551 208.111
	 40  13.370 116.859
	 41  13.126 106.952
	 42  12.974 151.465
	 43  12.025  87.249
	 44  13.410 128.483
	 45   4.659  38.031
	 46  12.968  97.050
	 47  22.278 401.279
	 48  16.898 410.172
	 49  14.915  90.904
	 50   8.681  82.472

	rf-test pdbbind-2007-refined-core-x51.rf pdbbind-2007-refined-core-yx51i.csv | tail -n +2 | cut -d, -f2,3 | rf-stat

	n,rmse,sdev,pcor,scor,kcor
	1105,0.524,0.525,0.969,0.969,0.854

	rf-test pdbbind-2007-refined-core-x51.rf pdbbind-2007-core-yx51i.csv | tail -n +2 | cut -d, -f2,3 | rf-stat

	n,rmse,sdev,pcor,scor,kcor
	195,1.415,1.423,0.803,0.800,0.606

Here is a comparison of prediction performance of the RF-Score variants.

<table>
  <tr>
    <th></th><th>36 features</th><th>42 features</th><th>47 features</th><th>51 features</th>
  </tr>
  <tr>
    <td colspan="5">Evaluation on OOB (out-of-bag) data</td>
  </tr>
  <tr>
    <td>mse</td><td>2.296</td><td>2.121</td><td>2.106</td><td>2.070</td>
  </tr>
  <tr>
    <td>rsq</td><td>0.487</td><td>0.526</td><td>0.529</td><td>0.537</td>
  </tr>
  <tr>
    <td colspan="5">Evaluation on training samples (N = 1105)</td>
  </tr>
  <tr>
    <td>rmse</td><td>0.708</td><td>0.608</td><td>0.608</td><td>0.619</td>
  </tr>
  <tr>
    <td>sdev</td><td>0.620</td><td>0.518</td><td>0.517</td><td>0.525</td>
  </tr>
  <tr>
    <td>pcor</td><td>0.956</td><td>0.970</td><td>0.970</td><td>0.969</td>
  </tr>
  <tr>
    <td>scor</td><td>0.958</td><td>0.971</td><td>0.971</td><td>0.969</td>
  </tr>
  <tr>
    <td>kcor</td><td>0.826</td><td>0.857</td><td>0.857</td><td>0.854</td>
  </tr>
  <tr>
    <td colspan="5">Evaluation on testing samples (N = 195)</td>
  </tr>
  <tr>
    <td>rmse</td><td>1.578</td><td>1.512</td><td>1.520</td><td>1.513</td>
  </tr>
  <tr>
    <td>sdev</td><td>1.514</td><td>1.431</td><td>1.432</td><td>1.423</td>
  </tr>
  <tr>
    <td>pcor</td><td>0.773</td><td>0.800</td><td>0.800</td><td>0.803</td>
  </tr>
  <tr>
    <td>scor</td><td>0.759</td><td>0.791</td><td>0.795</td><td>0.800</td>
  </tr>
  <tr>
    <td>kcor</td><td>0.564</td><td>0.596</td><td>0.601</td><td>0.606</td>
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
	rf-prepare pdbbind-2012-core-iy.csv > pdbbind-2012-core-yx42i.csv

Here shows how to prepare training samples from the PDBbind 2012 refined set minus the core set.

	core=$(tail -n +6 INDEX_core_data.2012 | cut -d' ' -f1);\
	tail -n +6 INDEX_refined_data.2012 | while read -r line; do
		if [[ 1 = $(echo ${core} | grep ${line:0:4} | wc -l) ]]; then continue; fi
		echo $line | cut -d' ' -f1,4 --output-delimiter=, >> pdbbind-2012-refined-core-iy.csv
	done
	rf-prepare pdbbind-2012-refined-core-iy.csv > pdbbind-2012-refined-core-yx42i.csv

### rf-train

It trains multiple random forests of different mtry values in parallel, selects the best one with the minimum MSE, outputs its statistics, and saves it to a binary file.

	rf-train pdbbind-2012-refined-core-yx42i.csv pdbbind-2012-refined-core-x42.rf

### rf-test

It loads a random forest from a binary file, predicts the RF-Score values of testing samples.

	rf-test pdbbind-2012-refined-core-x42.rf pdbbind-2012-refined-core-yx42i.csv > pdbbind-2012-refined-core-iyp.csv
	rf-test pdbbind-2012-refined-core-x42.rf pdbbind-2012-core-yx42i.csv > pdbbind-2012-core-iyp.csv

### rf-stat

It loads two vectors of values from standard input and computes their n, rmse, sdev, pcor, scor and kcor.

	tail -n +2 pdbbind-2012-refined-core-iyp.csv | cut -d, -f2,3 | rf-stat
	tail -n +2 pdbbind-2012-core-iyp.csv | cut -d, -f2,3 | rf-stat

### rf-extract

It parses a receptor and multiple conformations of a ligand, and extracts their RF-Score features and Vina terms.

	rf-extract receptor.pdbqt ligand.pdbqt > x.csv

### rf-predict

It loads a random forest from a binary file, reads features from standard input, and score them.

	tail -n +2 x.csv | rf-predict pdbbind-2012-refined-core-x42.rf

### rf-score

It loads a random forest from a binary file, parses a receptor and multiple conformations of a ligand, extracts their RF-Score features and Vina terms, and score them.

	rf-score pdbbind-2012-refined-core-x42.rf receptor.pdbqt ligand.pdbqt

rf-score is a streamlined combination of rf-extract and rf-predict. The above command is equivalent to

	rf-extract receptor.pdbqt ligand.pdbqt | tail -n +2 | rf-predict pdbbind-2012-refined-core-x42.rf

### rf-inspect

It inspects the node values of a built random forest.

	rf-inspect pdbbind-2012-refined-core-x42.rf | sort -t, -k1,1n


Author
------

[Hongjian Li]


License
-------

[Apache License 2.0]


References
----------

Pedro J. Ballester and John B. O. Mitchell. A machine learning approach to predicting protein-ligand binding affinity with applications to molecular docking. Bioinformatics, 26(9):1169-1175, 2010. [DOI: 10.1093/bioinformatics/btq112]

Oleg Trott and Arthur J. Olson. AutoDock Vina: Improving the speed and accuracy of docking with a new scoring function, efficient optimization, and multithreading. Journal of Computational Chemistry, 31:455-461, 2010. [DOI: 10.1002/jcc.21334]

Yang Cao and Lei Li. Improved protein-ligand binding affinity prediction by using a curvature dependent surface area model. Bioinformatics, 2014. [DOI: 10.1093/bioinformatics/btu104]

[Hongjian Li]: http://www.cse.cuhk.edu.hk/~hjli
[Apache License 2.0]: http://www.apache.org/licenses/LICENSE-2.0
[DOI: 10.1093/bioinformatics/btq112]: http://dx.doi.org/10.1093/bioinformatics/btq112
[DOI: 10.1002/jcc.21334]: http://dx.doi.org/10.1002/jcc.21334
[DOI: 10.1093/bioinformatics/btu104]: http://dx.doi.org/10.1093/bioinformatics/btu104
