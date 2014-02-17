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
			for v in $(ls -1 pdbbind-*-trn-$trn-yxi.csv | cut -d- -f2); do
				echo $v
				echo seed,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-trn-$trn-trn-$trn-stat.csv
				for tst in $tsts; do
					echo seed,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-trn-$trn-tst-$tst-stat.csv
				done
				for w in 89757 35577 51105 72551 10642 69834 47945 52857 26894 99789; do
					echo $w
					mkdir -p $w
					cd $w
					rf-train ../pdbbind-$v-trn-$trn-yxi.csv pdbbind-$v-trn-$trn.rf $w > pdbbind-$v-trn-$trn.txt
					rf-test pdbbind-$v-trn-$trn.rf ../pdbbind-$v-trn-$trn-yxi.csv pdbbind-$v-trn-$trn-trn-$trn-iyp.csv > pdbbind-$v-trn-$trn-trn-$trn-stat.csv
					for tst in $tsts; do
						rf-test pdbbind-$v-trn-$trn.rf ../tst-$tst-yxi.csv pdbbind-$v-trn-$trn-tst-$tst-iyp.csv > pdbbind-$v-trn-$trn-tst-$tst-stat.csv
						../../../iypplot.R $v $trn $tst
					done
					rm pdbbind-$v-trn-$trn.rf
					tail -n +6 pdbbind-$v-trn-$trn.txt | awk '{print substr($0,4,8)}' | ../../../varImpPlot.R $v $trn
					if [[ $trn -ne 5 ]]; then
						cut -d, -f3 pdbbind-$v-trn-$trn-tst-2-iyp.csv | paste -d, ../../../set$s/tst-2-id.csv - > pdbbind-$v-trn-$trn-tst-2-idp.csv
						../../../idpplot.R $v $trn 2
					fi
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
