for m in 3 4; do
	echo model$m
	cd model$m
	for s in 3; do
		echo set$s
		cd set$s
		for trn in {0..10}; do
			echo trn$trn
			if [[ $trn == 0 ]]; then
				tsts=$(seq 0 5)
			elif [[ $trn -le 5 ]]; then
				tsts=$trn
			else
				tsts=$((trn-5))
			fi
			for v in $(ls -1 pdbbind-*-trn-$trn-yxi.csv | cut -d- -f2); do
				echo $v
				for tst in $tsts; do
					echo seed,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-trn-$trn-tst-$tst-stat.csv
				done
				for w in 89757 35577 51105 72551 10642 69834 47945 52857 26894 99789; do
					echo $w
					mkdir -p $w
					cd $w
					rf-train ../pdbbind-$v-trn-$trn-yxi.csv pdbbind-$v-trn-$trn.rf $w > pdbbind-$v-trn-$trn.txt
					for tst in $tsts; do
						rf-test pdbbind-$v-trn-$trn.rf ../tst-$tst-yxi.csv | tail -n +2 | cut -d, -f2,3 | rf-stat > pdbbind-$v-trn-$trn-tst-$tst-stat.csv
					done
					cd ..
					for tst in $tsts; do
						echo -n $w, >> pdbbind-$v-trn-$trn-tst-$tst-stat.csv
						tail -1 $w/pdbbind-$v-trn-$trn-tst-$tst-stat.csv >> pdbbind-$v-trn-$trn-tst-$tst-stat.csv
					done
				done
				for tst in $tsts; do
					b=$(tail -n +2 pdbbind-$v-trn-$trn-tst-$tst-stat.csv | sort -t, -k3,3n -k4,4n -k5,5nr -k6,6nr -k7,7nr | head -1)
					echo $v,$trn,$tst,$b >> tst-stat-0.csv
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
