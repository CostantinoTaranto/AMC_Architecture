#open the vcd (value-change-dump) file
vcd file ../vcd/AME_Architecture_syn.vcd
#specify we want to monitor all the files
vcd add /tb_AME_Architecture_netlist/uut/*
#load the macro file for the wave
do /home/thesis/costantino.taranto/git/AME_Architecture/sim/wave_form/tb_AME_Architecture_netlist_wave.do
#run the simulation
run 5 us
