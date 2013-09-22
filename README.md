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

	msbuild /t:Build /p:Configuration=Release


Validation
----------

Two csv files, `rf-train.csv` and `rf-test.csv`, are provided in order to reproduce the results as presented in the original paper [DOI: 10.1093/bioinformatics/btq112]. They are extracted from PDBbind 2007, and contain the 36 RF-Score features only, without the 5 Vina terms.

	rf-train rf-train.csv rf.data
	rf-test rf.data rf-train.csv rf-pred.csv
	rf-test rf.data rf-test.csv rf-pred.csv


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

	tail -n +6 ../v2012/INDEX_refined_data.2012 | while IFS= read -r line; do
		code=${line:0:4}
		bin/pythonsh MGLToolsPckgs/AutoDockTools/Utilities24/prepare_receptor4.py -U waters -r ../v2012/${code}/${code}_protein.pdb
		bin/pythonsh MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py -U '' -l ../v2012/${code}/${code}_ligand.mol2
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