pdbbind=~/PDBbind
declare -A v
v[1,0]=2007
v[1,1]=2004
v[1,2]=2007
v[1,3]=2010
v[1,4]=2013
v[2,0]=2013
v[2,1]=2002
v[2,2]=2007
v[2,3]=2010
v[2,4]=2012
m=4 # Update src/rf-prepare.cpp and src/feature.cpp before changing m from 4 to 3 or 2.
cd model$m
echo model$m
for s in 1 2; do
	cd set$s
	echo set$s
	for vi in {0..4}; do
		for trn in {1..6}; do
			if [[ $vi == 0 ]]; then
				echo tst-$trn-yxi.csv
				rf-prepare $pdbbind/v${v[$s,$vi]}/rescoring-2-set-$s-tst-iy.csv tst-$trn-yxi.csv $trn
			else
				echo pdbbind-${v[$s,$vi]}-trn-$trn-yxi.csv
				rf-prepare $pdbbind/v${v[$s,$vi]}/rescoring-2-set-$s-trn-iy.csv pdbbind-${v[$s,$vi]}-trn-$trn-yxi.csv $trn
			fi
		done
	done
	cd ..
done
cd ..
