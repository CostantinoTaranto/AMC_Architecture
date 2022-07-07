#!/bin/bash
#This scripts takes as input argument a text file containing what to compile and/or
#simulate and runs questasim if a testbench is provided. The compilation results
#are stored in a log file whose name is specified by the input text file.

#Check if the filename is present, store its name and open it
if [ $# -ne 2 ]
then
	echo "Usage: $0 filename test_netlist"
	exit
fi
Filename=$1
exec 3< ./modelsim_ex/$Filename

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
			read TB_NAME <&3
			if [ "$2" == "0" ] ; then
				echo "Logic simulation"
				eval "vsim work.$TB_NAME"
			else
				read LINE <&3
				read LINE <&3
				echo "Neltlist simulation"
				eval "vsim -L /software/dk/nangate45/verilog/msim6.2g -sdftyp /tb_extimator_netlist_expanded/uut/extimator_netlist=../netlist/extimator_expanded.sdf work.$TB_NAME"
			fi
		fi
	else
		echo "Compilation completed succesfully. No Testbench has been provided."
	fi		
fi
