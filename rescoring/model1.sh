for m in 1; do
	echo model$m
	cd model$m
	for s in 1 2; do
		echo set$s
		cd set$s
		if [[ $s == 1 ]]; then
			tail -n +2 pdbbind-2007-trn-iyp.csv | cut -d, -f2,3 | rf-stat > pdbbind-2007-trn-stat.csv
		fi
		tail -n +2 pdbbind-2007-tst-iyp.csv | cut -d, -f2,3 | rf-stat > pdbbind-2007-tst-stat.csv
		../../iypplot.R 2007
		cd ..
	done
	cd ..
done
