for s in 1 2; do
	echo set$s
	for v in $(ls -1 model2/set${s}/pdbbind-*-trn-yxi.csv | ~/idock/utilities/substr 20 4); do
		echo $v
		./xmdl.R $s $v
	done
	mkdir -p xmdl/set$s
	mv *.tiff xmdl/set$s
done
