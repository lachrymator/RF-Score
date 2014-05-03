trn=1105
tst=195
cd x46/rf
	for w in 89757 35577 51105 72551 10642 69834 47945 52857 26894 99789; do
		rf-train ../trn-$trn-yxi.csv trn-$trn-$w.rf $w > trn-$trn-$w.txt
		rf-test trn-$trn-$w.rf ../tst-$tst-yxi.csv > trn-$trn-$w-tst-$tst-iyp.csv
		../../iypplot.R $trn-$w $tst
		printf "%3s,%2s,%4s,%5s,%s\n" RF $x $trn $w $(tail -1 trn-$trn-$w-tst-$tst-stat.csv)
	done
cd ../..
