#!/usr/bin/env bash
tsts=$(echo 195 201 382)
trns=$(echo 247 1105 2280 792 1300 2059 2897)
for tst in 195 201 382; do
	for trn in 247 1105 2280 792 1300 2059 2897; do
		for x in 2 4 10 40 46 42; do
			echo -n "$tst & $trn & $x"
			for m in mlr rf; do
				echo -n " & "$(tail -1 x$x/$m/trn-$trn-tst-$tst-stat.csv | cut -d, -f2-5 --output-delimiter=" & ")
			done
			echo \\\\
		done
	done
done
