onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_extimator/clk
add wave -noupdate /tb_extimator/uut/extimator_CU/PS
add wave -noupdate -radix unsigned /tb_extimator/VALID_VTM_t
add wave -noupdate /tb_extimator/VALID_CONST_t
add wave -noupdate /tb_extimator/MV0_in_t
add wave -noupdate /tb_extimator/MV1_in_t
add wave -noupdate /tb_extimator/MV2_in_t
add wave -noupdate /tb_extimator/CurCU_h_t
add wave -noupdate /tb_extimator/CurCU_w_t
add wave -noupdate /tb_extimator/sixPar_t
add wave -noupdate /tb_extimator/CU_RST_t
add wave -noupdate /tb_extimator/RefPel_int
add wave -noupdate /tb_extimator/CurPel_int
add wave -noupdate -radix decimal /tb_extimator/RADDR_RefCu_x_t
add wave -noupdate -radix decimal /tb_extimator/RADDR_RefCu_y_t
add wave -noupdate -radix unsigned /tb_extimator/RADDR_CurCu_x_t
add wave -noupdate -radix unsigned /tb_extimator/RADDR_CurCu_y_t
add wave -noupdate /tb_extimator/MEM_RE_int
add wave -noupdate /tb_extimator/extimator_READY_t
add wave -noupdate -radix unsigned -childformat {{/tb_extimator/uut_mem/Curframe_OUT(3) -radix unsigned} {/tb_extimator/uut_mem/Curframe_OUT(2) -radix unsigned} {/tb_extimator/uut_mem/Curframe_OUT(1) -radix unsigned} {/tb_extimator/uut_mem/Curframe_OUT(0) -radix unsigned}} -expand -subitemconfig {/tb_extimator/uut_mem/Curframe_OUT(3) {-height 15 -radix unsigned} /tb_extimator/uut_mem/Curframe_OUT(2) {-height 15 -radix unsigned} /tb_extimator/uut_mem/Curframe_OUT(1) {-height 15 -radix unsigned} /tb_extimator/uut_mem/Curframe_OUT(0) {-height 15 -radix unsigned}} /tb_extimator/uut_mem/Curframe_OUT
add wave -noupdate -radix unsigned -childformat {{/tb_extimator/uut_mem/Refframe_OUT(3) -radix unsigned} {/tb_extimator/uut_mem/Refframe_OUT(2) -radix unsigned} {/tb_extimator/uut_mem/Refframe_OUT(1) -radix unsigned} {/tb_extimator/uut_mem/Refframe_OUT(0) -radix unsigned}} -expand -subitemconfig {/tb_extimator/uut_mem/Refframe_OUT(3) {-height 15 -radix unsigned} /tb_extimator/uut_mem/Refframe_OUT(2) {-height 15 -radix unsigned} /tb_extimator/uut_mem/Refframe_OUT(1) {-height 15 -radix unsigned} /tb_extimator/uut_mem/Refframe_OUT(0) {-height 15 -radix unsigned}} /tb_extimator/uut_mem/Refframe_OUT
add wave -noupdate /tb_extimator/uut/Results_calculator/SAD_tmp_RST
add wave -noupdate -radix decimal /tb_extimator/uut/Results_calculator/SAD_tmp
add wave -noupdate -radix decimal /tb_extimator/uut/Results_calculator/CurRowSAD
add wave -noupdate -radix decimal /tb_extimator/uut/Results_calculator/CurSAD
add wave -noupdate /tb_extimator/uut/Results_calculator/last_cand
add wave -noupdate -radix decimal /tb_extimator/uut/Results_calculator/SAD_min
add wave -noupdate -radix decimal /tb_extimator/MV0_out_t
add wave -noupdate -radix decimal /tb_extimator/MV1_out_t
add wave -noupdate -radix decimal /tb_extimator/MV2_out_t
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {39 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {29 ns} {66 ns}
