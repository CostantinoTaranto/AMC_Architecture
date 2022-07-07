#read the verilog netlist
read_verilog -netlist ../netlist/constructor.v
#read the saif file containing the switching activity information
read_saif -input ../saif/constructor_netlist.saif -instance tb_constructor_netlist/uut -unit ns -scale 1
#inform Design Complier that there is a clk signal
create_clock -name MY_CLK clk
#perform power estimation
report_power
