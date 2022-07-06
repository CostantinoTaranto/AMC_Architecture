#!/bin/bash
cd /home/thesis/costantino.taranto/git/AME_Architecture/syn
#Refresh the work directory
if [ -d "work" ] ; then
	rm -r work
fi
mkdir work
#Create the analysis results directory
if [ ! -d "synopsys_results" ] ; then
	mkdir synopsys_results
fi
#copy the setup file
cp ./synopsys_setup_file/.synopsys_dc.setup ./.synopsys_dc.setup
#run initialization script
source /eda/scripts/init_design_vision
#run synopsys in shell mode and execute the command file
dc_shell -f synopsys_commands_custom.tcl




