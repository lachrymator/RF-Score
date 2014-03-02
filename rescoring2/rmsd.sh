prefix=~/PDBbind
s=1
w2=$(tail -n +2 model2/set$s/tst-stat.csv | head -1 | cut -d, -f4)
w3=$(tail -n +2 model3/set$s/tst-stat.csv | head -1 | cut -d, -f4)
if [[ ! -s model3/set$s/$w3/pdbbind-2007-trn-1.rf ]]; then
	rf-train model3/set$s/pdbbind-2007-trn-1-yxi.csv model3/set$s/$w3/pdbbind-2007-trn-1.rf $w3
fi
w4=$(tail -n +2 model4/set$s/tst-stat.csv | head -1 | cut -d, -f4)
if [[ ! -s model4/set$s/$w4/pdbbind-2007-trn-1.rf ]]; then
	rf-train model4/set$s/pdbbind-2007-trn-1-yxi.csv model4/set$s/$w4/pdbbind-2007-trn-1.rf $w4
fi
rmsd1s=0
k=0
for c in $(cat $prefix/v2007/pdbbind-2007-core-i.csv); do
	k=$((k+1))
	rmsd1=$(head -1 $prefix/v2007/${c}/vina.rmsd)
	if [[ $(echo "$rmsd1 < 2.0" | bc) == 1 ]]; then
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
done
echo "The number of complexes where the pose with the lowest Vina score has RMSD < 2.0 is $rmsd1s out of $k."
