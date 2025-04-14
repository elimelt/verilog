onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group fsm /lab1_tb/dut/fsm/clk
add wave -noupdate -expand -group fsm /lab1_tb/dut/fsm/reset
add wave -noupdate -expand -group fsm /lab1_tb/dut/fsm/outer
add wave -noupdate -expand -group fsm /lab1_tb/dut/fsm/inner
add wave -noupdate -expand -group fsm /lab1_tb/dut/fsm/enter
add wave -noupdate -expand -group fsm /lab1_tb/dut/fsm/exit
add wave -noupdate -expand -group fsm /lab1_tb/dut/fsm/ps
add wave -noupdate -expand -group fsm /lab1_tb/dut/fsm/ns
add wave -noupdate -expand -group fsm /lab1_tb/dut/fsm/sensors
add wave -noupdate -expand -group counter /lab1_tb/dut/inst/clk
add wave -noupdate -expand -group counter /lab1_tb/dut/inst/reset
add wave -noupdate -expand -group counter /lab1_tb/dut/inst/incr
add wave -noupdate -expand -group counter /lab1_tb/dut/inst/decr
add wave -noupdate -expand -group counter /lab1_tb/dut/inst/count
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
WaveRestoreZoom {0 ps} {600 ps}
