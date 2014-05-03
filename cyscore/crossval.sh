#!/usr/bin/env bash
#cp tst-592-yxi.csv tst-cv3-yxi.csv
#cp trn-2367-yxi.csv trn-cv3-yxi.csv
#head -1 tst-592-yxi.csv > h.csv
#tail -n +2 trn-2367-yxi.csv | head -592 | cat h.csv - > tst-cv1-yxi.csv
#tail -n +594 trn-2367-yxi.csv | head -592 | cat h.csv - > tst-cv2-yxi.csv
#tail -n +1186 trn-2367-yxi.csv | head -592 | cat h.csv - > tst-cv4-yxi.csv
#tail -n +1778 trn-2367-yxi.csv | head -591 | cat h.csv - > tst-cv5-yxi.csv
#tail -q -n +2 tst-cv2-yxi.csv tst-cv3-yxi.csv tst-cv4-yxi.csv tst-cv5-yxi.csv | cat h.csv - > trn-cv1-yxi.csv
#tail -q -n +2 tst-cv1-yxi.csv tst-cv3-yxi.csv tst-cv4-yxi.csv tst-cv5-yxi.csv | cat h.csv - > trn-cv2-yxi.csv
#tail -q -n +2 tst-cv1-yxi.csv tst-cv2-yxi.csv tst-cv3-yxi.csv tst-cv5-yxi.csv | cat h.csv - > trn-cv4-yxi.csv
#tail -q -n +2 tst-cv1-yxi.csv tst-cv2-yxi.csv tst-cv3-yxi.csv tst-cv4-yxi.csv | cat h.csv - > trn-cv5-yxi.csv
#rm h.csv
echo model,x,cv,tst,rmse,sdev,pcor,scor,kcor
for x in 4; do
	cd x$x/mlr
	for cv in {1..5}; do
		../mlrtrain.R cv$cv
		../mlrtest.R cv$cv cv$cv
		../../iypplot.R cv$cv cv$cv
		printf "%3s,%2s,%1s,%s\n" MLR $x $cv $(tail -1 trn-cv$cv-tst-cv$cv-stat.csv)
	done
	cd ../..
done
for x in 4 10 46; do
	cd x$x/rf
	for cv in {1..5}; do
		rf-train ../trn-cv$cv-yxi.csv trn-cv$cv.rf > trn-cv$cv.txt
		rf-test trn-cv$cv.rf ../tst-cv$cv-yxi.csv > trn-cv$cv-tst-cv$cv-iyp.csv
		../../iypplot.R cv$cv cv$cv
		printf "%3s,%2s,%1s,%s\n" RF $x $cv $(tail -1 trn-cv$cv-tst-cv$cv-stat.csv)
	done
	cd ../..
done
