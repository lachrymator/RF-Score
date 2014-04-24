for m in 1; do
	echo model$m
	cd model$m
	for s in 3; do
		echo set$s
		cd set$s
		for f in {0..5}; do
			echo family$f
			cut -d, -f2 ../../set3/tst-$f-iy.csv | paste -d, - pdbbind-2007-tst-$f-p.csv | rf-stat > pdbbind-2007-tst-$f-stat.csv
		done
		cd ..
	done
	cd ..
done
