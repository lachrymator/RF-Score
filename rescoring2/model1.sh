for m in 1; do
	echo model$m
	cd model$m
	for s in 1 2; do
		echo set$s
		cd set$s
		for tst in 1 2; do
			../../iypplot.R 2007 1 $tst
		done
		../../idpplot.R 2007 1 2 $s
		cd ..
	done
	cd ..
done
