pdbbind=~/PDBbind
v=(2013 2002 2007 2010)
for m in 2 3 4; do
	cd model$m
	echo model$m
	[[ $m == 4 ]] && p=36 || p=0
	p=$((p+6))
	q=$((p+6))
	for s in 3; do
		cd set$s
		echo set$s
		for vi in {0..3}; do
			if [[ $vi == 0 ]]; then
				for tst in {0..5}; do
					echo tst-$tst-yxi.csv
					rf-prepare $pdbbind/v${v[$vi]}/rescoring-3-set-$s-tst-$tst-iy.csv $m | cut -d, -f1-$p,$q- | sed 's/_inter//g' > tst-$tst-yxi.csv
				done
			else
				for trn in 0; do
					echo pdbbind-${v[$vi]}-trn-$trn-yxi.csv
					rf-prepare $pdbbind/v${v[$vi]}/rescoring-3-set-$s-trn-$trn-iy.csv $m | cut -d, -f1-$p,$q- | sed 's/_inter//g' > pdbbind-${v[$vi]}-trn-$trn-yxi.csv
				done
			fi
		done
		cd ..
	done
	cd ..
done
