for m in 2; do
	echo model$m
	cd model$m
	for s in 1 2; do
		echo set$s
		cd set$s
		for trn in 1 2 3 4 5 6; do
			echo trn$trn
			if [[ $trn -ge 5 ]]; then
				tsts=$(seq $trn $trn)
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
					../../../mlrtrain.R $v $trn $w
					../../../mlrtest.R $v $trn 0 $w trn
					for tst in $tsts; do
						../../../mlrtest.R $v $trn $tst $w tst
						../../../iyprplot.R $v $trn $tst
						rm pdbbind-$v-trn-$trn-tst-$tst-iyp.csv
					done
					if [[ $trn -lt 5 ]]; then
						cut -d, -f3,4 pdbbind-$v-trn-$trn-tst-2-iypr.csv | paste -d, ../../../set$s/tst-2-id.csv - > pdbbind-$v-trn-$trn-tst-2-idpr.csv
						../../../idprplot.R $v $trn 2
					fi
					cd ..
					echo -n $w, >> pdbbind-$v-trn-$trn-trn-$trn-stat.csv
					tail -1 $w/pdbbind-$v-trn-$trn-trn-$trn-stat.csv >> pdbbind-$v-trn-$trn-trn-$trn-stat.csv
					for tst in $tsts; do
						echo -n $w, >> pdbbind-$v-trn-$trn-tst-$tst-stat.csv
						tail -1 $w/pdbbind-$v-trn-$trn-tst-$tst-stat.csv >> pdbbind-$v-trn-$trn-tst-$tst-stat.csv
					done
				done
				for tst in $tsts; do
					b=$(tail -n +2 pdbbind-$v-trn-$trn-tst-$tst-stat.csv | sort -t, -k3,3n -k4,4n -k5,5nr -k6,6nr -k7,7nr | head -1)
					echo $v,$trn,$tst,$b >> tst-stat-0.csv
					echo w,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-trn-$trn-tst-$tst-stat.csv
					echo $b >> pdbbind-$v-trn-$trn-tst-$tst-stat.csv
				done
			done
		done
		echo v,trn,tst,w,n,rmse,sdev,pcor,scor,kcor > tst-stat.csv
		sort -t, -k1,1n tst-stat-0.csv >> tst-stat.csv
		rm tst-stat-0.csv
		cd ..
	done
	cd ..
done
