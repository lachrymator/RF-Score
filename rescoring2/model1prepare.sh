prefix=~/PDBbind/
m=1
cd model$m
echo model$m
cd set1
echo set1
tail -n +2 ../../set1/tst-1-iy.csv > tst-1-iy.csv
echo PDB,pbindaff,predicted > pdbbind-2007-trn-1-tst-1-iyp.csv
for c in $(cat $prefix/v2007/pdbbind-2007-core-i.csv); do
	tail -n +18 $prefix/v2007/${c}/vina_score.txt | head -1
done | cut -d' ' -f2 | awk '{printf "%.2f\n", $1*-0.73349480509}' | paste -d, tst-1-iy.csv - >> pdbbind-2007-trn-1-tst-1-iyp.csv
echo PDB,pbindaff,predicted > pdbbind-2007-trn-1-tst-2-iyp.csv
for c in $(cat $prefix/v2007/pdbbind-2007-core-i.csv); do
	tail -n +18 $prefix/v2007/${c}/out/${c}_ligand_ligand_1.txt | head -1
done | cut -d' ' -f2 | awk '{printf "%.2f\n", $1*-0.73349480509}' | paste -d, tst-1-iy.csv - >> pdbbind-2007-trn-1-tst-2-iyp.csv
rm tst-1-iy.csv
cd ..
cd set2
echo set2
tail -n +2 ../../set2/tst-1-iy.csv > tst-1-iy.csv
echo PDB,pbindaff,predicted > pdbbind-2007-trn-1-tst-1-iyp.csv
for c in $(cat $prefix/v2013/rescoring2.csv); do
	tail -n +18 $prefix/v2013/${c}/vina_score.txt | head -1
done | cut -d' ' -f2 | awk '{printf "%.2f\n", $1*-0.73349480509}' | paste -d, tst-1-iy.csv - >> pdbbind-2007-trn-1-tst-1-iyp.csv
echo PDB,pbindaff,predicted > pdbbind-2007-trn-1-tst-2-iyp.csv
for c in $(cat $prefix/v2013/rescoring2.csv); do
	tail -n +18 $prefix/v2013/${c}/out/${c}_ligand_ligand_1.txt | head -1
done | cut -d' ' -f2 | awk '{printf "%.2f\n", $1*-0.73349480509}' | paste -d, tst-1-iy.csv - >> pdbbind-2007-trn-1-tst-2-iyp.csv
rm tst-1-iy.csv
cd ..
cd ..
