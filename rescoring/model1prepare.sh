pdbbind=~/PDBbind
v=(dummy 2007 2013)
for m in 1; do
	cd model$m
	echo model$m
	for s in 1 2; do
		cd set$s
		echo set$s
		for t in $([[ $s == 1 ]] && echo "tst trn" || echo "tst"); do
			tail -n +2 ../../set$s/$t-iy.csv > $t-iy.csv
			echo PDB,pbindaff,predicted > pdbbind-2007-$t-iyp.csv
			for iy in $(cat $pdbbind/v${v[s]}/rescoring-1-set-$s-$t-iy.csv); do
				c=${iy:0:4}
				tail -n +18 $pdbbind/v${v[s]}/${c}/out/${c}_ligand_ligand_0.txt | head -1
			done | cut -d' ' -f2 | awk '{printf "%.2f\n", $1*-0.73349480509}' | paste -d, $t-iy.csv - >> pdbbind-2007-$t-iyp.csv
			rm $t-iy.csv
		done
		cd ..
	done
	cd ..
done
