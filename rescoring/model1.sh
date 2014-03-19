for m in 1; do
	echo model$m
	cd model$m
	for s in 1 2; do
		echo set$s
		cd set$s
		if [[ $s == 1 ]]; then
			../../iypplot.R 2007 trn
			rm pdbbind-2007-trn-iyp.csv
		fi
		../../iypplot.R 2007 tst
		rm pdbbind-2007-tst-iyp.csv
		cd ..
	done
	cd ..
done
