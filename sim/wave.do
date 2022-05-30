onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_mult1/clk
add wave -noupdate /tb_mult1/VALID_t
add wave -noupdate /tb_mult1/RST_t
add wave -noupdate -radix binary /tb_mult1/op1_t
add wave -noupdate -radix binary /tb_mult1/op2_t
add wave -noupdate -radix binary /tb_mult1/uut/op1_int
add wave -noupdate -radix binary /tb_mult1/uut/op2_int
add wave -noupdate -radix decimal /tb_mult1/uut/mult_int
add wave -noupdate -radix decimal /tb_mult1/uut/product_int
add wave -noupdate -radix decimal /tb_mult1/product_t
add wave -noupdate /tb_mult1/uut/result_LE
add wave -noupdate -radix binary /tb_mult1/uut/count_int
add wave -noupdate -radix binary -childformat {{/tb_mult1/uut/is_signed(1) -radix binary} {/tb_mult1/uut/is_signed(0) -radix binary}} -expand -subitemconfig {/tb_mult1/uut/is_signed(1) {-radix binary} /tb_mult1/uut/is_signed(0) {-radix binary}} /tb_mult1/uut/is_signed
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {19 ns} 0}
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
WaveRestoreZoom {16 ns} {22 ns}
