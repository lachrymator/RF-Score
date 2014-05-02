#!/usr/bin/env bash
trns=(247 1105 2696 792 1300 2059 2897 592 1184 1776 2367)
tsts=(195 201 195 201 382 382 382 382 592 592 592 592)
ntsts=(2 1 1 1 1 1 1 1 1 1 1)
trnis=$(seq 0 $((${#trns[*]}-1)))
echo model,x,trn,tst,rmse,sdev,pcor,scor,kcor
for x in 4; do
	mkdir -p x$x
	cd x$x
	mkdir -p mlr
	cd mlr
	tsti=0
	for trni in $trnis; do
		trn=${trns[$trni]}
		../mlrtrain.R $trn
		for i in $(seq 1 ${ntsts[$trni]}); do
			tst=${tsts[$tsti]}
			tsti=$((tsti+1))
			../mlrtest.R $trn $tst
			../../iypplot.R $trn $tst
			printf "%3s,%2s,%4s,%s\n" MLR $x $trn $(tail -1 trn-$trn-tst-$tst-stat.csv)
		done
	done
	cd ..
	cd ..
done
for x in 4 10 46; do
	mkdir -p x$x
	cd x$x
	mkdir -p rf
	cd rf
	tsti=0
	for trni in $trnis; do
		trn=${trns[$trni]}
		rf-train ../trn-$trn-yxi.csv trn-$trn.rf > trn-$trn.txt
		tail -n +6 trn-$trn.txt | awk '{print substr($0,4,8)}' | ../../varimpplot.R $trn
		for i in $(seq 1 ${ntsts[$trni]}); do
			tst=${tsts[$tsti]}
			tsti=$((tsti+1))
			rf-test trn-$trn.rf ../tst-$tst-yxi.csv > trn-$trn-tst-$tst-iyp.csv
			../../iypplot.R $trn $tst
			printf "%3s,%2s,%4s,%s\n" RF $x $trn $(tail -1 trn-$trn-tst-$tst-stat.csv)
		done
	done
	cd ..
	cd ..
done
#sort -t, -k4,4n -k1,1 -k2,2n -k3,3n traintest.csv | cut -d, -f1-3,5-8 | sed -e 's/,/ \& /g' | awk '{print $0"\\\\"}'
