#read the verilog netlist
read_verilog -netlist ../netlist/extimator_expanded.v
#read the saif file containing the switching activity information
read_saif -input ../saif/extimator_netlist_expanded.saif -instance tb_extimator_netlist_expanded/uut -unit ns -scale 1
#inform Design Complier that there is a clk signal
create_clock -name MY_CLK clk
#perform power estimation
report_power
