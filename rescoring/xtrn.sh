for m in 2 3 4 5; do
	echo model$m
	cd model$m
	for s in 1 2; do
		echo set$s
		cd set$s
		ls -1 pdbbind-*-trn-yxi.csv | ~/idock/utilities/substr 8 4 | ../../xtrn.R
		cd ..
	done
	cd ..
done
