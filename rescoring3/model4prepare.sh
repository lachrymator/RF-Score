pdbbind=~/PDBbind
v=(2013 2002 2007 2010)
for m in 2 3 4; do
	cd model$m
	echo model$m
	[[ $m == 4 ]] && p=36 || p=0
	p=$((p+6))
	q=$((p+6))
	for s in 3; do
		cd set$s
		echo set$s
		for vi in {0..3}; do
			if [[ $vi == 0 ]]; then
				for tst in {0..5}; do
					echo tst-$tst-yxi.csv
					rf-prepare $pdbbind/v${v[$vi]}/rescoring-3-set-$s-tst-$tst-iy.csv $m 2 | cut -d, -f1-$p,$q- | sed 's/_inter//g' > tst-$tst-yxi.csv
				done
			else
				for trn in 0; do
					echo pdbbind-${v[$vi]}-trn-$trn-yxi.csv
					rf-prepare $pdbbind/v${v[$vi]}/rescoring-3-set-$s-trn-$trn-iy.csv $m 2 | cut -d, -f1-$p,$q- | sed 's/_inter//g' > pdbbind-${v[$vi]}-trn-$trn-yxi.csv
				done
			fi
		done
		cd ..
	done
	cd ..
done
for m in 2 3 4; do
	cd model$m
	echo model$m
	for s in 3; do
		cd set$s
		echo set$s
		for trn in {1..10}; do
			echo pdbbind-2010-trn-$trn-yxi.csv
			head -1 pdbbind-2010-trn-0-yxi.csv > pdbbind-2010-trn-$trn-yxi.csv
			([[ $trn -le 5 ]] && cut -d, -f1 ../../set3/pdbbind-2010-trn-$trn-iy.csv || cut -d, -f1 ../../set3/pdbbind-2010-trn-0-iy.csv ../../set3/pdbbind-2010-trn-$((trn-5))-iy.csv | sort | uniq -u) | grep -f - pdbbind-2010-trn-0-yxi.csv >> pdbbind-2010-trn-$trn-yxi.csv
		done
		mmm=$(tail -n +2 pdbbind-2010-trn-0-yxi.csv | awk -F, '
		{
			for (i=2; i<NF; ++i) {
				if (min[i]=="") {
					min[i]=$i
				} else if (min[i]>$i) {
					min[i]=$i
				}
				if (max[i]=="") {
					max[i]=$i
				} else if (max[i]<$i) {
					max[i]=$i
				}
			}
		} END {
			for (i=2; i<NF; ++i) {
				printf ",%.4f",max[i]-min[i]
			}
		}
		');
		ks=(10 50 100 150 200)
		for tst in {1..5}; do
			for yxi in $(tail -n +2 tst-$tst-yxi.csv); do
				tail -n +2 pdbbind-2010-trn-0-yxi.csv | awk -F, -v mmm=$mmm -v yxi=$yxi '
				BEGIN {
					split(mmm,mmma,",")
					split(yxi,yxia,",")
				} function abs(x) {
					return x < 0 ? -x : x
				} {
					s=0
					for (i=2; i<NF; ++i) {
						s+=abs(yxia[i]-$i)/mmma[i]
					}
					printf "%.4f\t%s\n",s,$NF
				}
				' | sort -k1,1n | head -$(IFS=$'\n' sort -nr <<< "${ks[*]}") | cut -f2 > pdbbind-2010-trn-$tst-i.csv
				for i in {0..4}; do
					head -${ks[$i]} pdbbind-2010-trn-$tst-i.csv >> pdbbind-2010-trn-$((10+i*5+tst))-i.csv
				done
			done
			rm pdbbind-2010-trn-$tst-i.csv
			for i in {0..4}; do
				trn=$((10+i*5+tst))
				echo pdbbind-2010-trn-$trn-yxi.csv
				head -1 pdbbind-2010-trn-0-yxi.csv > pdbbind-2010-trn-$trn-yxi.csv
				sort pdbbind-2010-trn-$trn-i.csv | uniq | grep -f - pdbbind-2010-trn-0-yxi.csv >> pdbbind-2010-trn-$trn-yxi.csv
				rm pdbbind-2010-trn-$trn-i.csv
			done
		done
		cd ..
	done
	cd ..
done
