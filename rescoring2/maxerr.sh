n=10
for tst in 1 2; do
	w4[tst]=$(grep "2007,1,$tst," model4/set1/tst-stat.csv | cut -d, -f4)
done
echo model,tst,rank,pdb,pKd,pKd1,pKd4
for m in 1 4; do
	for tst in 1 2; do
		r=0
		for c in $(tail -n +2 model$m/set1/$([[ $m == 4 ]] && echo ${w4[tst]} || echo "")/pdbbind-2007-trn-1-tst-$tst-iypr.csv | awk -F, 'function abs(x){return x < 0 ? -x : x} {printf("%s,%.2f\n",$1,abs($2-$4))}' | sort -t, -k2,2nr | head -$n | cut -d, -f1); do
			r=$((r+1))
			iyr0=$(grep $c model1/set1/pdbbind-2007-trn-1-tst-$tst-iypr.csv | cut -d, -f1,2,4)
			r1=$(grep $c model4/set1/${w4[tst]}/pdbbind-2007-trn-1-tst-$tst-iypr.csv | cut -d, -f4)
			echo $m,$tst,$r,$iyr0,$r1
		done
	done
done
