for s in $(cat ../seed.csv); do
	echo $s
	cd $s
	tail -n +6 rf-train-refined-core.txt | ~/idock/utilities/substr 3 8 | ../../varImpPlot.R
	cd ..
done
