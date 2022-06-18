onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_ame_architecture/clk
add wave -noupdate -radix decimal -childformat {{/tb_ame_architecture/cMV0_in_t(1) -radix decimal} {/tb_ame_architecture/cMV0_in_t(0) -radix decimal}} -subitemconfig {/tb_ame_architecture/cMV0_in_t(1) {-height 16 -radix decimal} /tb_ame_architecture/cMV0_in_t(0) {-height 16 -radix decimal}} /tb_ame_architecture/cMV0_in_t
add wave -noupdate -radix decimal /tb_ame_architecture/cMV1_in_t
add wave -noupdate -radix decimal /tb_ame_architecture/cMV2_in_t
add wave -noupdate -radix unsigned /tb_ame_architecture/uut/constructing_unit/Datapath/D_Cur
add wave -noupdate -radix unsigned /tb_ame_architecture/uut/constructing_unit/Datapath/D_min
add wave -noupdate /tb_ame_architecture/eMV0_in_t
add wave -noupdate /tb_ame_architecture/eMV1_in_t
add wave -noupdate /tb_ame_architecture/eMV2_in_t
add wave -noupdate -radix unsigned /tb_ame_architecture/CU_h_t
add wave -noupdate -radix unsigned /tb_ame_architecture/CU_w_t
add wave -noupdate /tb_ame_architecture/sixPar_t
add wave -noupdate /tb_ame_architecture/RST_t
add wave -noupdate /tb_ame_architecture/START_t
add wave -noupdate /tb_ame_architecture/VALID_t
add wave -noupdate /tb_ame_architecture/eIN_SEL_t
add wave -noupdate -radix decimal /tb_ame_architecture/uut/constructing_unit/MVP0
add wave -noupdate -radix decimal /tb_ame_architecture/uut/constructing_unit/MVP1
add wave -noupdate -radix decimal /tb_ame_architecture/uut/constructing_unit/MVP2
add wave -noupdate /tb_ame_architecture/RefPel_int
add wave -noupdate /tb_ame_architecture/CurPel_int
add wave -noupdate -radix decimal /tb_ame_architecture/uut/extimating_unit/Pixel_Retrieval_Unit/SUB1_GEN(1)/SUB1_x/minuend
add wave -noupdate -radix decimal /tb_ame_architecture/uut/extimating_unit/Pixel_Retrieval_Unit/SUB1_GEN(1)/SUB1_x/subtrahend
add wave -noupdate -radix decimal /tb_ame_architecture/uut/extimating_unit/Pixel_Retrieval_Unit/SUB1_GEN(1)/SUB1_x/subtraction
add wave -noupdate -radix binary /tb_ame_architecture/uut/extimating_unit/Pixel_Retrieval_Unit/RSH2_GEN(1)/R_SH2_X/SH_in
add wave -noupdate -radix binary /tb_ame_architecture/uut/extimating_unit/Pixel_Retrieval_Unit/RSH2_GEN(1)/R_SH2_X/SH_out
add wave -noupdate -label (a1) -radix decimal /tb_ame_architecture/uut/extimating_unit/Pixel_Retrieval_Unit/MULT1_GEN(1)/MULT1_X/op1
add wave -noupdate -label (a2) -radix decimal /tb_ame_architecture/uut/extimating_unit/Pixel_Retrieval_Unit/MULT1_GEN(0)/MULT1_X/op1
add wave -noupdate -label (b1) -radix decimal /tb_ame_architecture/uut/extimating_unit/Pixel_Retrieval_Unit/MULT1_GEN(3)/MULT1_X/op1
add wave -noupdate -label (b2) -radix decimal /tb_ame_architecture/uut/extimating_unit/Pixel_Retrieval_Unit/MULT1_GEN(2)/MULT1_X/op1
add wave -noupdate -radix decimal /tb_ame_architecture/RADDR_RefCu_x_int
add wave -noupdate -radix decimal /tb_ame_architecture/RADDR_RefCu_y_int
add wave -noupdate -radix unsigned /tb_ame_architecture/RADDR_CurCu_x_int
add wave -noupdate -radix unsigned /tb_ame_architecture/RADDR_CurCu_y_int
add wave -noupdate /tb_ame_architecture/MEM_RE_int
add wave -noupdate /tb_ame_architecture/eREADY_t
add wave -noupdate -radix decimal -childformat {{/tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(17) -radix decimal} {/tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(16) -radix decimal} {/tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(15) -radix decimal} {/tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(14) -radix decimal} {/tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(13) -radix decimal} {/tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(12) -radix decimal} {/tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(11) -radix decimal} {/tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(10) -radix decimal} {/tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(9) -radix decimal} {/tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(8) -radix decimal} {/tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(7) -radix decimal} {/tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(6) -radix decimal} {/tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(5) -radix decimal} {/tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(4) -radix decimal} {/tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(3) -radix decimal} {/tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(2) -radix decimal} {/tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(1) -radix decimal} {/tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(0) -radix decimal}} -subitemconfig {/tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(17) {-height 16 -radix decimal} /tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(16) {-height 16 -radix decimal} /tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(15) {-height 16 -radix decimal} /tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(14) {-height 16 -radix decimal} /tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(13) {-height 16 -radix decimal} /tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(12) {-height 16 -radix decimal} /tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(11) {-height 16 -radix decimal} /tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(10) {-height 16 -radix decimal} /tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(9) {-height 16 -radix decimal} /tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(8) {-height 16 -radix decimal} /tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(7) {-height 16 -radix decimal} /tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(6) {-height 16 -radix decimal} /tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(5) {-height 16 -radix decimal} /tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(4) {-height 16 -radix decimal} /tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(3) {-height 16 -radix decimal} /tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(2) {-height 16 -radix decimal} /tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(1) {-height 16 -radix decimal} /tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD(0) {-height 16 -radix decimal}} /tb_ame_architecture/uut/extimating_unit/Results_calculator/CurSAD
add wave -noupdate -radix decimal /tb_ame_architecture/MV0_out_t
add wave -noupdate -radix decimal /tb_ame_architecture/MV1_out_t
add wave -noupdate -radix decimal /tb_ame_architecture/MV2_out_t
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {63 ns} 0}
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
WaveRestoreZoom {198 ns} {238 ns}
