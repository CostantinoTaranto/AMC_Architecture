onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary -radixshowbase 0 /tb_ls_rs_b2/SH_in_t
add wave -noupdate -radix binary -radixshowbase 0 /tb_ls_rs_b2/SH_cmd_t
add wave -noupdate -radix binary -radixshowbase 0 /tb_ls_rs_b2/SH_out_t
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {767 ns} 0}
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
WaveRestoreZoom {0 ns} {23 ns}
