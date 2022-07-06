#!/bin/bash
#run initialization script
source /eda/scripts/init_design_vision
#command
vcd2saif -input ../vcd/AME_Architecture_netlist_expanded.vcd -output ../saif/AME_Architecture_netlist_expanded.saif
