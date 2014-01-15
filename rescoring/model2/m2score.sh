for v in $(ls -1 pdbbind-*-trn-yxi.csv | ~/idock/utilities/substr 8 4); do
	echo $v
	echo weight,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-tst-stat.csv
	echo weight,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-trn-stat.csv
	for s in $(cat ../weight.csv); do
		echo $s
		mkdir -p $s
		cd $s
		../../m2score.R $v $s
		../../../plot.R $v
		cd ..
		echo -n $s, >> pdbbind-$v-tst-stat.csv
		echo -n $s, >> pdbbind-$v-trn-stat.csv
		tail -1 $s/pdbbind-$v-tst-stat.csv >> pdbbind-$v-tst-stat.csv
		tail -1 $s/pdbbind-$v-trn-stat.csv >> pdbbind-$v-trn-stat.csv
#		rm -rf $s
	done
done
