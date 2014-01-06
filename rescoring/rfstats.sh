echo seed,rmse,sdev,pcor,scor,kcor > pdbbind2007-core-statistics.csv
cp pdbbind2007-core-statistics.csv pdbbind2007-refined-core-statistics.csv
for s in $(cat ../seed.csv); do
	echo $s
	echo -n $s, >> pdbbind2007-core-statistics.csv
	echo -n $s, >> pdbbind2007-refined-core-statistics.csv
	tail -n +2 $s/rf-test-core.txt | cut -d' ' -f2 | tr '\n' ',' | sed 's/,$/\n/g' >> pdbbind2007-core-statistics.csv
	tail -n +2 $s/rf-test-refined-core.txt | cut -d' ' -f2 | tr '\n' ',' | sed 's/,$/\n/g' >> pdbbind2007-refined-core-statistics.csv
done
