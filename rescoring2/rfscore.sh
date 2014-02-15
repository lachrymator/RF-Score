for m in 3 4; do
	echo model$m
	cd model$m
	for s in 1 2; do
		echo set$s
		cd set$s
		for trn in 1 2 3 4 5; do
			echo trn$trn
			if [[ $trn -eq 5 ]]; then
				tsts=$(seq 5 5)
			else
				tsts=$(seq 1 2)
			fi
			for v in $(ls -1 pdbbind-*-trn-$trn-yxi.csv | ~/idock/utilities/substr 8 4); do
				echo $v
				echo seed,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-trn-$trn-trn-$trn-stat.csv
				for tst in $tsts; do
					echo seed,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-trn-$trn-tst-$tst-stat.csv
				done
				for w in $(cat ../../seed.csv); do
					echo $w
					mkdir -p $w
					cd $w
					rf-train ../pdbbind-$v-trn-$trn-yxi.csv pdbbind-$v-trn-$trn.rf $w > pdbbind-$v-trn-$trn.txt
					rf-test pdbbind-$v-trn-$trn.rf ../pdbbind-$v-trn-$trn-yxi.csv pdbbind-$v-trn-$trn-trn-$trn-iyp.csv > pdbbind-$v-trn-$trn-trn-$trn-stat.csv
					for tst in $tsts; do
						rf-test pdbbind-$v-trn-$trn.rf ../tst-$tst-yxi.csv pdbbind-$v-trn-$trn-tst-$tst-iyp.csv > pdbbind-$v-trn-$trn-tst-$tst-stat.csv
						../../../corplot.R $v $trn $tst
					done
					rm pdbbind-$v-trn-$trn.rf
					tail -n +6 pdbbind-$v-trn-$trn.txt | ~/idock/utilities/substr 3 8 | ../../../varImpPlot.R $v $trn
					cd ..
					echo -n $w, >> pdbbind-$v-trn-$trn-trn-$trn-stat.csv
					tail -1 $w/pdbbind-$v-trn-$trn-trn-$trn-stat.csv >> pdbbind-$v-trn-$trn-trn-$trn-stat.csv
					for tst in $tsts; do
						echo -n $w, >> pdbbind-$v-trn-$trn-tst-$tst-stat.csv
						tail -1 $w/pdbbind-$v-trn-$trn-tst-$tst-stat.csv >> pdbbind-$v-trn-$trn-tst-$tst-stat.csv
					done
				done
			done
		done
		cd ..
	done
	cd ..
done
