#!/usr/bin/env bash
tsts=$(echo 195 201 382)
trns=$(echo 247 1105 2280 792 1300 2059 2897)
echo x,model,trn,tst,rmse,sdev,pcor,scor,kcor
for x in 2 4 10 40 46 42; do
	cd x$x
	mkdir -p mlr
	cd mlr
	for trn in $trns; do
		../mlrtrain.R $trn
		for tst in $tsts; do
			../mlrtest.R $trn $tst
			../../iyprplot.R $trn $tst
			echo $x,MLR,$trn,$(tail -1 trn-$trn-tst-$tst-stat.csv)
		done
	done
	cd ..
	mkdir -p rf
	cd rf
	for trn in $trns; do
		rf-train ../trn-$trn-yxi.csv trn-$trn.rf > trn-$trn.txt
		tail -n +6 trn-$trn.txt | awk '{print substr($0,4,8)}' | ../../varimpplot.R $trn
		for tst in $tsts; do
			rf-test trn-$trn.rf ../tst-$tst-yxi.csv > trn-$trn-tst-$tst-iyp.csv
			../../iyprplot.R $trn $tst
			echo $x,RF,$trn,$(tail -1 trn-$trn-tst-$tst-stat.csv)
		done
	done
	cd ..
	cd ..
done
