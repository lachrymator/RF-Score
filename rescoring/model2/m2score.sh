echo weight,n,rmse,sdev,pcor,scor,kcor > pdbbind-2007-core-statistics.csv
echo weight,n,rmse,sdev,pcor,scor,kcor > pdbbind-2007-refined-core-statistics.csv
for s in $(cat weight.csv); do
	echo $s
	mkdir -p $s
	cd $s
	../m2score.R $s
	cd ..
	echo -n $s, >> pdbbind-2007-core-statistics.csv
	echo -n $s, >> pdbbind-2007-refined-core-statistics.csv
	tail -1 $s/pdbbind-2007-core-statistics.csv >> pdbbind-2007-core-statistics.csv
	tail -1 $s/pdbbind-2007-refined-core-statistics.csv >> pdbbind-2007-refined-core-statistics.csv
	rm -rf $s
done
