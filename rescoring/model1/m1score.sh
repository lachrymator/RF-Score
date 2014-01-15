tail -n +2 pdbbind-2007-tst-iyp.csv | cut -d',' -f2,3 | rf-stat > pdbbind-2007-tst-stat.csv
tail -n +2 pdbbind-2007-trn-iyp.csv | cut -d',' -f2,3 | rf-stat > pdbbind-2007-trn-stat.csv
