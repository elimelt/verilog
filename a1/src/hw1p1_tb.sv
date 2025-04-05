/* Testbench for Homework 1 Problem 1 */
module hw1p1_tb();

	// for you to implement
	logic x, y, clk, reset;
	logic S, Q, C;
	integer i;
	
	hw1p1 dut (.x, .y, .clk, .reset, .S, .Q, .C);
	
	parameter PERIOD = 10;
	initial begin
		clk = 0;
		for (i = 0; i < 24; i++) begin 
			#(PERIOD/2) clk <= ~clk;
		end   // for
	end   // initial

	initial begin
	
		x <= 0; y <= 0; reset <= 1;
		@(posedge clk);
		
		reset <= 0;
		@(posedge clk);
		
		
		// From state 0, should stay at 0 and output 0
		x <= 0; y <= 0;  // Q = 0, S = 0
		@(posedge clk);
		
		// From state 0, should stay at 0 and output 1
		x <= 0; y <= 1;  // Q = 0, S = 1
		@(posedge clk);
		
		// From state 0, should stay at 0 and output 1
		x <= 1; y <= 0;  // Q = 0, S = 1
		@(posedge clk);
		
		// From state 0, should go to 1 and output 0
		x <= 1; y <= 1;  // Q = 1, S = 0
		@(posedge clk);
		
		// From state 1, should go to 0 and output 1
		x <= 0; y <= 0;  // Q = 0, S = 1
		@(posedge clk);
		
		// From state 1, should go to 1 and output 1
		x <= 1; y <= 1;  // Q = 1, S = 1
		@(posedge clk);
		
		// From state 1, should go to 1 and output 0
		x <= 1; y <= 0;  // Q = 1, S = 0
		@(posedge clk);
		
		// From state 1, should go to 1 and output 0
		x <= 0; y <= 1;  // Q = 1, S = 0
		@(posedge clk);
		
		// From state 1, should go to 0 and output 1
		x <= 0; y <= 0;  // Q = 0, S = 1
		@(posedge clk);
		
		$stop;   // end the sim
		
	end  // initial
	
endmodule  // hw1p1_tb
