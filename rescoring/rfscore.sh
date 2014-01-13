echo seed,n,rmse,sdev,pcor,scor,kcor > pdbbind-2007-core-statistics.csv
echo seed,n,rmse,sdev,pcor,scor,kcor > pdbbind-2007-refined-core-statistics.csv
for s in $(cat ../seed.csv); do
	echo $s
	mkdir -p $s
	cd $s
	rf-train ../pdbbind-2007-refined-core-yxi.csv pdbbind-2007-refined-core.rf $s > pdbbind-2007-refined-core.txt
	rf-test pdbbind-2007-refined-core.rf ../pdbbind-2007-refined-core-yxi.csv pdbbind-2007-refined-core-iyp.csv > pdbbind-2007-refined-core-statistics.csv
	rf-test pdbbind-2007-refined-core.rf ../pdbbind-2007-core-yxi.csv pdbbind-2007-core-iyp.csv > pdbbind-2007-core-statistics.csv
	rm pdbbind-2007-refined-core.rf
	../../plot.R
	tail -n +6 pdbbind-2007-refined-core.txt | ~/idock/utilities/substr 3 8 | ../../varImpPlot.R
	cd ..
	echo -n $s, >> pdbbind-2007-core-statistics.csv
	echo -n $s, >> pdbbind-2007-refined-core-statistics.csv
	tail -1 $s/pdbbind-2007-core-statistics.csv >> pdbbind-2007-core-statistics.csv
	tail -1 $s/pdbbind-2007-refined-core-statistics.csv >> pdbbind-2007-refined-core-statistics.csv
done
