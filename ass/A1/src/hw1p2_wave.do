onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group tb /hw1p2_tb/clk
add wave -noupdate -expand -group tb /hw1p2_tb/reset
add wave -noupdate -expand -group tb /hw1p2_tb/in
add wave -noupdate -expand -group tb /hw1p2_tb/out
add wave -noupdate -expand -group dut /hw1p2_tb/dut/clk
add wave -noupdate -expand -group dut /hw1p2_tb/dut/reset
add wave -noupdate -expand -group dut /hw1p2_tb/dut/in
add wave -noupdate -expand -group dut /hw1p2_tb/dut/out
add wave -noupdate -expand -group dut /hw1p2_tb/dut/ps
add wave -noupdate -expand -group dut /hw1p2_tb/dut/ns
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
WaveRestoreZoom {21 ps} {532 ps}
