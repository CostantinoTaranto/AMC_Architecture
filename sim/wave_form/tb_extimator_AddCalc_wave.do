onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_extimator_addcalc/clk
add wave -noupdate /tb_extimator_addcalc/CU_RST_t
add wave -noupdate /tb_extimator_addcalc/VALID_VTM_t
add wave -noupdate /tb_extimator_addcalc/VALID_CONST_t
add wave -noupdate -radix decimal /tb_extimator_addcalc/MV0_in_t
add wave -noupdate -radix decimal /tb_extimator_addcalc/MV1_in_t
add wave -noupdate /tb_extimator_addcalc/MV2_in_t
add wave -noupdate /tb_extimator_addcalc/uut/Pixel_Retrieval_Unit/input_RF/RST
add wave -noupdate /tb_extimator_addcalc/uut/Pixel_Retrieval_Unit/input_RF/MV0_out
add wave -noupdate /tb_extimator_addcalc/uut/Pixel_Retrieval_Unit/input_RF/MV1_out
add wave -noupdate /tb_extimator_addcalc/uut/Pixel_Retrieval_Unit/input_RF/MV2_out
add wave -noupdate -radix binary /tb_extimator_addcalc/CurCU_h_t
add wave -noupdate -radix binary /tb_extimator_addcalc/CurCU_w_t
add wave -noupdate /tb_extimator_addcalc/sixPar_t
add wave -noupdate -radix unsigned /tb_extimator_addcalc/RADDR_RefCu_x_t
add wave -noupdate -radix unsigned /tb_extimator_addcalc/RADDR_RefCu_y_t
add wave -noupdate -radix unsigned /tb_extimator_addcalc/RADDR_CurCu_x_t
add wave -noupdate -radix unsigned /tb_extimator_addcalc/RADDR_CurCu_y_t
add wave -noupdate /tb_extimator_addcalc/extimator_READY_t
add wave -noupdate /tb_extimator_addcalc/uut/VALID_int
add wave -noupdate /tb_extimator_addcalc/uut/Pixel_Retrieval_Unit/input_RF/RE
add wave -noupdate /tb_extimator_addcalc/uut/Pixel_Retrieval_Unit/input_RF/RF_Addr
add wave -noupdate /tb_extimator_addcalc/uut/Pixel_Retrieval_Unit/input_RF/WE
add wave -noupdate /tb_extimator_addcalc/uut/Pixel_Retrieval_Unit/input_RF/MV0_in
add wave -noupdate /tb_extimator_addcalc/uut/Pixel_Retrieval_Unit/input_RF/MV1_in
add wave -noupdate /tb_extimator_addcalc/uut/Pixel_Retrieval_Unit/input_RF/MV2_in
add wave -noupdate -radix decimal /tb_extimator_addcalc/uut/Pixel_Retrieval_Unit/sub1_pos_in
add wave -noupdate -radix decimal /tb_extimator_addcalc/uut/Pixel_Retrieval_Unit/sub1_neg_in
add wave -noupdate -radix decimal /tb_extimator_addcalc/uut/Pixel_Retrieval_Unit/sub1_out_samp
add wave -noupdate /tb_extimator_addcalc/uut/Pixel_Retrieval_Unit/input_RF/RF_Addr_samp
add wave -noupdate /tb_extimator_addcalc/uut/Pixel_Retrieval_Unit/input_RF/MV0_h
add wave -noupdate /tb_extimator_addcalc/uut/Pixel_Retrieval_Unit/input_RF/MV0_v
add wave -noupdate /tb_extimator_addcalc/uut/Pixel_Retrieval_Unit/input_RF/MV1_h
add wave -noupdate /tb_extimator_addcalc/uut/Pixel_Retrieval_Unit/input_RF/MV1_v
add wave -noupdate -radix decimal -childformat {{/tb_extimator_addcalc/uut/Pixel_Retrieval_Unit/R_SH2_out_samp(3) -radix decimal} {/tb_extimator_addcalc/uut/Pixel_Retrieval_Unit/R_SH2_out_samp(2) -radix decimal} {/tb_extimator_addcalc/uut/Pixel_Retrieval_Unit/R_SH2_out_samp(1) -radix decimal} {/tb_extimator_addcalc/uut/Pixel_Retrieval_Unit/R_SH2_out_samp(0) -radix decimal}} -expand -subitemconfig {/tb_extimator_addcalc/uut/Pixel_Retrieval_Unit/R_SH2_out_samp(3) {-radix decimal} /tb_extimator_addcalc/uut/Pixel_Retrieval_Unit/R_SH2_out_samp(2) {-radix decimal} /tb_extimator_addcalc/uut/Pixel_Retrieval_Unit/R_SH2_out_samp(1) {-radix decimal} /tb_extimator_addcalc/uut/Pixel_Retrieval_Unit/R_SH2_out_samp(0) {-radix decimal}} /tb_extimator_addcalc/uut/Pixel_Retrieval_Unit/R_SH2_out_samp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 200
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
WaveRestoreZoom {0 ns} {23 ns}
