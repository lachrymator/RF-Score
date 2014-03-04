prefix=~/PDBbind
v=(dummy 2007 2013)
m=1
cd model$m
echo model$m
for s in 1 2; do
	cd set$s
	echo set$s
	tail -n +2 ../../set$s/tst-1-iy.csv > tst-1-iy.csv
	echo PDB,pbindaff,predicted > pdbbind-2007-trn-1-tst-1-iyp.csv
	for iy in $(cat $prefix/v${v[s]}/rescoring-2-set-$s-tst-iy.csv); do
		c=${iy:0:4}
		tail -n +18 $prefix/v${v[s]}/${c}/vina_score.txt | head -1
	done | cut -d' ' -f2 | awk '{printf "%.2f\n", $1*-0.73349480509}' | paste -d, tst-1-iy.csv - >> pdbbind-2007-trn-1-tst-1-iyp.csv
	echo PDB,pbindaff,predicted > pdbbind-2007-trn-1-tst-2-iyp.csv
	for iy in $(cat $prefix/v${v[s]}/rescoring-2-set-$s-tst-iy.csv); do
		c=${iy:0:4}
		tail -n +18 $prefix/v${v[s]}/${c}/out/${c}_ligand_ligand_1.txt | head -1
	done | cut -d' ' -f2 | awk '{printf "%.2f\n", $1*-0.73349480509}' | paste -d, tst-1-iy.csv - >> pdbbind-2007-trn-1-tst-2-iyp.csv
	rm tst-1-iy.csv
	cd ..
done
cd ..
