module part3_tb();
	logic signed [23:0] din_left, din_right;
	logic CLOCK_50, reset, read_ready, write_ready;
	logic [23:0] dout_left, dout_right;

	part3 dut (.clk(CLOCK_50) , .reset(reset) , .r(read_ready) , .w(write_ready) , .in_left(din_left) , .in_right(din_right) , .out_left(dout_left) , .out_right(dout_right)) ;
	
	// Set up a simulated clock.   
	parameter CLOCK_PERIOD=100; 

	initial begin   
		CLOCK_50 <= 0;  
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Forever toggle the clock 
	end  
	
	
	initial begin
		reset  = 1'b1; 
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		 reset = 1'b0;
		din_left = 24'b0; din_right = 24'b0; read_ready = 1'b0; write_ready = 1'b0; @(posedge CLOCK_50);
		
		din_left = 24'd100; din_right = 24'd100; @(posedge CLOCK_50);
		din_left = 24'd100; din_right = 24'd100; read_ready = 1'b1; write_ready = 1'b1; @(posedge CLOCK_50);
		din_left = 24'd100; din_right = 24'd100; read_ready = 1'b0; write_ready = 1'b0; @(posedge CLOCK_50);
		din_left = 24'd900; din_right = 24'd900; @(posedge CLOCK_50);
		din_left = 24'd900; din_right = 24'd900; read_ready = 1'b1; write_ready = 1'b1; @(posedge CLOCK_50);
		din_left = 24'd900; din_right = 24'd900; read_ready = 1'b0; write_ready = 1'b0; @(posedge CLOCK_50);
		din_left = 24'd1000; din_right = 24'd1000; @(posedge CLOCK_50);
		din_left = 24'd1000; din_right = 24'd1000; read_ready = 1'b1; write_ready = 1'b1; @(posedge CLOCK_50);
		din_left = 24'd1000; din_right = 24'd1000; read_ready = 1'b0; write_ready = 1'b0; @(posedge CLOCK_50);
		din_left = 24'd10000; din_right = 24'd10000; @(posedge CLOCK_50);
		din_left = 24'd10000; din_right = 24'd10000; read_ready = 1'b1; write_ready = 1'b1; @(posedge CLOCK_50);
		din_left = 24'd10000; din_right = 24'd10000; read_ready = 1'b0; write_ready = 1'b0; @(posedge CLOCK_50);
		din_left = 24'd100000; din_right = 24'd100000; @(posedge CLOCK_50);
		din_left = 24'd100000; din_right = 24'd100000; read_ready = 1'b1; write_ready = 1'b1; @(posedge CLOCK_50);
		din_left = 24'd100000; din_right = 24'd100000; read_ready = 1'b0; write_ready = 1'b0; @(posedge CLOCK_50);
		din_left = 24'd1000000; din_right = 24'd1000000; @(posedge CLOCK_50);
		din_left = 24'd1000000; din_right = 24'd1000000; read_ready = 1'b1; write_ready = 1'b1; @(posedge CLOCK_50);
		din_left = 24'd1000000; din_right = 24'd1000000; read_ready = 1'b0; write_ready = 1'b0; @(posedge CLOCK_50);
		din_left = 24'd100000; din_right = 24'd100000; @(posedge CLOCK_50);
		din_left = 24'd100000; din_right = 24'd100000; read_ready = 1'b1; write_ready = 1'b1; @(posedge CLOCK_50);
		din_left = 24'd100000; din_right = 24'd100000; read_ready = 1'b0; write_ready = 1'b0; @(posedge CLOCK_50);
		din_left = 24'd10000; din_right = 24'd10000; @(posedge CLOCK_50);
		din_left = 24'd10000; din_right = 24'd10000; read_ready = 1'b1; write_ready = 1'b1; @(posedge CLOCK_50);
		din_left = 24'd10000; din_right = 24'd10000; read_ready = 1'b0; write_ready = 1'b0; @(posedge CLOCK_50);
		din_left = 24'd1000; din_right = 24'd1000; @(posedge CLOCK_50);
		din_left = 24'd1000; din_right = 24'd1000; read_ready = 1'b1; write_ready = 1'b1; @(posedge CLOCK_50);
		din_left = 24'd1000; din_right = 24'd1000; read_ready = 1'b0; write_ready = 1'b0; @(posedge CLOCK_50);
		din_left = 24'd900; din_right = 24'd900; @(posedge CLOCK_50);
		din_left = 24'd900; din_right = 24'd900; read_ready = 1'b1; write_ready = 1'b1; @(posedge CLOCK_50);
		din_left = 24'd900; din_right = 24'd900; read_ready = 1'b0; write_ready = 1'b0; @(posedge CLOCK_50);
		din_left = 24'd100; din_right = 24'd100; @(posedge CLOCK_50);
		din_left = 24'd100; din_right = 24'd100; read_ready = 1'b1; write_ready = 1'b1; @(posedge CLOCK_50);
		din_left = 24'd100; din_right = 24'd100; read_ready = 1'b0; write_ready = 1'b0; @(posedge CLOCK_50);
	
	$stop; // End the simulation.  
	end
	
endmodule