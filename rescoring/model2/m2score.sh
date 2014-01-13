for v in 2004 2007 2010 2013; do
	echo $v
	echo weight,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-core-statistics.csv
	echo weight,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-refined-core-statistics.csv
	for s in $(cat weight.csv); do
		echo $s
		mkdir -p $s
		cd $s
		../m2score.R $v $s
		../../plot.R $v
		cd ..
		echo -n $s, >> pdbbind-$v-core-statistics.csv
		echo -n $s, >> pdbbind-$v-refined-core-statistics.csv
		tail -1 $s/pdbbind-$v-core-statistics.csv >> pdbbind-$v-core-statistics.csv
		tail -1 $s/pdbbind-$v-refined-core-statistics.csv >> pdbbind-$v-refined-core-statistics.csv
#		rm -rf $s
	done
done
