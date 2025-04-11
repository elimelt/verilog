/* Testbench for parking lot occupancy tracker */
module parking_fsm_tb();
    logic clk, reset;
    logic outer, inner;
    logic enter, exit;
    integer i;
    
    parking_fsm dut (.clk, .reset, .outer, .inner, .enter, .exit);
    
    parameter PERIOD = 10;
    
    // Generate clock
    initial begin
        clk = 0;
        for (i = 0; i < 100; i++) begin 
            #(PERIOD/2) clk <= ~clk;
        end
    end  // initial
    
    initial begin
        // Initialize and reset
        outer <= 0; inner <= 0; reset <= 1;
        @(posedge clk);
    
        reset <= 0;
        @(posedge clk);
        
        // Test Case 1: Car enters
        // IDLE -> ENTER_OUTER
        outer <= 1; inner <= 0;
        @(posedge clk);
        
        // ENTER_OUTER -> ENTER_BOTH
        outer <= 1; inner <= 1;
        @(posedge clk);
        
        // ENTER_BOTH -> ENTER_INNER
        outer <= 0; inner <= 1;
        @(posedge clk);
        
        // ENTER_INNER -> IDLE
        outer <= 0; inner <= 0;
		  assert (enter == 1);
        @(posedge clk);
        
        // Test Case 2: Car exits
        // IDLE -> EXIT_INNER
        outer <= 0; inner <= 1;
        @(posedge clk);
        
        // EXIT_INNER -> EXIT_BOTH
        outer <= 1; inner <= 1;
        @(posedge clk);
        
        // EXIT_BOTH -> EXIT_OUTER
        outer <= 1; inner <= 0;
        @(posedge clk);
        
        // EXIT_OUTER -> IDLE
        outer <= 0; inner <= 0;
		  assert (exit == 1);
        @(posedge clk);
		  
		// Test Case 3: Ped exits
        // IDLE -> EXIT_INNER
        outer <= 0; inner <= 1;
        @(posedge clk);
        
        // EXIT_INNER -> EXIT_OUTER
        outer <= 1; inner <= 0;
        @(posedge clk);
        
        // EXIT_OUTER -> IDLE
        outer <= 0; inner <= 0;
		  assert (exit == 1);
        @(posedge clk);
		  
		// Test Case 4: Ped enters
        // IDLE -> ENTER_OUTER
        outer <= 1; inner <= 0;
        @(posedge clk);
        
        // ENTER_OUTER -> ENTER_INNER
        outer <= 0; inner <= 1;
        @(posedge clk);
        
        // ENTER_INNER -> IDLE
        outer <= 0; inner <= 0;
		  assert (exit == 1);
        @(posedge clk);
        
        // End simulation
        $stop;
    end  // initial
    
endmodule  // parking_fsm_tb