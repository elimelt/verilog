onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group clock_div /DE1_SoC_task3_tb/dut/cd/reset
add wave -noupdate -group clock_div /DE1_SoC_task3_tb/dut/cd/clock
add wave -noupdate -group clock_div /DE1_SoC_task3_tb/dut/cd/div
add wave -noupdate -group ram_task2 /DE1_SoC_task3_tb/dut/ram_task2_inst/Address
add wave -noupdate -group ram_task2 /DE1_SoC_task3_tb/dut/ram_task2_inst/DataIn
add wave -noupdate -group ram_task2 /DE1_SoC_task3_tb/dut/ram_task2_inst/Write
add wave -noupdate -group ram_task2 /DE1_SoC_task3_tb/dut/ram_task2_inst/clk
add wave -noupdate -group ram_task2 /DE1_SoC_task3_tb/dut/ram_task2_inst/DataOut
add wave -noupdate -group ram_task2 /DE1_SoC_task3_tb/dut/ram_task2_inst/address_reg
add wave -noupdate -group ram_task2 /DE1_SoC_task3_tb/dut/ram_task2_inst/data_reg
add wave -noupdate -group ram_task2 /DE1_SoC_task3_tb/dut/ram_task2_inst/write_reg
add wave -noupdate -group ram_task2 /DE1_SoC_task3_tb/dut/ram_task2_inst/data_out_reg
add wave -noupdate -group ram_task3 /DE1_SoC_task3_tb/dut/ram_task3_inst/clock
add wave -noupdate -group ram_task3 /DE1_SoC_task3_tb/dut/ram_task3_inst/data
add wave -noupdate -group ram_task3 /DE1_SoC_task3_tb/dut/ram_task3_inst/rdaddress
add wave -noupdate -group ram_task3 /DE1_SoC_task3_tb/dut/ram_task3_inst/wraddress
add wave -noupdate -group ram_task3 /DE1_SoC_task3_tb/dut/ram_task3_inst/wren
add wave -noupdate -group ram_task3 /DE1_SoC_task3_tb/dut/ram_task3_inst/q
add wave -noupdate -group ram_task3 /DE1_SoC_task3_tb/dut/ram_task3_inst/sub_wire0
add wave -noupdate -group hw /DE1_SoC_task3_tb/dut/KEY
add wave -noupdate -group hw /DE1_SoC_task3_tb/dut/SW
add wave -noupdate -group hw /DE1_SoC_task3_tb/dut/HEX0
add wave -noupdate -group hw /DE1_SoC_task3_tb/dut/HEX1
add wave -noupdate -group hw /DE1_SoC_task3_tb/dut/HEX2
add wave -noupdate -group hw /DE1_SoC_task3_tb/dut/HEX3
add wave -noupdate -group hw /DE1_SoC_task3_tb/dut/HEX4
add wave -noupdate -group hw /DE1_SoC_task3_tb/dut/HEX5
add wave -noupdate -group hw /DE1_SoC_task3_tb/dut/LEDR
add wave -noupdate -expand -group locals /DE1_SoC_task3_tb/dut/w_address
add wave -noupdate -expand -group locals /DE1_SoC_task3_tb/dut/r_address
add wave -noupdate -expand -group locals /DE1_SoC_task3_tb/dut/ram_address
add wave -noupdate -expand -group locals /DE1_SoC_task3_tb/dut/data_in
add wave -noupdate -expand -group locals /DE1_SoC_task3_tb/dut/data_out
add wave -noupdate -expand -group locals /DE1_SoC_task3_tb/dut/data_out2
add wave -noupdate -expand -group locals /DE1_SoC_task3_tb/dut/data_out3
add wave -noupdate -expand -group locals /DE1_SoC_task3_tb/dut/write
add wave -noupdate -expand -group locals /DE1_SoC_task3_tb/dut/clk
add wave -noupdate -expand -group locals /DE1_SoC_task3_tb/dut/toggle
add wave -noupdate -expand -group locals /DE1_SoC_task3_tb/dut/w_address_tens
add wave -noupdate -expand -group locals /DE1_SoC_task3_tb/dut/w_address_ones
add wave -noupdate -expand -group locals /DE1_SoC_task3_tb/dut/r_address_tens
add wave -noupdate -expand -group locals /DE1_SoC_task3_tb/dut/r_address_ones
add wave -noupdate -expand -group locals /DE1_SoC_task3_tb/dut/reset
add wave -noupdate -expand -group locals /DE1_SoC_task3_tb/dut/divided
add wave -noupdate -expand -group locals /DE1_SoC_task3_tb/dut/addr_clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 266
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
WaveRestoreZoom {2711 ps} {3319 ps}
