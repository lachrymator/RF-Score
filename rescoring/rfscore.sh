for v in $(ls -1 pdbbind-*-trn-yxi.csv | ~/idock/utilities/substr 8 4); do
	echo $v
	echo seed,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-tst-stat.csv
	echo seed,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-trn-stat.csv
	for s in $(cat ../../seed.csv); do
		echo $s
		mkdir -p $s
		cd $s
		rf-train ../pdbbind-$v-trn-yxi.csv pdbbind-$v-trn.rf $s > pdbbind-$v-trn.txt
		rf-test pdbbind-$v-trn.rf ../pdbbind-$v-trn-yxi.csv pdbbind-$v-trn-iyp.csv > pdbbind-$v-trn-stat.csv
		rf-test pdbbind-$v-trn.rf ../tst-yxi.csv pdbbind-$v-tst-iyp.csv > pdbbind-$v-tst-stat.csv
		rm pdbbind-$v-trn.rf
		../../../plot.R $v
		tail -n +6 pdbbind-$v-trn.txt | ~/idock/utilities/substr 3 8 | ../../../varImpPlot.R $v
		cd ..
		echo -n $s, >> pdbbind-$v-tst-stat.csv
		echo -n $s, >> pdbbind-$v-trn-stat.csv
		tail -1 $s/pdbbind-$v-tst-stat.csv >> pdbbind-$v-tst-stat.csv
		tail -1 $s/pdbbind-$v-trn-stat.csv >> pdbbind-$v-trn-stat.csv
	done
done
