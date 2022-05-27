onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_constructor/clk
add wave -noupdate -radix decimal -childformat {{/tb_constructor/MV0_t(0) -radix decimal} {/tb_constructor/MV0_t(1) -radix decimal}} -subitemconfig {/tb_constructor/MV0_t(0) {-height 16 -radix decimal} /tb_constructor/MV0_t(1) {-height 16 -radix decimal}} /tb_constructor/MV0_t
add wave -noupdate -radix decimal -childformat {{/tb_constructor/MV1_t(0) -radix decimal} {/tb_constructor/MV1_t(1) -radix decimal}} -subitemconfig {/tb_constructor/MV1_t(0) {-height 16 -radix decimal} /tb_constructor/MV1_t(1) {-height 16 -radix decimal}} /tb_constructor/MV1_t
add wave -noupdate -radix decimal -childformat {{/tb_constructor/MV2_t(0) -radix decimal} {/tb_constructor/MV2_t(1) -radix decimal}} -subitemconfig {/tb_constructor/MV2_t(0) {-height 16 -radix decimal} /tb_constructor/MV2_t(1) {-height 16 -radix decimal}} /tb_constructor/MV2_t
add wave -noupdate -radix unsigned /tb_constructor/CU_h_t
add wave -noupdate -radix unsigned /tb_constructor/CU_w_t
add wave -noupdate /tb_constructor/START_t
add wave -noupdate /tb_constructor/GOT_t
add wave -noupdate /tb_constructor/CU_RST_t
add wave -noupdate -radix decimal /tb_constructor/MVP0_t
add wave -noupdate -radix decimal /tb_constructor/MVP1_t
add wave -noupdate -radix decimal /tb_constructor/MVP2_t
add wave -noupdate /tb_constructor/uut/Control_Unit/PS
add wave -noupdate /tb_constructor/uut/Control_Unit/NS
add wave -noupdate -radix decimal /tb_constructor/uut/Datapath/L_sub1/subtraction
add wave -noupdate -radix decimal /tb_constructor/uut/Datapath/R_sub1/subtraction
add wave -noupdate /tb_constructor/uut/Datapath/hOw/h
add wave -noupdate /tb_constructor/uut/Datapath/hOw/w
add wave -noupdate /tb_constructor/uut/Datapath/hOw/cmd_RSH_out
add wave -noupdate /tb_constructor/uut/Datapath/hOw/cmd
add wave -noupdate /tb_constructor/uut/Datapath/hOw/RSH_in
add wave -noupdate /tb_constructor/uut/RSH_LE_int
add wave -noupdate /tb_constructor/uut/cmd_SH_EN_int
add wave -noupdate /tb_constructor/uut/Datapath/hOw/shift_amt
add wave -noupdate /tb_constructor/uut/Datapath/hOw/shift_dir_int
add wave -noupdate /tb_constructor/uut/Datapath/hOw/SH_cmd
add wave -noupdate -radix decimal /tb_constructor/uut/Datapath/L_LR_SH2/diff_mult
add wave -noupdate -radix decimal /tb_constructor/uut/Datapath/R_LR_SH2/diff_mult
add wave -noupdate -radix decimal /tb_constructor/uut/Datapath/L_sub2/subtraction
add wave -noupdate -radix decimal /tb_constructor/uut/Datapath/L_subD/subtraction
add wave -noupdate -radix decimal /tb_constructor/uut/Datapath/R_subD/subtraction
add wave -noupdate -radix decimal /tb_constructor/uut/Datapath/L_squarer/product
add wave -noupdate -radix decimal /tb_constructor/uut/Datapath/R_squarer/product
add wave -noupdate -radix decimal /tb_constructor/uut/Datapath/D_adder/op1
add wave -noupdate -radix decimal /tb_constructor/uut/Datapath/D_adder/op2
add wave -noupdate -radix decimal /tb_constructor/uut/Datapath/D_adder/sum
add wave -noupdate -radix decimal /tb_constructor/uut/Datapath/D_Cur
add wave -noupdate /tb_constructor/uut/Datapath/compEN
add wave -noupdate /tb_constructor/uut/Datapath/LE3
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {67 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 334
configure wave -valuecolwidth 148
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {47 ns} {75 ns}
