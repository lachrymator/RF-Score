for s in $(cat ../seed.csv); do
	echo $s
	cd $s
	../../plot.R
	tail -n +6 pdbbind2007-refined-core.txt | ~/idock/utilities/substr 3 8 | ../../varImpPlot.R
	cd ..
done
