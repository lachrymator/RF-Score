n=10
for tst in 1 2; do
	w4[tst]=$(grep "2007,1,$tst," model4/set1/tst-stat.csv | cut -d, -f4)
done
echo model,tst,rank,pdb,pKd,pKd1,pKd4
for m in 1 4; do
	for tst in 1 2; do
		r=0
		for c in $(tail -n +2 model$m/set1/$([[ $m == 4 ]] && echo ${w4[tst]} || echo "")/pdbbind-2007-trn-1-tst-$tst-iyp.csv | awk -F, 'function abs(x){return x < 0 ? -x : x} {printf("%s,%.2f\n",$1,abs($2-$3))}' | sort -t, -k2,2nr | head -$n | cut -d, -f1); do
			r=$((r+1))
			iyp0=$(grep $c model1/set1/pdbbind-2007-trn-1-tst-$tst-iyp.csv)
			p1=$(grep $c model4/set1/${w4[tst]}/pdbbind-2007-trn-1-tst-$tst-iyp.csv | cut -d, -f3)
			echo $m,$tst,$r,$iyp0,$p1
		done
	done
done
