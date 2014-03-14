pdbbind=~/PDBbind
v=(dummy 2007 2013)
m=1
cd model$m
echo model$m
for s in 1 2; do
	cd set$s
	echo set$s
	tail -n +2 ../../set$s/tst-iy.csv > tst-iy.csv
	echo PDB,pbindaff,predicted > pdbbind-2007-tst-iyp.csv
	for iy in $(cat $pdbbind/v${v[s]}/rescoring-1-set-$s-tst-iy.csv); do
		c=${iy:0:4}
		tail -n +18 $pdbbind/v${v[s]}/${c}/out/${c}_ligand_ligand_0.txt | head -1
	done | cut -d' ' -f2 | awk '{printf "%.2f\n", $1*-0.73349480509}' | paste -d, tst-iy.csv - >> pdbbind-2007-tst-iyp.csv
	rm tst-iy.csv
	cd ..
done
cd ..
