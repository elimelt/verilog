onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group hw /DE1_SoC_tb/PERIOD
add wave -noupdate -group hw /DE1_SoC_tb/CLOCK_50
add wave -noupdate -group hw /DE1_SoC_tb/KEY
add wave -noupdate -group hw /DE1_SoC_tb/SW
add wave -noupdate -group hw /DE1_SoC_tb/HEX0
add wave -noupdate -group hw /DE1_SoC_tb/HEX1
add wave -noupdate -group hw /DE1_SoC_tb/HEX2
add wave -noupdate -group hw /DE1_SoC_tb/HEX3
add wave -noupdate -group hw /DE1_SoC_tb/HEX4
add wave -noupdate -group hw /DE1_SoC_tb/HEX5
add wave -noupdate -group hw /DE1_SoC_tb/LEDR
add wave -noupdate -expand -group sig /DE1_SoC_tb/dut/address
add wave -noupdate -expand -group sig /DE1_SoC_tb/dut/data_in
add wave -noupdate -expand -group sig /DE1_SoC_tb/dut/data_out
add wave -noupdate -expand -group sig /DE1_SoC_tb/dut/write
add wave -noupdate -expand -group sig /DE1_SoC_tb/dut/clk
add wave -noupdate -expand -group sig /DE1_SoC_tb/dut/hex0_out
add wave -noupdate -expand -group sig /DE1_SoC_tb/dut/hex1_out
add wave -noupdate -expand -group sig /DE1_SoC_tb/dut/hex4_out
add wave -noupdate -expand -group sig /DE1_SoC_tb/dut/hex5_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
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
WaveRestoreZoom {0 ps} {160 ps}
