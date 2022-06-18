#!/bin/bash
#acquire the example number
if [ $# -ne 1 ]
then
	echo "Usage: $0 example_number"
	exit
fi
exampleNum=$1

#oper the compilation command file
exec 3< ./modelsim_ex/tb_AME_Architecture.txt

#Search and store the Log filename
while read LINE <&3 ; do
	if [ "$LINE" == "--LOG_FILENAME" ] ; then
		read LINE <&3
		break
	fi
done
LogFilename=$LINE

#Move in the simulation folder and delete the old log
SimPath="/home/thesis/costantino.taranto/git/AME_Architecture/sim"
cd $SimPath
if [ -f "$LogFilename" ] ; then
	rm "$LogFilename"
fi
#Prepare the simulation tool
source /eda/scripts/init_questa
if [ -d "work" ]
then
	rm -r work
fi
vlib work

#Prepare files for the example
filesToBeRenamed=("constructor_out/constructor_out" "extimator_out/extimator_out" "memory/DATA_MEMORY" "memory_data/Curframe" "memory_data/Refframe")
for curfileToBeRenamed in ${filesToBeRenamed[@]} ; do
	curFileName=$curfileToBeRenamed"_ex"$exampleNum".txt"
	if [ -f "../tb/$curFileName" ] ; then
		cp "../tb/$curFileName" "../tb/$curfileToBeRenamed.txt"
	else
		touch "../tb/$curfileToBeRenamed.txt"
	fi
done

#Compile the source files
while read LINE <&3 ; do
	if [ "$LINE" == "--SOURCE" ] ; then
		break
	fi
done

while read LINE <&3 ; do
	if [ "$LINE" == "--TESTBENCH" ] ; then
		read LINE <&3
		#Note that there is a testbench
		isTb=1
		eval "$LINE>>$LogFilename"
		break
	else
		eval "$LINE>>$LogFilename"
	fi
done
	
#launch the simulation
if grep -Fq "** Error" $SimPath/$LogFilename
then
	echo "Compliation error. See \"/sim/$LogFilename\" file for more."
else 
	if [[ $isTb -eq 1 ]] ; then
		read LINE <&3
		if [ "$LINE" != "--TB_NAME" ] ; then
			echo "Please provide a Testbench unit name."
		else
			read LINE <&3
			eval "vsim -do ../sim/batch_simulate.cmd work.$LINE"
		fi
	else
		echo "Compilation completed succesfully. No Testbench has been provided."
	fi		
fi
