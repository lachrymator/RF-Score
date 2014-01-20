for s in 1 2; do
	echo set$s
	cd set$s
	echo v,w,n,rmse,sdev,pcor,scor,kcor > tst-stat.csv
	for v in $(ls -1 pdbbind-*-trn-yxi.csv | ~/idock/utilities/substr 8 4); do
		echo $v
		echo w,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-tst-stat.csv
		echo w,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-trn-stat.csv
		for s in $(seq 0.005 0.001 0.020); do
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
#			rm -rf $s
		done
		b=$(tail -n +2 pdbbind-$v-tst-stat.csv | sort -n -t, -k3 -k4 -k5r -k6r -k7r | head -1)
		echo $v,$b >> tst-stat.csv
		echo w,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-tst-stat.csv
		echo $b >> pdbbind-$v-tst-stat.csv
	done
	cd ..
done
