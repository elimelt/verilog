onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group dut /task1_tb/dut/Address
add wave -noupdate -expand -group dut /task1_tb/dut/DataIn
add wave -noupdate -expand -group dut /task1_tb/dut/Write
add wave -noupdate -expand -group dut /task1_tb/dut/clk
add wave -noupdate -expand -group dut /task1_tb/dut/DataOut
add wave -noupdate -expand -group dut /task1_tb/dut/address
add wave -noupdate -expand -group dut /task1_tb/dut/data
add wave -noupdate -expand -group dut /task1_tb/dut/wren
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ps} {388 ps}
