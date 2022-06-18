onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_ame_architecture/clk
add wave -noupdate -radix decimal -childformat {{/tb_ame_architecture/cMV0_in_t(1) -radix decimal} {/tb_ame_architecture/cMV0_in_t(0) -radix decimal}} -subitemconfig {/tb_ame_architecture/cMV0_in_t(1) {-height 16 -radix decimal} /tb_ame_architecture/cMV0_in_t(0) {-height 16 -radix decimal}} /tb_ame_architecture/cMV0_in_t
add wave -noupdate -radix decimal /tb_ame_architecture/cMV1_in_t
add wave -noupdate -radix decimal /tb_ame_architecture/cMV2_in_t
add wave -noupdate -radix decimal /tb_ame_architecture/uut/constructing_unit/Datapath/mv1v_mv0v_int
add wave -noupdate -radix decimal /tb_ame_architecture/uut/constructing_unit/Datapath/mv1h_mv0h_int
add wave -noupdate /tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/shift_dir
add wave -noupdate -expand /tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/shift_amt
add wave -noupdate -radix decimal /tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/MV1_MV0
add wave -noupdate /tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/MV1_MV0_d1R
add wave -noupdate /tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/MV1_MV0_d2R
add wave -noupdate /tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/MV1_MV0_d1L
add wave -noupdate /tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/MV1_MV0_d2L
add wave -noupdate /tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/MV1_MV0_d2R_ext
add wave -noupdate -expand /tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/diff_mult
add wave -noupdate -expand /tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/shift_dir_int
add wave -noupdate -expand /tb_ame_architecture/uut/constructing_unit/Datapath/diff_mult_v_int
add wave -noupdate -expand /tb_ame_architecture/uut/constructing_unit/Datapath/diff_mult_h_int
add wave -noupdate -radix decimal -childformat {{/tb_ame_architecture/uut/constructing_unit/Datapath/MV2p_int_h(1) -radix decimal} {/tb_ame_architecture/uut/constructing_unit/Datapath/MV2p_int_h(0) -radix decimal}} -expand -subitemconfig {/tb_ame_architecture/uut/constructing_unit/Datapath/MV2p_int_h(1) {-height 16 -radix decimal} /tb_ame_architecture/uut/constructing_unit/Datapath/MV2p_int_h(0) {-height 16 -radix decimal}} /tb_ame_architecture/uut/constructing_unit/Datapath/MV2p_int_h
add wave -noupdate -radix decimal -childformat {{/tb_ame_architecture/uut/constructing_unit/Datapath/MV2p_int_v(1) -radix decimal} {/tb_ame_architecture/uut/constructing_unit/Datapath/MV2p_int_v(0) -radix decimal}} -expand -subitemconfig {/tb_ame_architecture/uut/constructing_unit/Datapath/MV2p_int_v(1) {-height 16 -radix decimal} /tb_ame_architecture/uut/constructing_unit/Datapath/MV2p_int_v(0) {-height 16 -radix decimal}} /tb_ame_architecture/uut/constructing_unit/Datapath/MV2p_int_v
add wave -noupdate -radix decimal /tb_ame_architecture/uut/constructing_unit/Datapath/D_h
add wave -noupdate -radix decimal /tb_ame_architecture/uut/constructing_unit/Datapath/D_v
add wave -noupdate -radix unsigned /tb_ame_architecture/uut/constructing_unit/Datapath/D_h_sq
add wave -noupdate -radix unsigned /tb_ame_architecture/uut/constructing_unit/Datapath/D_v_sq
add wave -noupdate /tb_ame_architecture/uut/constructing_unit/Datapath/D_sq
add wave -noupdate /tb_ame_architecture/uut/constructing_unit/Datapath/D_sel
add wave -noupdate /tb_ame_architecture/uut/constructing_unit/compEN_int
add wave -noupdate -radix unsigned /tb_ame_architecture/uut/constructing_unit/Datapath/D_Cur
add wave -noupdate -radix unsigned /tb_ame_architecture/uut/constructing_unit/Datapath/D_min
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
add wave -noupdate -radix decimal -childformat {{/tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/LSH_first/SH_in(11) -radix decimal} {/tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/LSH_first/SH_in(10) -radix decimal} {/tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/LSH_first/SH_in(9) -radix decimal} {/tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/LSH_first/SH_in(8) -radix decimal} {/tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/LSH_first/SH_in(7) -radix decimal} {/tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/LSH_first/SH_in(6) -radix decimal} {/tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/LSH_first/SH_in(5) -radix decimal} {/tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/LSH_first/SH_in(4) -radix decimal} {/tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/LSH_first/SH_in(3) -radix decimal} {/tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/LSH_first/SH_in(2) -radix decimal} {/tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/LSH_first/SH_in(1) -radix decimal} {/tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/LSH_first/SH_in(0) -radix decimal}} -expand -subitemconfig {/tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/LSH_first/SH_in(11) {-radix decimal} /tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/LSH_first/SH_in(10) {-radix decimal} /tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/LSH_first/SH_in(9) {-radix decimal} /tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/LSH_first/SH_in(8) {-radix decimal} /tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/LSH_first/SH_in(7) {-radix decimal} /tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/LSH_first/SH_in(6) {-radix decimal} /tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/LSH_first/SH_in(5) {-radix decimal} /tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/LSH_first/SH_in(4) {-radix decimal} /tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/LSH_first/SH_in(3) {-radix decimal} /tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/LSH_first/SH_in(2) {-radix decimal} /tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/LSH_first/SH_in(1) {-radix decimal} /tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/LSH_first/SH_in(0) {-radix decimal}} /tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/LSH_first/SH_in
add wave -noupdate -expand /tb_ame_architecture/uut/constructing_unit/Datapath/R_LR_SH2/LSH_first/SH_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 310
configure wave -valuecolwidth 100
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
WaveRestoreZoom {6 ns} {31 ns}
