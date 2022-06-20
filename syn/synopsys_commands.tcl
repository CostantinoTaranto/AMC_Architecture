#*******Reading VHDL source files**************
#-------ANALYSIS PHASE
#compile all files provided by the script "compilation_list_gen.sh"
uplevel #0 source /home/thesis/costantino.taranto/git/AME_Architecture/scripts/syn_scripts/syn_toCompile.txt > ./synopsys_results/analyze_out.log
#Set one parameter to preserve rtl names in the netlist to ease the procedure for power consumption estimation.
set power_preserve_rtl_hier_names true

#-------ELABORATION PHASE
#Launch elaborate command to load the components
#elaborate <top entity name> -arch <architecture name> -lib WORK > log_fileName
elaborate AME_Architecture -arch structural -lib WORK > ./synopsys_results/elaborate_out.log
#uniquify #optional command to addres to only 1 specific architecture
link

#*******  Applying constraints   ***************
#create 100 Mhz clock (period in ns)
create_clock -name MY_CLK -period 10.0 clk
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
report_timing  >  ./analysis_results/timing_results.txt
report_area    >  ./analysis_results/area_results.txt

