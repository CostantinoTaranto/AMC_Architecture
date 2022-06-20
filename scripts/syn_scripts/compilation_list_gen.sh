#!/bin/bash
#This script generates a txt file containing all the vhdl files to be compilated by synopsys

rm syn_toCompile.txt
touch syn_toCompile.txt

for curfile in /home/thesis/costantino.taranto/git/AME_Architecture/src/generic/* ; do
	echo "analyze -f vhdl -lib WORK $curfile" >> syn_toCompile.txt
done
for curfile in /home/thesis/costantino.taranto/git/AME_Architecture/src/constructor/* ; do
	echo "analyze -f vhdl -lib WORK $curfile" >> syn_toCompile.txt
done
for curfile in /home/thesis/costantino.taranto/git/AME_Architecture/src/extimator/* ; do
	echo "analyze -f vhdl -lib WORK $curfile" >> syn_toCompile.txt
done
for curfile in /home/thesis/costantino.taranto/git/AME_Architecture/src/AME_Architecture/* ; do
	echo "analyze -f vhdl -lib WORK $curfile" >> syn_toCompile.txt
done

echo "syn_toCompile.txt generated"
