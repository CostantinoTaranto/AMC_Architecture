#!/bin/bash
SimPath="/home/thesis/costantino.taranto/git/AME_Architecture/sim"
cd $SimPath
source /eda/scripts/init_questa
if [ -d "work" ]
then
	rm -r work
fi
vlib work
vcom -93 -work ./work ../src/generic/LS_B2.vhd > com_log.txt
vcom -93 -work ./work ../src/generic/RS_B2.vhd >> com_log.txt
vcom -93 -work ./work ../src/generic/sign_extender.vhd >> com_log.txt
vcom -93 -work ./work ../src/constructor/LS_RS_B2.vhd >> com_log.txt

#compile the tb
vcom -93 -work ./work ../tb/tb_LS_RS_B2.vhd >> com_log.txt

#launch the simulation
if grep -Fq "Error:" $SimPath/com_log.txt
then
	echo "Compliation error. See \"/sim/com_log.txt\" file for more."
else 
	vsim work.tb_LS_RS_B2
fi
