/* Testbench for Homework 3 Problem 1 */
module fifo_tb ();

	// for you to implement

	// params
	parameter DATA_WIDTH = 8;
	parameter ADDR_WIDTH = 4;

	// signals
	logic clk, reset, rd, wr;
	logic empty, full;
	logic [(2*DATA_WIDTH-1):0] w_data;
	logic [DATA_WIDTH-1:0] r_data;

	// DUT
	fifo #(DATA_WIDTH, ADDR_WIDTH) dut (
		.clk(clk),
		.reset(reset),
		.rd(rd),
		.wr(wr),
		.empty(empty),
		.full(full),
		.w_data(w_data),
		.r_data(r_data)
	);

	// clock generation
	always begin
		clk = 0; #5;
		clk = 1; #5;
	end

	initial begin
		// init signals
		reset = 1;
		rd = 0;
		wr = 0;
		w_data = 16'h0000;
		#20;
		reset = 0;

		w_data = 16'hABCD;
		wr = 1;
		#10;
		wr = 0;

		// upper half
		rd = 1;
		#10;

		// lower half
		#10;
		rd = 0;
		#10;

		// write multiple values
		w_data = 16'h1234;
		wr = 1;
		#10;
		w_data = 16'h5678;
		#10;
		w_data = 16'h9ABC;
		#10;
		wr = 0;

		// see if we can read them back
		rd = 1;
		// first val
		#10; // upper half
		#10; // lower half

		// second val
		#10; // upper half
		#10; // lower half

		// third val
		#10; // upper half
		#10; // lower half

		// should be empty now
		#10;
		rd = 0;
		#10;

		// now fill up
		wr = 1;
		// write 8 entries
		for (int i = 0; i < 8; i++) begin
			w_data = {8'hA0 + i, 8'hB0 + i};
			#10;
		end
		wr = 0;

		// read first few entries back
		rd = 1;
		// first val
		#10; // upper half
		#10; // lower half

		// second val
		#10; // upper half
		#10; // lower half
		rd = 0;

		#20;
		$stop;
	end

endmodule  // fifo_tb
