for m in 1; do
	echo model$m
	cd model$m
	for s in 1 2; do
		echo set$s
		cd set$s
		../../couplelm.R 2007
		for t in trn tst; do
			../../iyprplot.R 2007 $t
			rm pdbbind-2007-$t-iyp.csv
		done
		cd ..
	done
	cd ..
done
