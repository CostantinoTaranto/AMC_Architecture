#!/bin/bash
#Check if the filename is present, store its name and open it
if [ $# -ne 1 ]
then
	echo "Usage: $0 filename"
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

#Prepare the simulator
SimPath="/home/thesis/costantino.taranto/git/AME_Architecture/sim"
cd $SimPath
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
if grep -Fq "Error:" $SimPath/$LogFilename
then
	echo "Compliation error. See \"/sim/$LogFilename\" file for more."
else 
	if [[ $isTb -eq 1 ]] ; then
		read LINE <&3
		if [ "$LINE" != "--TB_NAME" ] ; then
			echo "Please provide a Testbench unit name."
		else
			read LINE <&3
			eval "vsim work.$LINE"
		fi
	else
		echo "Compilation completed succesfully. No Testbench has been provided."
	fi		
fi
