for v in 2004 2007 2010 2013; do
	echo $v
	echo seed,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-core-statistics.csv
	echo seed,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-refined-core-statistics.csv
	for s in $(cat ../seed.csv); do
		echo $s
		mkdir -p $s
		cd $s
		rf-train ../pdbbind-$v-refined-core-yxi.csv pdbbind-$v-refined-core.rf $s > pdbbind-$v-refined-core.txt
		rf-test pdbbind-$v-refined-core.rf ../pdbbind-$v-refined-core-yxi.csv pdbbind-$v-refined-core-iyp.csv > pdbbind-$v-refined-core-statistics.csv
		rf-test pdbbind-$v-refined-core.rf ../pdbbind-2007-core-yxi.csv pdbbind-$v-core-iyp.csv > pdbbind-$v-core-statistics.csv
		rm pdbbind-$v-refined-core.rf
		../../plot.R $v
		tail -n +6 pdbbind-$v-refined-core.txt | ~/idock/utilities/substr 3 8 | ../../varImpPlot.R $v
		cd ..
		echo -n $s, >> pdbbind-$v-core-statistics.csv
		echo -n $s, >> pdbbind-$v-refined-core-statistics.csv
		tail -1 $s/pdbbind-$v-core-statistics.csv >> pdbbind-$v-core-statistics.csv
		tail -1 $s/pdbbind-$v-refined-core-statistics.csv >> pdbbind-$v-refined-core-statistics.csv
	done
done
