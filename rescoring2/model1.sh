for m in 1; do
	echo model$m
	cd model$m
	for s in 1 2; do
		echo set$s
		cd set$s
		for tst in 1 2; do
			tail -n +2 pdbbind-2007-trn-1-tst-$tst-iyp.csv | cut -d, -f2,3 | rf-stat > pdbbind-2007-trn-1-tst-$tst-stat.csv
			../../iypplot.R 2007 1 $tst
		done
		cut -d, -f3 pdbbind-2007-trn-1-tst-2-iyp.csv | paste -d, ../../set$s/tst-2-id.csv - > pdbbind-2007-trn-1-tst-2-idp.csv
		../../idpplot.R 2007 1 2
		cd ..
	done
	cd ..
done
