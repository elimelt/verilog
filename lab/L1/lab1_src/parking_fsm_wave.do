onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group dut /parking_fsm_tb/dut/clk
add wave -noupdate -group dut /parking_fsm_tb/dut/reset
add wave -noupdate -group dut /parking_fsm_tb/dut/outer
add wave -noupdate -group dut /parking_fsm_tb/dut/inner
add wave -noupdate -group dut /parking_fsm_tb/dut/car_entered
add wave -noupdate -group dut /parking_fsm_tb/dut/car_exited
add wave -noupdate -group dut /parking_fsm_tb/dut/ps
add wave -noupdate -group dut /parking_fsm_tb/dut/ns
add wave -noupdate -group dut /parking_fsm_tb/dut/sensors
add wave -noupdate -group sim /parking_fsm_tb/PERIOD
add wave -noupdate -group sim /parking_fsm_tb/clk
add wave -noupdate -group sim /parking_fsm_tb/reset
add wave -noupdate -group sim /parking_fsm_tb/outer
add wave -noupdate -group sim /parking_fsm_tb/inner
add wave -noupdate -group sim /parking_fsm_tb/car_entered
add wave -noupdate -group sim /parking_fsm_tb/car_exited
add wave -noupdate -group sim /parking_fsm_tb/i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {95 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 244
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
WaveRestoreZoom {0 ps} {253 ps}
