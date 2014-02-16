for m in 2; do
	echo model$m
	cd model$m
	for s in 1 2; do
		echo set$s
		cd set$s
		echo v,trn,tst,w,n,rmse,sdev,pcor,scor,kcor > tst-stat.csv
		for trn in 1 2 3 4 5; do
			echo trn$trn
			if [[ $trn -eq 5 ]]; then
				tsts=$(seq 5 5)
			else
				tsts=$(seq 1 2)
			fi
			for v in $(ls -1 pdbbind-*-trn-$trn-yxi.csv | cut -d- -f2); do
				echo $v
				echo w,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-trn-$trn-trn-$trn-stat.csv
				for tst in $tsts; do
					echo w,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-trn-$trn-tst-$tst-stat.csv
				done
				for w in $(seq 0.000 0.001 0.030); do
					echo $w
					mkdir -p $w
					cd $w
					../../../m2train.R $v $trn $w
					../../../m2test.R $v $trn 0 $w trn
					for tst in $tsts; do
						../../../m2test.R $v $trn $tst $w tst
						../../../corplot.R $v $trn $tst
					done
					cd ..
					echo -n $w, >> pdbbind-$v-trn-$trn-trn-$trn-stat.csv
					tail -1 $w/pdbbind-$v-trn-$trn-trn-$trn-stat.csv >> pdbbind-$v-trn-$trn-trn-$trn-stat.csv
					for tst in $tsts; do
						echo -n $w, >> pdbbind-$v-trn-$trn-tst-$tst-stat.csv
						tail -1 $w/pdbbind-$v-trn-$trn-tst-$tst-stat.csv >> pdbbind-$v-trn-$trn-tst-$tst-stat.csv
					done
				done
				for tst in $tsts; do
					b=$(tail -n +2 pdbbind-$v-trn-$trn-tst-$tst-stat.csv | sort -n -t, -k3,3 -k4,4 -k5,5r -k6,6r -k7,7r | head -1)
					echo $v,$trn,$tst,$b >> tst-stat.csv
					echo w,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-trn-$trn-tst-$tst-stat.csv
					echo $b >> pdbbind-$v-trn-$trn-tst-$tst-stat.csv
				done
			done
		done
		cd ..
	done
	cd ..
done
