prefix=~/PDBbind
m=4
cd model$m
echo model$m
cd set1
echo set1
for v in 2007; do
	for trn in 1 2 3 4 5 6; do
		echo tst-$trn-yxi.csv
		rf-prepare $prefix/v$v/pdbbind-$v-core-iy.csv tst-$trn-yxi.csv $trn
	done
done
for v in 2007; do
	echo $v
	for trn in 1 2 3 4 5 6; do
		echo pdbbind-$v-trn-$trn-yxi.csv
		rf-prepare $prefix/v$v/pdbbind-$v-refined-core-iy.csv pdbbind-$v-trn-$trn-yxi.csv $trn
	done
done
cd ..
cd set2
echo set2
for v in 2013; do
	for trn in 1 2 3 4 5 6; do
		echo tst-$trn-yxi.csv
		rf-prepare $prefix/v$v/rescoring2-iy.csv tst-$trn-yxi.csv $trn
	done
done
for v in 2002 2007 2010 2012; do
	echo $v
	for trn in 1 2 3 4 5 6; do
		echo pdbbind-$v-trn-$trn-yxi.csv
		rf-prepare $prefix/v$v/rescoring2-iy.csv pdbbind-$v-trn-$trn-yxi.csv $trn
	done
done
cd ..
cd ..
