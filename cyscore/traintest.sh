#!/usr/bin/env bash
ntsts=$(echo 195 201 382)
ntrns=$(echo 247 1105 2280)
echo x,model,ntrn,n,rmse,sdev,pcor,scor,kcor,n,rmse,sdev,pcor,scor,kcor,n,rmse,sdev,pcor,scor,kcor
for x in 2 4; do
	cd x$x
	cd mlr
	for ntrn in $ntrns; do
		mkdir -p trn-$ntrn
		cd trn-$ntrn
		../mlr.R $ntrn
		echo $x,MLR,$ntrn,$(tail -1 tst-195-stat.csv),$(tail -1 tst-201-stat.csv),$(tail -1 tst-382-stat.csv)
		cd ..
	done
	cd ..
	cd rf
	for ntrn in $ntrns; do
		mkdir -p trn-$ntrn
		cd trn-$ntrn
		rf-train ../../trn-$ntrn-yxi.csv trn.rf > trn.txt
		for ntst in $ntsts; do
			rf-test trn.rf ../../tst-$ntst-yxi.csv > tst-$ntst-iyp.csv
			tail -n +2 tst-$ntst-iyp.csv | cut -d, -f2,3 | rf-stat > tst-$ntst-stat.csv
		done
		echo $x,RF,$ntrn,$(tail -1 tst-195-stat.csv),$(tail -1 tst-201-stat.csv),$(tail -1 tst-382-stat.csv)
		cd ..
	done
	cd ..
	cd ..
done
