#open the vcd (value-change-dump) file
vcd file ../vcd/AME_Architecture_syn.vcd
#specify we want to monitor all the files
vcd add /tb_AME_Architecture/uut/*
#run the simulation
run 1100 ns
