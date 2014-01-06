echo rmse,sdev,pcor,scor,kcor > pdbbind2007-core-statistics.csv
cp pdbbind2007-core-statistics.csv pdbbind2007-refined-core-statistics.csv
tail -n +2 rf-stat-core.txt | cut -d' ' -f2 | tr '\n' ',' | sed 's/,$/\n/g' >> pdbbind2007-core-statistics.csv
tail -n +2 rf-stat-refined-core.txt | cut -d' ' -f2 | tr '\n' ',' | sed 's/,$/\n/g' >> pdbbind2007-refined-core-statistics.csv
