pdbbind=~/PDBbind
for m in 1; do
	cd model$m
	echo model$m
	for s in 3; do
		cd set$s
		echo set$s
		for tst in {0..5}; do
			echo tst$tst
			for c in $(cut -d, -f1 $pdbbind/v2013/rescoring-3-set-$s-tst-$tst-iy.csv); do
				tail -n +18 $pdbbind/v2013/${c}/out/${c}_ligand_ligand_1.txt | head -1
			done | cut -d' ' -f2 | awk '{printf "%.2f\n", $1*-0.73349480509}' > pdbbind-2007-trn-0-tst-$tst-p.csv
		done
		cd ..
	done
	cd ..
done
