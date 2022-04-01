onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal -childformat {{/tb_constructor/MV0_t(0) -radix decimal} {/tb_constructor/MV0_t(1) -radix decimal}} -subitemconfig {/tb_constructor/MV0_t(0) {-height 16 -radix decimal} /tb_constructor/MV0_t(1) {-height 16 -radix decimal}} /tb_constructor/MV0_t
add wave -noupdate -radix decimal /tb_constructor/MV1_t
add wave -noupdate -radix decimal /tb_constructor/MV2_t
add wave -noupdate -radix decimal /tb_constructor/CU_h_t
add wave -noupdate -radix decimal /tb_constructor/CU_w_t
add wave -noupdate -radix decimal /tb_constructor/uut/D_adder/sum
add wave -noupdate -radix decimal -childformat {{/tb_constructor/uut/L_sub1/subtraction(11) -radix decimal} {/tb_constructor/uut/L_sub1/subtraction(10) -radix decimal} {/tb_constructor/uut/L_sub1/subtraction(9) -radix decimal} {/tb_constructor/uut/L_sub1/subtraction(8) -radix decimal} {/tb_constructor/uut/L_sub1/subtraction(7) -radix decimal} {/tb_constructor/uut/L_sub1/subtraction(6) -radix decimal} {/tb_constructor/uut/L_sub1/subtraction(5) -radix decimal} {/tb_constructor/uut/L_sub1/subtraction(4) -radix decimal} {/tb_constructor/uut/L_sub1/subtraction(3) -radix decimal} {/tb_constructor/uut/L_sub1/subtraction(2) -radix decimal} {/tb_constructor/uut/L_sub1/subtraction(1) -radix decimal} {/tb_constructor/uut/L_sub1/subtraction(0) -radix decimal}} -subitemconfig {/tb_constructor/uut/L_sub1/subtraction(11) {-height 16 -radix decimal} /tb_constructor/uut/L_sub1/subtraction(10) {-height 16 -radix decimal} /tb_constructor/uut/L_sub1/subtraction(9) {-height 16 -radix decimal} /tb_constructor/uut/L_sub1/subtraction(8) {-height 16 -radix decimal} /tb_constructor/uut/L_sub1/subtraction(7) {-height 16 -radix decimal} /tb_constructor/uut/L_sub1/subtraction(6) {-height 16 -radix decimal} /tb_constructor/uut/L_sub1/subtraction(5) {-height 16 -radix decimal} /tb_constructor/uut/L_sub1/subtraction(4) {-height 16 -radix decimal} /tb_constructor/uut/L_sub1/subtraction(3) {-height 16 -radix decimal} /tb_constructor/uut/L_sub1/subtraction(2) {-height 16 -radix decimal} /tb_constructor/uut/L_sub1/subtraction(1) {-height 16 -radix decimal} /tb_constructor/uut/L_sub1/subtraction(0) {-height 16 -radix decimal}} /tb_constructor/uut/L_sub1/subtraction
add wave -noupdate /tb_constructor/uut/hOw/SH_cmd
add wave -noupdate -radix decimal /tb_constructor/uut/L_LRB/SH_out
add wave -noupdate -radix decimal /tb_constructor/uut/L_sub2/subtraction
add wave -noupdate -radix decimal /tb_constructor/uut/L_subD/subtraction
add wave -noupdate -radix decimal /tb_constructor/uut/L_squarer/product
add wave -noupdate -radix decimal /tb_constructor/uut/D_adder/op1
add wave -noupdate -radix decimal /tb_constructor/uut/D_adder/op2
add wave -noupdate -radix decimal /tb_constructor/uut/D_adder/sum
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8 ns} 0}
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
WaveRestoreZoom {0 ns} {19 ns}
