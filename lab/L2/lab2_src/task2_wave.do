onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group hw /DE1_SoC_task2_tb/dut/CLOCK_50
add wave -noupdate -group hw /DE1_SoC_task2_tb/dut/KEY
add wave -noupdate -group hw /DE1_SoC_task2_tb/dut/SW
add wave -noupdate -group hw /DE1_SoC_task2_tb/dut/HEX0
add wave -noupdate -group hw /DE1_SoC_task2_tb/dut/HEX1
add wave -noupdate -group hw /DE1_SoC_task2_tb/dut/HEX2
add wave -noupdate -group hw /DE1_SoC_task2_tb/dut/HEX3
add wave -noupdate -group hw /DE1_SoC_task2_tb/dut/HEX4
add wave -noupdate -group hw /DE1_SoC_task2_tb/dut/HEX5
add wave -noupdate -group hw /DE1_SoC_task2_tb/dut/LEDR
add wave -noupdate -group hw /DE1_SoC_task2_tb/dut/clk
add wave -noupdate -expand -group sw /DE1_SoC_task2_tb/dut/hw_abstraction/address
add wave -noupdate -expand -group sw /DE1_SoC_task2_tb/dut/hw_abstraction/data_in
add wave -noupdate -expand -group sw /DE1_SoC_task2_tb/dut/hw_abstraction/data_out
add wave -noupdate -expand -group sw /DE1_SoC_task2_tb/dut/hw_abstraction/write
add wave -noupdate -expand -group sw /DE1_SoC_task2_tb/dut/hw_abstraction/address_tens
add wave -noupdate -expand -group sw /DE1_SoC_task2_tb/dut/hw_abstraction/address_ones
add wave -noupdate -expand -group sw /DE1_SoC_task2_tb/dut/hw_abstraction/hex0_out
add wave -noupdate -expand -group sw /DE1_SoC_task2_tb/dut/hw_abstraction/hex1_out
add wave -noupdate -expand -group sw /DE1_SoC_task2_tb/dut/hw_abstraction/hex4_out
add wave -noupdate -expand -group sw /DE1_SoC_task2_tb/dut/hw_abstraction/hex5_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {131 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 288
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
WaveRestoreZoom {0 ps} {167 ps}
