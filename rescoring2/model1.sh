for m in 1; do
	echo model$m
	cd model$m
	for s in 1 2; do
		echo set$s
		cd set$s
		for tst in 1 2; do
			../../iyprplot.R 2007 1 $tst
			rm pdbbind-2007-trn-1-tst-$tst-iyp.csv
		done
		cut -d, -f3,4 pdbbind-2007-trn-1-tst-2-iypr.csv | paste -d, ../../set$s/tst-2-id.csv - > pdbbind-2007-trn-1-tst-2-idpr.csv
		../../idprplot.R 2007 1 2
		cd ..
	done
	cd ..
done
