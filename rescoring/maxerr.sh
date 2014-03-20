n=10
echo model,rank,pdb,pKd,pKd1,pKd4
for m in 1 4; do
	if [[ $m == 4 ]]; then
		w=47945
	fi
	r=0
	for c in $(tail -n +2 model$m/set1/$w/pdbbind-2007-tst-iypr.csv | awk -F, 'function abs(x){return x < 0 ? -x : x} {printf("%s,%.2f\n",$1,abs($2-$4))}' | sort -t, -k2,2nr | head -$n | cut -d, -f1); do
		r=$((r+1))
		iyr0=$(grep $c model1/set1/pdbbind-2007-tst-iypr.csv | cut -d, -f1,2,4)
		r1=$(grep $c model4/set1/47945/pdbbind-2007-tst-iypr.csv | cut -d, -f4)
		echo $m,$r,$iyr0,$r1
	done
done
