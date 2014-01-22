for s in 1 2; do
	echo set$s
	ls -1 model2/set${s}/pdbbind-*-trn-yxi.csv | ~/idock/utilities/substr 20 4 | ./mtrn.R $s
	mkdir -p mtrn/set$s
	mv *.tiff mtrn/set$s
done
