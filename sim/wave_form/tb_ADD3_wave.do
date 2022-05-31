onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_add3/clk
add wave -noupdate -radix decimal /tb_add3/op1_t
add wave -noupdate -radix decimal /tb_add3/op2_t
add wave -noupdate -radix decimal /tb_add3/op3_t
add wave -noupdate /tb_add3/VALID_t
add wave -noupdate /tb_add3/RST_t
add wave -noupdate -radix decimal /tb_add3/sum_t
add wave -noupdate -radix decimal /tb_add3/uut/add1_int
add wave -noupdate -radix decimal /tb_add3/uut/add2_int
add wave -noupdate -radix decimal /tb_add3/uut/add_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 226
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
WaveRestoreZoom {27 ns} {51 ns}
