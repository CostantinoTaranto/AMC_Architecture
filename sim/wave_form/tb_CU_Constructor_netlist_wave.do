onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_cu_constructor_netlist/START_t
add wave -noupdate /tb_cu_constructor_netlist/GOT_t
add wave -noupdate /tb_cu_constructor_netlist/CNT_compEN_OUT_t
add wave -noupdate /tb_cu_constructor_netlist/CNT_STOPcompEN_OUT_t
add wave -noupdate /tb_cu_constructor_netlist/CU_RST_t
add wave -noupdate /tb_cu_constructor_netlist/RST_out
add wave -noupdate /tb_cu_constructor_netlist/RSH_LE_out
add wave -noupdate /tb_cu_constructor_netlist/cmd_SH_EN_out
add wave -noupdate /tb_cu_constructor_netlist/READY_out
add wave -noupdate /tb_cu_constructor_netlist/DONE_out
add wave -noupdate /tb_cu_constructor_netlist/CE_compEN_out
add wave -noupdate /tb_cu_constructor_netlist/CE_STOPcompEN_out
add wave -noupdate /tb_cu_constructor_netlist/compEN_out
add wave -noupdate /tb_cu_constructor_netlist/PS_out_t
add wave -noupdate /tb_cu_constructor_netlist/NS_out_t
add wave -noupdate /tb_cu_constructor_netlist/clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {103 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 207
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {246 ns}
