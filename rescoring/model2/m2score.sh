echo weight,n,rmse,sdev,pcor,scor,kcor > pdbbind2007-core-statistics.csv
echo weight,n,rmse,sdev,pcor,scor,kcor > pdbbind2007-refined-core-statistics.csv
for s in $(cat weight.csv); do
	echo $s
	mkdir -p $s
	cd $s
	../m2score.R $s
	cd ..
	echo -n $s, >> pdbbind2007-core-statistics.csv
	echo -n $s, >> pdbbind2007-refined-core-statistics.csv
	tail -1 $s/pdbbind2007-core-statistics.csv >> pdbbind2007-core-statistics.csv
	tail -1 $s/pdbbind2007-refined-core-statistics.csv >> pdbbind2007-refined-core-statistics.csv
done
