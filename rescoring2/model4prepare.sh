prefix=~/PDBbind
m=4 # Update src/rf-prepare.cpp and src/feature.hpp before changing m from 4 to 3 or 2.
cd model$m
echo model$m
s=1
cd set$s
echo set$s
for v in 2007; do
	for trn in {1..6}; do
		echo tst-$trn-yxi.csv
		rf-prepare $prefix/v$v/rescoring-2-set-$s-tst-iy.csv tst-$trn-yxi.csv $trn
	done
done
for v in 2007; do
	echo $v
	for trn in {1..6}; do
		echo pdbbind-$v-trn-$trn-yxi.csv
		rf-prepare $prefix/v$v/rescoring-2-set-$s-trn-iy.csv pdbbind-$v-trn-$trn-yxi.csv $trn
	done
done
cd ..
s=2
cd set$s
echo set$s
for v in 2013; do
	for trn in {1..6}; do
		echo tst-$trn-yxi.csv
		rf-prepare $prefix/v$v/rescoring-2-set-$s-tst-iy.csv tst-$trn-yxi.csv $trn
	done
done
for v in 2002 2007 2010 2012; do
	echo $v
	for trn in {1..6}; do
		echo pdbbind-$v-trn-$trn-yxi.csv
		rf-prepare $prefix/v$v/rescoring-2-set-$s-trn-iy.csv pdbbind-$v-trn-$trn-yxi.csv $trn
	done
done
cd ..
cd ..
