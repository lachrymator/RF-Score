for v in 2002 2007 2010 2012 2013; do
	cd v$v
	for c in $(cat rescoring2.csv); do
		echo $v $c
		cd $c
		python2.5 ${MGLTOOLS_ROOT}/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_receptor4.pyo -U waters -r ${c}_protein.pdb
		python2.5 ${MGLTOOLS_ROOT}/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.pyo -U '' -l ${c}_ligand.mol2
		~/PDBbind/definebox/bin/definebox ${c}_ligand.mol2 > box.cfg
		mkdir -p log out
		vina --config box.cfg --receptor ${c}_protein.pdbqt --ligand ${c}_ligand.pdbqt --log log/${c}_ligand.txt --out out/${c}_ligand.pdbqt
		~/idock/utilities/rmsd ${c}_ligand.pdbqt out/${c}_ligand.pdbqt > vina.rmsd
		vina_split --input out/${c}_ligand.pdbqt
#		ln -s ../${c}_ligand.pdbqt out/${c}_ligand_ligand_0.pdbqt
		echo 0 > vina-scheme-1.txt
		echo 1 > vina-scheme-2.txt
		n=$(wc -l < vina.rmsd)
		echo $n > out/conformation_count.txt
		paste ../../seq$n vina.rmsd | sort -n -k2,2 -s | head -1 | cut -f1 > vina-scheme-3.txt
		tail -n +26 log/${c}_ligand.txt | head -$n | awk -v y=$(cat pbindaff.txt) 'function abs(x){return x < 0 ? -x : x} {print abs(substr($0,13,5) * -0.73349480509 - y)}' | paste ../../seq$n - | sort -n -k2,2 -s | head -1 | cut -f1 > vina-scheme-4.txt
		for i in {1..9}; do
			if [[ -f out/${c}_ligand_ligand_${i}.pdbqt ]]; then
				vina --receptor ${c}_protein.pdbqt --ligand out/${c}_ligand_ligand_${i}.pdbqt --score_only > out/${c}_ligand_ligand_${i}.txt
			fi
		done
		cd ..
	done
	cd ..
done
