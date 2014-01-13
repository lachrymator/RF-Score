rf-prepare ~/PDBbind/v2007/pdbbind2007-core-iy.csv pdbbind2007-core-yxi.csv
rf-prepare ~/PDBbind/v2007/pdbbind2007-refined-core-iy.csv pdbbind2007-refined-core-yxi.csv
echo seed,n,rmse,sdev,pcor,scor,kcor > pdbbind2007-core-statistics.csv
echo seed,n,rmse,sdev,pcor,scor,kcor > pdbbind2007-refined-core-statistics.csv
for s in $(cat ../seed.csv); do
	echo $s
	mkdir -p $s
	cd $s
	rf-train ../pdbbind2007-refined-core-yxi.csv pdbbind2007-refined-core.rf $s > pdbbind2007-refined-core.txt
	rf-test pdbbind2007-refined-core.rf ../pdbbind2007-refined-core-yxi.csv pdbbind2007-refined-core-iyp.csv > pdbbind2007-refined-core-statistics.csv
	rf-test pdbbind2007-refined-core.rf ../pdbbind2007-core-yxi.csv pdbbind2007-core-iyp.csv > pdbbind2007-core-statistics.csv
	rm pdbbind2007-refined-core.rf
	cd ..
	echo -n $s, >> pdbbind2007-core-statistics.csv
	echo -n $s, >> pdbbind2007-refined-core-statistics.csv
	tail -1 $s/pdbbind2007-core-statistics.csv >> pdbbind2007-core-statistics.csv
	tail -1 $s/pdbbind2007-refined-core-statistics.csv >> pdbbind2007-refined-core-statistics.csv
done
