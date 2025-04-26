onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /hw3p3_tb/PERIOD
add wave -noupdate /hw3p3_tb/clk
add wave -noupdate /hw3p3_tb/reset
add wave -noupdate /hw3p3_tb/X
add wave -noupdate /hw3p3_tb/Ya
add wave -noupdate /hw3p3_tb/Yb
add wave -noupdate /hw3p3_tb/Yc
add wave -noupdate /hw3p3_tb/Z1
add wave -noupdate /hw3p3_tb/Z2
add wave -noupdate /hw3p3_tb/i
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
WaveRestoreZoom {0 ps} {1 ns}
