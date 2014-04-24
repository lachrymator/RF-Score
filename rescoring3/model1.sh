for m in 1; do
	echo model$m
	cd model$m
	for s in 3; do
		echo set$s
		cd set$s
		for tst in {0..5}; do
			echo tst$tst
			cut -d, -f2 ../../set3/tst-$tst-iy.csv | paste -d, - pdbbind-2007-trn-0-tst-$tst-p.csv | rf-stat > pdbbind-2007-trn-0-tst-$tst-stat.csv
			rm pdbbind-2007-trn-0-tst-$tst-p.csv
		done
		cd ..
	done
	cd ..
done
