for m in 3 4 5; do
	echo model$m
	cd model$m
	for s in 1 2; do
		echo set$s
		cd set$s
		for v in $(ls -1 pdbbind-*-trn-yxi.csv | cut -d- -f2); do
			echo $v
			echo seed,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-tst-stat.csv
			echo seed,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-trn-stat.csv
			for w in $(cat ../../seed.csv); do
				echo $w
				mkdir -p $w
				cd $w
				rf-train ../pdbbind-$v-trn-yxi.csv pdbbind-$v-trn.rf $w > pdbbind-$v-trn.txt
				rf-test pdbbind-$v-trn.rf ../pdbbind-$v-trn-yxi.csv pdbbind-$v-trn-iyp.csv > pdbbind-$v-trn-stat.csv
				rf-test pdbbind-$v-trn.rf ../tst-yxi.csv pdbbind-$v-tst-iyp.csv > pdbbind-$v-tst-stat.csv
				rm pdbbind-$v-trn.rf
				../../../corplot.R $v
				tail -n +6 pdbbind-$v-trn.txt | awk '{print substr($0,4,8)}' | ../../../varImpPlot.R $v
				cd ..
				echo -n $w, >> pdbbind-$v-tst-stat.csv
				echo -n $w, >> pdbbind-$v-trn-stat.csv
				tail -1 $w/pdbbind-$v-tst-stat.csv >> pdbbind-$v-tst-stat.csv
				tail -1 $w/pdbbind-$v-trn-stat.csv >> pdbbind-$v-trn-stat.csv
			done
		done
		cd ..
	done
	cd ..
done
