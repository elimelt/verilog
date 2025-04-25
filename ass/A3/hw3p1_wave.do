onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group ctrl /fifo_tb/dut/c_unit/clk
add wave -noupdate -expand -group ctrl /fifo_tb/dut/c_unit/reset
add wave -noupdate -expand -group ctrl /fifo_tb/dut/c_unit/rd
add wave -noupdate -expand -group ctrl /fifo_tb/dut/c_unit/wr
add wave -noupdate -expand -group ctrl /fifo_tb/dut/c_unit/empty
add wave -noupdate -expand -group ctrl /fifo_tb/dut/c_unit/full
add wave -noupdate -expand -group ctrl /fifo_tb/dut/c_unit/w_addr
add wave -noupdate -expand -group ctrl /fifo_tb/dut/c_unit/r_addr
add wave -noupdate -expand -group ctrl /fifo_tb/dut/c_unit/rd_ptr
add wave -noupdate -expand -group ctrl /fifo_tb/dut/c_unit/rd_ptr_next
add wave -noupdate -expand -group ctrl /fifo_tb/dut/c_unit/wr_ptr
add wave -noupdate -expand -group ctrl /fifo_tb/dut/c_unit/wr_ptr_next
add wave -noupdate -expand -group ctrl /fifo_tb/dut/c_unit/empty_next
add wave -noupdate -expand -group ctrl /fifo_tb/dut/c_unit/full_next
add wave -noupdate -expand -group data /fifo_tb/dut/r_unit/clk
add wave -noupdate -expand -group data /fifo_tb/dut/r_unit/w_en
add wave -noupdate -expand -group data -radix hexadecimal /fifo_tb/dut/r_unit/w_addr
add wave -noupdate -expand -group data -radix hexadecimal /fifo_tb/dut/r_unit/r_addr
add wave -noupdate -expand -group data -radix hexadecimal /fifo_tb/dut/r_unit/w_data
add wave -noupdate -expand -group data -radix hexadecimal /fifo_tb/dut/r_unit/r_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {85 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 238
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
WaveRestoreZoom {37 ps} {117 ps}
