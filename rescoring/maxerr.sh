n=10
w4=$(grep "2007," model4/set1/tst-stat.csv | cut -d, -f2)
echo model,rank,pdb,pKd,pKd1,pKd4
for m in 1 4; do
	r=0
	for c in $(tail -n +2 model$m/set1/$([[ $m == 4 ]] && echo $w4 || echo "")/pdbbind-2007-tst-iyp.csv | awk -F, 'function abs(x){return x < 0 ? -x : x} {printf("%s,%.2f\n",$1,abs($2-$3))}' | sort -t, -k2,2nr | head -$n | cut -d, -f1); do
		r=$((r+1))
		iyr0=$(grep $c model1/set1/pdbbind-2007-tst-iyp.csv | cut -d, -f1,2,3)
		r1=$(grep $c model4/set1/$w4/pdbbind-2007-tst-iyp.csv | cut -d, -f3)
		echo $m,$r,$iyr0,$r1
	done
done
