pdbbind=~/PDBbind
v=(2013 2002 2007 2010)
t=(tst trn trn trn)
for s in 3; do
	echo set$s
	for v0 in {0..2}; do
	for v1 in $(seq $((v0+1)) 3); do
		echo "|$v0 ∩ $v1| = "$(cut -d, -f1 $pdbbind/v${v[$v0]}/rescoring-3-set-$s-${t[v0]}-0-iy.csv $pdbbind/v${v[$v1]}/rescoring-3-set-$s-${t[v1]}-0-iy.csv | sort | uniq -d | wc -l)
	done
	done
done
