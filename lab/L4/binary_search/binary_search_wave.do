onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /binary_search_tb/dut/Found
add wave -noupdate /binary_search_tb/dut/Done
add wave -noupdate -radix unsigned /binary_search_tb/dut/Loc
add wave -noupdate -radix unsigned /binary_search_tb/dut/A
add wave -noupdate /binary_search_tb/dut/clk
add wave -noupdate /binary_search_tb/dut/reset
add wave -noupdate /binary_search_tb/dut/start
add wave -noupdate -radix unsigned /binary_search_tb/dut/curr_data
add wave -noupdate -radix unsigned /binary_search_tb/dut/L
add wave -noupdate -radix unsigned /binary_search_tb/dut/R
add wave -noupdate -radix unsigned /binary_search_tb/dut/M
add wave -noupdate /binary_search_tb/dut/load_regs
add wave -noupdate /binary_search_tb/dut/set_Addr
add wave -noupdate /binary_search_tb/dut/set_L
add wave -noupdate /binary_search_tb/dut/set_R
add wave -noupdate /binary_search_tb/dut/set_Found
add wave -noupdate /binary_search_tb/dut/set_Done
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {195 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 222
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
WaveRestoreZoom {0 ps} {1879 ps}
