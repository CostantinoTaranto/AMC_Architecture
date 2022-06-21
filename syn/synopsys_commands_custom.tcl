#*******Reading VHDL source files**************
#-------ANALYSIS PHASE
#compile all files provided by the script "compilation_list_gen.sh"
uplevel #0 source /home/thesis/costantino.taranto/git/AME_Architecture/scripts/syn_scripts/syn_toCompile.txt > ./synopsys_results/analyze_out.log
#Set one parameter to preserve rtl names in the netlist to ease the procedure for power consumption estimation.
set power_preserve_rtl_hier_names true

#-------ELABORATION PHASE
#Launch elaborate command to load the components
#elaborate <top entity name> -arch <architecture name> -lib WORK > log_fileName
elaborate CU_constructor_netlist -arch beh -lib WORK > ./synopsys_results/elaborate_out.log
#uniquify #optional command to addres to only 1 specific architecture
link

#*******  Applying constraints   ***************
#create clock (period in ns)
create_clock -name MY_CLK -period 3.01 clk
#since the clock is a “special” signal in the design, we set the "don't touch" property  
set_dont_touch_network MY_CLK

#jitter simulation
set_clock_uncertainty 0.07 [get_clocks MY_CLK]

#input/output delay
set_input_delay 0.5 -max -clock MY_CLK [remove_from_collection [all_inputs] CLK]
set_output_delay 0.5 -max -clock MY_CLK [all_outputs]

#set output load (buffer x4 used)
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]

#*********    Start the syntesis    *************
compile >  ./synopsys_results/compilation_results.txt

#*********    Save the results      *************
report_timing  >  ./synopsys_results/timing_results.txt
report_area    >  ./synopsys_results/area_results.txt

#Finally, we can save the data required to complete the design and to perform switchingactivity-based power estimation. 
#First, we ungroup the cells to flatten the hierarchy as follows:
ungroup -all -flatten
#Then, we have to export the netlist in verilog. So that we impose verilog rules for the names of the internal signals. This is obtained with
change_names -hierarchy -rules verilog
#We also save a file describing the delay of the netlist:
write_sdf ../netlist/CU_constructor_netlist.sdf
#We can now save the netlist in verilog:
write -f verilog -hierarchy -output ../netlist/CU_constructor_netlist.v
#and the constraints to the input and output ports in a standard format:
write_sdc ../netlist/CU_constructor_netlist.sdc

#******* close Design compiler    ****************
quit



