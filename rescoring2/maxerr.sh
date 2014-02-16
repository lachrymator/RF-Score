echo model,tst,pdb,pKd,pKd1,pKd4
for m in 1 4; do
	if [[ $m -eq 4 ]]; then
		w=89757
	fi
	for tst in 1 2; do
		c=$(tail -n +2 model$m/set1/$w/pdbbind-2007-trn-1-tst-$tst-iyp.csv | awk -F, 'function abs(x){return x < 0 ? -x : x} {printf("%s,%.2f\n",$1,abs($2-$3))}' | sort -t, -k2,2nr | head -1 | cut -d, -f1)
		iyp0=$(grep $c model1/set1/pdbbind-2007-trn-1-tst-$tst-iyp.csv)
		p1=$(grep $c model4/set1/89757/pdbbind-2007-trn-1-tst-$tst-iyp.csv | cut -d, -f3)
		echo $m,$tst,$iyp0,$p1
	done
done
