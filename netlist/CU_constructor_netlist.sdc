###################################################################

# Created by write_sdc on Tue Jun 21 14:48:32 2022

###################################################################
set sdc_version 1.9

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current mA
set_load -pin_load 3.40189 [get_ports RST]
set_load -pin_load 3.40189 [get_ports RSH_LE]
set_load -pin_load 3.40189 [get_ports cmd_SH_EN]
set_load -pin_load 3.40189 [get_ports READY]
set_load -pin_load 3.40189 [get_ports DONE]
set_load -pin_load 3.40189 [get_ports CE_compEN]
set_load -pin_load 3.40189 [get_ports CE_STOPcompEN]
set_load -pin_load 3.40189 [get_ports compEN]
set_load -pin_load 3.40189 [get_ports {PS_out[2]}]
set_load -pin_load 3.40189 [get_ports {PS_out[1]}]
set_load -pin_load 3.40189 [get_ports {PS_out[0]}]
set_load -pin_load 3.40189 [get_ports {NS_out[2]}]
set_load -pin_load 3.40189 [get_ports {NS_out[1]}]
set_load -pin_load 3.40189 [get_ports {NS_out[0]}]
create_clock [get_ports clk]  -name MY_CLK  -period 3.01  -waveform {0 1.505}
set_clock_uncertainty 0.07  [get_clocks MY_CLK]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports clk]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports START]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports GOT]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports CNT_compEN_OUT]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports CNT_STOPcompEN_OUT]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports CU_RST]
set_output_delay -clock MY_CLK  -max 0.5  [get_ports RST]
set_output_delay -clock MY_CLK  -max 0.5  [get_ports RSH_LE]
set_output_delay -clock MY_CLK  -max 0.5  [get_ports cmd_SH_EN]
set_output_delay -clock MY_CLK  -max 0.5  [get_ports READY]
set_output_delay -clock MY_CLK  -max 0.5  [get_ports DONE]
set_output_delay -clock MY_CLK  -max 0.5  [get_ports CE_compEN]
set_output_delay -clock MY_CLK  -max 0.5  [get_ports CE_STOPcompEN]
set_output_delay -clock MY_CLK  -max 0.5  [get_ports compEN]
set_output_delay -clock MY_CLK  -max 0.5  [get_ports {PS_out[2]}]
set_output_delay -clock MY_CLK  -max 0.5  [get_ports {PS_out[1]}]
set_output_delay -clock MY_CLK  -max 0.5  [get_ports {PS_out[0]}]
set_output_delay -clock MY_CLK  -max 0.5  [get_ports {NS_out[2]}]
set_output_delay -clock MY_CLK  -max 0.5  [get_ports {NS_out[1]}]
set_output_delay -clock MY_CLK  -max 0.5  [get_ports {NS_out[0]}]
