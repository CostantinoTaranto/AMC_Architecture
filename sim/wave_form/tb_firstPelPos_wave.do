onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_firstpelpos/clk
add wave -noupdate /tb_firstpelpos/CE_REPx_t
add wave -noupdate /tb_firstpelpos/CE_BLKx_t
add wave -noupdate /tb_firstpelpos/RST_BLKx_t
add wave -noupdate /tb_firstpelpos/RST_t
add wave -noupdate /tb_firstpelpos/CE_REPy_t
add wave -noupdate /tb_firstpelpos/CE_BLKy_t
add wave -noupdate /tb_firstpelpos/RST_BLKy_t
add wave -noupdate /tb_firstpelpos/CU_w_t
add wave -noupdate /tb_firstpelpos/CU_h_t
add wave -noupdate -radix decimal /tb_firstpelpos/x0_t
add wave -noupdate -radix decimal /tb_firstpelpos/y0_t
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {28 ns} 0}
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
WaveRestoreZoom {0 ns} {72 ns}
