onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_ame_architecture_netlist/clk
add wave -noupdate -radix decimal /tb_ame_architecture_netlist/cMV0_in_t
add wave -noupdate -radix decimal /tb_ame_architecture_netlist/cMV1_in_t
add wave -noupdate -radix decimal /tb_ame_architecture_netlist/cMV2_in_t
add wave -noupdate -radix decimal /tb_ame_architecture_netlist/eMV0_in_t
add wave -noupdate -radix decimal /tb_ame_architecture_netlist/eMV1_in_t
add wave -noupdate -radix decimal /tb_ame_architecture_netlist/eMV2_in_t
add wave -noupdate -radix unsigned /tb_ame_architecture_netlist/CU_h_t
add wave -noupdate -radix unsigned /tb_ame_architecture_netlist/CU_w_t
add wave -noupdate /tb_ame_architecture_netlist/sixPar_t
add wave -noupdate /tb_ame_architecture_netlist/RST_t
add wave -noupdate /tb_ame_architecture_netlist/START_t
add wave -noupdate /tb_ame_architecture_netlist/cREADY_t
add wave -noupdate /tb_ame_architecture_netlist/VALID_t
add wave -noupdate /tb_ame_architecture_netlist/eIN_SEL_t
add wave -noupdate -radix unsigned /tb_ame_architecture_netlist/RefPel_int
add wave -noupdate -radix unsigned /tb_ame_architecture_netlist/CurPel_int
add wave -noupdate -radix decimal /tb_ame_architecture_netlist/RADDR_RefCu_x_int
add wave -noupdate -radix decimal /tb_ame_architecture_netlist/RADDR_RefCu_y_int
add wave -noupdate -radix unsigned /tb_ame_architecture_netlist/RADDR_CurCu_x_int
add wave -noupdate -radix unsigned /tb_ame_architecture_netlist/RADDR_CurCu_y_int
add wave -noupdate /tb_ame_architecture_netlist/MEM_RE_int
add wave -noupdate /tb_ame_architecture_netlist/eREADY_t
add wave -noupdate -radix decimal /tb_ame_architecture_netlist/MV0_out_t
add wave -noupdate -radix decimal /tb_ame_architecture_netlist/MV1_out_t
add wave -noupdate -radix decimal /tb_ame_architecture_netlist/MV2_out_t
add wave -noupdate /tb_ame_architecture_netlist/candidate_MV0_h
add wave -noupdate /tb_ame_architecture_netlist/candidate_MV0_v
add wave -noupdate /tb_ame_architecture_netlist/candidate_MV1_h
add wave -noupdate /tb_ame_architecture_netlist/candidate_MV1_v
add wave -noupdate /tb_ame_architecture_netlist/candidate_MV2_h
add wave -noupdate /tb_ame_architecture_netlist/candidate_MV2_v
add wave -noupdate /tb_ame_architecture_netlist/eMV0_in_r
add wave -noupdate /tb_ame_architecture_netlist/eMV1_in_r
add wave -noupdate /tb_ame_architecture_netlist/eMV2_in_r
add wave -noupdate /tb_ame_architecture_netlist/eMV0_in_r2
add wave -noupdate /tb_ame_architecture_netlist/eMV1_in_r2
add wave -noupdate /tb_ame_architecture_netlist/eMV2_in_r2
add wave -noupdate /tb_ame_architecture_netlist/cComp_EN_int
add wave -noupdate /tb_ame_architecture_netlist/cDONE_int
add wave -noupdate /tb_ame_architecture_netlist/eDONE_int
add wave -noupdate -radix decimal /tb_ame_architecture_netlist/MVP0_int
add wave -noupdate -radix decimal /tb_ame_architecture_netlist/MVP1_int
add wave -noupdate -radix decimal /tb_ame_architecture_netlist/MVP2_int
add wave -noupdate /tb_ame_architecture_netlist/eComp_EN_int
add wave -noupdate -radix unsigned /tb_ame_architecture_netlist/CurSAD_int
add wave -noupdate /tb_ame_architecture_netlist/D_Cur_int
add wave -noupdate /tb_ame_architecture_netlist/END_SIM
add wave -noupdate /tb_ame_architecture_netlist/constructed_int
add wave -noupdate /tb_ame_architecture_netlist/output_check/cComp_EN
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {50 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 357
configure wave -valuecolwidth 152
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
WaveRestoreZoom {0 ns} {189 ns}
