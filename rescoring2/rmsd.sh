prefix=~/PDBbind
pwd=$(pwd)
rmsdt=2.0 # RMSD threshold, e.g. 0.5, 1.0, 1.5, 2.0, 2.5, 3.0
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
	rmsd1s=0
	k=0
	for c in $(cat ${c[$i]}); do
		k=$((k+1))
		echo $k $c
		cd $c
		rmsd1=$(head -1 vina.rmsd)
		if [[ $(echo "$rmsd1 < $rmsdt" | bc) == 1 ]]; then
			rmsd1s=$((rmsd1s+1))
		fi
	#	n=$(wc -l < vina.rmsd)
	#	rf-score dummy ../${c}_protein.pdbqt ${c}_ligand_ligand_1.pdbqt > model2-x.csv
	#	for i in $(seq 2 $n); do
	#		rf-score dummy ../${c}_protein.pdbqt ${c}_ligand_ligand_${i}.pdbqt | tail -1 >> model2-x.csv
	#	done
	#	cd out
	#	w=$(grep "WARNING" log/${c}_ligand.txt | wc -l)
	#	tail -n +$((26+w)) log/${c}_ligand.txt | head -$n | awk '{print substr($0,13,5) * -0.73349480509}' > out/model1-p.csv
	#	../../mlrtest.R 2007 1 dummy 0.015 dummy > model2-p.csv
	#	tail -n +2 model3-x.csv | rf-score ../../model3-pdbbind-2007-trn-1.rf > model3-p.csv
	#	tail -n +2 model4-x.csv | rf-score ../../model4-pdbbind-2007-trn-1.rf > model4-p.csv
	#	cd ..
	#	if [[ $(cat vina-scheme-3.txt) -eq $(paste ../../seq$n out/model4-p.csv | sort -k2,2nr | tail -n +$1 | head -1 | cut -f1) ]]; then
	#		s=$((s+1))
	#	fi
		cd ..
	done
	echo "The number of complexes where the pose with the lowest Vina score has RMSD < $rmsdt is $rmsd1s out of $k."
	cd $pwd
done
