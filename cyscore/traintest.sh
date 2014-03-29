#!/usr/bin/env bash
ntrn=(247 1105 2280)
vtrn=(2012 2007 2013)
echo x,model,ntrn,n,rmse,sdev,pcor,scor,kcor,n,rmse,sdev,pcor,scor,kcor,n,rmse,sdev,pcor,scor,kcor
for x in 2 4; do
	cd x$x
	cd mlr
	for i in {0..2}; do
		mkdir -p pdbbind-${vtrn[i]}-trn
		cd pdbbind-${vtrn[i]}-trn
		../mlr.R ${vtrn[i]}
		echo $x,MLR,${ntrn[i]},$(tail -1 pdbbind-2007-tst-stat.csv),$(tail -1 pdbbind-2012-tst-stat.csv),$(tail -1 pdbbind-2013-tst-stat.csv)
		cd ..
	done
	cd ..
	cd rf
	for i in {0..2}; do
		mkdir -p pdbbind-${vtrn[i]}-trn
		cd pdbbind-${vtrn[i]}-trn
		rf-train ../../pdbbind-${vtrn[i]}-trn-yxi.csv trn.rf > trn.txt
		for v in 2007 2012 2013; do
			rf-test trn.rf ../../pdbbind-$v-tst-yxi.csv > pdbbind-$v-tst-iyp.csv
			tail -n +2 pdbbind-$v-tst-iyp.csv | cut -d, -f2,3 | rf-stat > pdbbind-$v-tst-stat.csv
		done
		echo $x,RF,${ntrn[i]},$(tail -1 pdbbind-2007-tst-stat.csv),$(tail -1 pdbbind-2012-tst-stat.csv),$(tail -1 pdbbind-2013-tst-stat.csv)
		cd ..
	done
	cd ..
	cd ..
done
