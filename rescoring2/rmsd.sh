pdbbind=~/PDBbind
rmsdts=(0.5 1.0 1.5 2.0 2.5 3.0) # RMSD thresholds
v=(2007 2013)
for s in 1 2; do
	echo set$s
	w2=$(tail -n +2 model2/set$s/tst-stat.csv | grep 2007,1,1, | cut -d, -f4) # Always use PDBbind v2007 as training set, no matter what set is.
	w3=$(tail -n +2 model3/set$s/tst-stat.csv | grep 2007,1,1, | cut -d, -f4)
	if [[ ! -s model3/set$s/$w3/pdbbind-2007-trn-1.rf ]]; then
		rf-train model3/set$s/pdbbind-2007-trn-1-yxi.csv model3/set$s/$w3/pdbbind-2007-trn-1.rf $w3
	fi
	w4=$(tail -n +2 model4/set$s/tst-stat.csv | grep 2007,1,1, | cut -d, -f4)
	if [[ ! -s model4/set$s/$w4/pdbbind-2007-trn-1.rf ]]; then
		rf-train model4/set$s/pdbbind-2007-trn-1-yxi.csv model4/set$s/$w4/pdbbind-2007-trn-1.rf $w4
	fi
	si=$((s-1))
	pv=$pdbbind/v${v[si]}
	rmsd1s=(0 0 0 0 0 0)
	rmsdms=(0 0 0 0 0 0)
	rmsdis1=(0 0 0 0 0 0 0 0 0)
	rmsdis4=(0 0 0 0 0 0 0 0 0)
	k=0
	for iy in $(< $pv/rescoring-2-set-$s-tst-iy.csv); do
		c=${iy:0:4}
		k=$((k+1))
		pvc=$pv/$c
		rmsdf=vina.rmsd
		rmsd1=$(head -1 $pvc/$rmsdf)
		rmsdm=$(sort -n $pvc/$rmsdf | head -1)
		for i in {0..5}; do
			if [[ $(bc <<< "$rmsd1 < ${rmsdts[i]}") == 1 ]]; then
				rmsd1s[i]=$((rmsd1s[i]+1))
			fi
			if [[ $(bc <<< "$rmsdm < ${rmsdts[i]}") == 1 ]]; then
				rmsdms[i]=$((rmsdms[i]+1))
			fi
		done
		s3=$(< $pvc/vina-scheme-3.txt)
		n=$(wc -l < $pvc/$rmsdf)
		w=$(grep "WARNING" $pvc/log/${c}_ligand.txt | wc -l)
		tail -n +$((26+w)) $pvc/log/${c}_ligand.txt | head -$n | awk '{print substr($0,13,5) * -0.73349480509}' > /tmp/p1.csv
		rf-extract $pvc/${c}_protein.pdbqt $pvc/out/${c}_ligand_ligand_1.pdbqt > /tmp/x4.csv # Extract features and predict binding affinity values for model 4. Update src/rf-extract and src/feature.hpp before changing the model from 4 to 3 or 2.
		for i in $(seq 2 $n); do
			rf-extract $pvc/${c}_protein.pdbqt $pvc/out/${c}_ligand_ligand_${i}.pdbqt | tail -n +2 >> /tmp/x4.csv
		done
		tail -n +2 /tmp/x4.csv | rf-predict model4/set$s/$w4/pdbbind-2007-trn-1.rf > /tmp/p4.csv
#		tail -n +2 /tmp/x3.csv | rf-predict model3/set$s/$w3/pdbbind-2007-trn-1.rf > /tmp/p3.csv
#		cat /tmp/x4.csv | ./mlrtestp.R model2/set$s/$w2/pdbbind-2007-trn-1-coef.csv $w2 > /tmp/p4.csv
		i=0
		for r in $(paste $pdbbind/seq$n /tmp/p1.csv | sort -k2,2nr | cut -f1); do
			if [[ $s3 == $r ]]; then
				rmsdis1[i]=$((rmsdis1[i]+1))
			fi
			i=$((i+1))
		done
		i=0
		for r in $(paste $pdbbind/seq$n /tmp/p4.csv | sort -k2,2nr | cut -f1); do
			if [[ $s3 == $r ]]; then
				rmsdis4[i]=$((rmsdis4[i]+1))
			fi
			i=$((i+1))
		done
	done
	echo "condition,#,%"
	for i in {0..8}; do
		echo "RMSD$[i+1]=RMSDm",${rmsdis1[i]},$(printf "%.0f\n" $(bc -l <<< "${rmsdis1[i]} * 100 / $k"))%
	done
	for i in {0..5}; do
		echo RMSD1"<"${rmsdts[i]},${rmsd1s[i]},$(printf "%.0f\n" $(bc -l <<< "${rmsd1s[i]} * 100 / $k"))%
	done
	for i in {0..5}; do
		echo RMSDm"<"${rmsdts[i]},${rmsdms[i]},$(printf "%.0f\n" $(bc -l <<< "${rmsdms[i]} * 100 / $k"))%
	done
	for i in {0..8}; do
		echo "RMSD$[i+1]=RMSDm",${rmsdis4[i]},$(printf "%.0f\n" $(bc -l <<< "${rmsdis4[i]} * 100 / $k"))%
	done
done
