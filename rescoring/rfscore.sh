#rm -f obj/rf-prepare.o
#make
rf-prepare ~/PDBbind/v2007/pdbbind2007-core-iy.csv pdbbind2007-core-yxi.csv
rf-prepare ~/PDBbind/v2007/pdbbind2007-refined-core-iy.csv pdbbind2007-refined-core-yxi.csv
echo seed,rmse,sdev,pcor,scor,kcor > pdbbind2007-core-statistics.csv
cp pdbbind2007-core-statistics.csv pdbbind2007-refined-core-statistics.csv
for s in $(cat ../seed.csv); do
	echo $s
	mkdir -p $s
	cd $s
	rf-train ../pdbbind2007-refined-core-yxi.csv pdbbind2007-refined-core.rf $s > rf-train-refined-core.txt
	rf-test pdbbind2007-refined-core.rf ../pdbbind2007-refined-core-yxi.csv pdbbind2007-refined-core-iyp.csv > rf-test-refined-core.txt
	rf-test pdbbind2007-refined-core.rf ../pdbbind2007-core-yxi.csv pdbbind2007-core-iyp.csv > rf-test-core.txt
	cd ..
	echo -n $s, >> pdbbind2007-core-statistics.csv
	echo -n $s, >> pdbbind2007-refined-core-statistics.csv
	tail -n +2 $s/rf-test-core.txt | cut -d' ' -f2 | tr '\n' ',' | sed 's/,$/\n/g' >> pdbbind2007-core-statistics.csv
	tail -n +2 $s/rf-test-refined-core.txt | cut -d' ' -f2 | tr '\n' ',' | sed 's/,$/\n/g' >> pdbbind2007-refined-core-statistics.csv
done
