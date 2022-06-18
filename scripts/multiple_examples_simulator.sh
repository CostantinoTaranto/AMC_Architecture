#!/bin/bash
firstExample=3
lastExample=5
for exampleNum in $(seq $firstExample $lastExample) ; do
	#open the compilation command file
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
	#text files
	filesToBeRenamed=("constructor_out/constructor_out" "extimator_out/extimator_out" "memory_data/Curframe" "memory_data/Refframe")
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
	#close the compilation command file
	exec 3>&-
	#store the results filename with the correct name
	mv "../tb/results/results.txt" "../tb/results/results_ex$exampleNum.txt"
done
