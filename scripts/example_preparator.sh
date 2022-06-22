#!/bin/bash
#This script takes as input argument a single example number and prepares the simulation files
#(memory, inputs, outputs...) for that example

#acquire the example number
if [ $# -ne 1 ]
then
	echo "Usage: $0 example_number"
	exit
fi
exampleNum=$1

#Prepare files for the example
#text files
filesToBeRenamed=("constructor_out/constructor_out" "extimator_out/extimator_out" "memory_data/Curframe" "memory_data/Refframe" "VTM_inputs/VTM_inputs")
for curfileToBeRenamed in ${filesToBeRenamed[@]} ; do
	curFileName=$curfileToBeRenamed"_ex"$exampleNum".txt"
	if [ -f "../tb/$curFileName" ] ; then
		cp "../tb/$curFileName" "../tb/$curfileToBeRenamed.txt"
	else
		touch "../tb/$curfileToBeRenamed.txt"
	fi
done
#vhd files
filesToBeRenamed=("memory/DATA_MEMORY")
for curfileToBeRenamed in ${filesToBeRenamed[@]} ; do
	curFileName=$curfileToBeRenamed"_ex"$exampleNum".vhd"
	if [ -f "../tb/$curFileName" ] ; then
		cp "../tb/$curFileName" "../tb/$curfileToBeRenamed.vhd"
	else
		touch "../tb/$curfileToBeRenamed.txt" #I leave it as txt so that compiler will generate an error.
		#This is made on purpose beacuse if the memory file is not present there actually IS a problem
		#and the compiler needs to be stopped
	fi
done

