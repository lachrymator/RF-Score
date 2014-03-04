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
t=(tst trn trn trn trn)
for s in 1 2; do
	echo set$s
	for v0 in {0..3}; do
	for v1 in $(seq $((v0+1)) 4); do
		echo "|$v0 ∩ $v1| = "$(cut -d, -f1 $pdbbind/v${v[$s,$v0]}/rescoring-2-set-$s-${t[v0]}-iy.csv $pdbbind/v${v[$s,$v1]}/rescoring-2-set-$s-${t[v1]}-iy.csv | sort | uniq -d | wc -l)
	done
	done
done
