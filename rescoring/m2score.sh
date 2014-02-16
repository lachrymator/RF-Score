for m in 2; do
	echo model$m
	cd model$m
	for s in 1 2; do
		echo set$s
		cd set$s
		echo v,w,n,rmse,sdev,pcor,scor,kcor > tst-stat.csv
		for v in $(ls -1 pdbbind-*-trn-yxi.csv | cut -d- -f2); do
			echo $v
			echo w,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-tst-stat.csv
			echo w,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-trn-stat.csv
			for w in $(seq 0.005 0.001 0.020); do
				echo $w
				mkdir -p $w
				cd $w
				../../../m2train.R $v $w
				../../../m2test.R $v $w trn
				../../../m2test.R $v $w tst
				../../../corplot.R $v
				cd ..
				echo -n $w, >> pdbbind-$v-tst-stat.csv
				echo -n $w, >> pdbbind-$v-trn-stat.csv
				tail -1 $w/pdbbind-$v-tst-stat.csv >> pdbbind-$v-tst-stat.csv
				tail -1 $w/pdbbind-$v-trn-stat.csv >> pdbbind-$v-trn-stat.csv
			done
			b=$(tail -n +2 pdbbind-$v-tst-stat.csv | sort -n -t, -k3,3 -k4,4 -k5,5r -k6,6r -k7,7r | head -1)
			echo $v,$b >> tst-stat.csv
			echo w,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-tst-stat.csv
			echo $b >> pdbbind-$v-tst-stat.csv
		done
		cd ..
	done
	cd ..
done
