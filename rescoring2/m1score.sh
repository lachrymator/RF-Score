for m in 1; do
	echo model$m
	cd model$m
	for s in 1 2; do
		echo set$s
		cd set$s
		for tst in 1 2; do
			tail -n +2 pdbbind-2007-trn-1-tst-$tst-iyp.csv | cut -d, -f2,3 | rf-stat > pdbbind-2007-trn-1-tst-$tst-stat.csv
			../../corplot.R 2007 1 $tst
		done
		cd ..
	done
	cd ..
done
