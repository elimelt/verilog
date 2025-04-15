onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /task1_tb/dut/Address
add wave -noupdate /task1_tb/dut/DataIn
add wave -noupdate /task1_tb/dut/Write
add wave -noupdate /task1_tb/dut/clk
add wave -noupdate /task1_tb/dut/DataOut
add wave -noupdate /task1_tb/dut/address_reg
add wave -noupdate /task1_tb/dut/data_reg
add wave -noupdate /task1_tb/dut/write_reg
add wave -noupdate /task1_tb/dut/data_out_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {131 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {439 ps}
