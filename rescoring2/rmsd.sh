prefix=~/PDBbind
pwd=$(pwd)
rmsdts=(0.5 1.0 1.5 2.0 2.5 3.0) # RMSD thresholds
v=(2007 2013)
c=(pdbbind-2007-core-i.csv rescoring2.csv)
for s in 1 2; do
	echo set$s
	w2=$(tail -n +2 model2/set$s/tst-stat.csv | grep 2007,1,1, | cut -d, -f4)
	w3=$(tail -n +2 model3/set$s/tst-stat.csv | grep 2007,1,1, | cut -d, -f4)
	if [[ ! -s model3/set$s/$w3/pdbbind-2007-trn-1.rf ]]; then
		rf-train model3/set$s/pdbbind-2007-trn-1-yxi.csv model3/set$s/$w3/pdbbind-2007-trn-1.rf $w3
	fi
	w4=$(tail -n +2 model4/set$s/tst-stat.csv | grep 2007,1,1, | cut -d, -f4)
	if [[ ! -s model4/set$s/$w4/pdbbind-2007-trn-1.rf ]]; then
		rf-train model4/set$s/pdbbind-2007-trn-1-yxi.csv model4/set$s/$w4/pdbbind-2007-trn-1.rf $w4
	fi
	i=$((s-1))
	cd $prefix/v${v[$i]}
	rmsd1s=(0 0 0 0 0 0)
	rmsdms=(0 0 0 0 0 0)
	rmsdim=0
	k=0
	for c in $(cat ${c[$i]}); do
		k=$((k+1))
#		echo $k $c
		cd $c
		rmsdf=vina.rmsd
		rmsd1=$(head -1 $rmsdf)
		rmsdm=$(sort -n $rmsdf | head -1)
		for i in $(seq 0 5); do
			if [[ $(bc <<< "$rmsd1 < ${rmsdts[$i]}") == 1 ]]; then
				rmsd1s[$i]=$((rmsd1s[$i]+1))
			fi
			if [[ $(bc <<< "$rmsdm < ${rmsdts[$i]}") == 1 ]]; then
				rmsdms[$i]=$((rmsdms[$i]+1))
			fi
		done
		s3=$(cat vina-scheme-3.txt)
		n=$(wc -l < vina.rmsd)
#		rf-score dummy ../${c}_protein.pdbqt ${c}_ligand_ligand_1.pdbqt > model2-x.csv
#		for i in $(seq 2 $n); do
#			rf-score dummy ../${c}_protein.pdbqt ${c}_ligand_ligand_${i}.pdbqt | tail -1 >> model2-x.csv
#		done
		w=$(grep "WARNING" log/${c}_ligand.txt | wc -l)
		tail -n +$((26+w)) log/${c}_ligand.txt | head -$n | awk '{print substr($0,13,5) * -0.73349480509}' > out/model1-p.csv
		cd out
#		../../mlrtest.R 2007 1 dummy $w2 dummy > model2-p.csv
#		tail -n +2 model3-x.csv | rf-score model3/set$s/$w3/pdbbind-2007-trn-1.rf > model3-p.csv
#		tail -n +2 model4-x.csv | rf-score model4/set$s/$w4/pdbbind-2007-trn-1.rf > model4-p.csv
		if [[ $s3 == $(paste ../../../seq$n model1-p.csv | sort -k2,2nr | tail -n +1 | head -1 | cut -f1) ]]; then # tail -n +$1
			rmsdim1=$((rmsd1m+1))
		fi
		cd ..
		cd ..
	done
	echo "condition,#,%"
	for i in $(seq 0 5); do
		echo RMSD1"<"${rmsdts[$i]},${rmsd1s[$i]},$(printf "%.0f\n" $(bc -l <<< "${rmsd1s[$i]} * 100 / $k"))%
	done
	for i in $(seq 0 5); do
		echo RMSDm"<"${rmsdts[$i]},${rmsdms[$i]},$(printf "%.0f\n" $(bc -l <<< "${rmsdms[$i]} * 100 / $k"))%
	done
	echo $rmsdim1
	cd $pwd
done