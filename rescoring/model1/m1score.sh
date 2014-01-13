tail -n +2 pdbbind-2007-core-iyp.csv | cut -d',' -f2,3 | rf-stat > pdbbind-2007-core-statistics.csv
tail -n +2 pdbbind-2007-refined-core-iyp.csv | cut -d',' -f2,3 | rf-stat > pdbbind-2007-refined-core-statistics.csv
