/* Testbench for Homework 2 Problem 3 */
module sign_mag_add_tb ();
	parameter N = 4;
	logic [N-1:0] sum;   // for the output of sign_mag_add - do not rename
	logic [N-1:0] data;  // for the output of sync_rom - do not rename

	// inputs
	logic [N-1:0] a, b;
	logic clk = 0;

	sign_mag_add #(.N(N)) dut1 (.a(a), .b(b), .sum(sum));

	// Clock generation
	always #5 clk = ~clk;

	// display results
	initial begin
			$monitor("Time = %0t: a = %b, b = %b, sum = %b", $time, a, b, sum);
	end
	
	initial begin
			$display("Test case 1: Some number + 0");
			a = 4'b0111;  // +7
			b = 4'b0000;  // +0
			#10;

			$display("Test case 2: pos + neg = 0");
			a = 4'b0001;  // +1
			b = 4'b1111;  // -1
			#10;

			$display("Test case 3: pos + neg > 0");
			a = 4'b0011;  // +3
			b = 4'b1010;  // -2
			#10;

			$display("Test case 4: pos + neg < 0");
			a = 4'b0011;  // +3
			b = 4'b1100;	// -4
			#10;

			$display("Test case 5: pos + pos (valid)");
			a = 4'b0011;  // +3
			b = 4'b0011;  // +3
			#10;

			$display("Test case 6: pos + pos (overflow)");
			a = 4'b0111;  // +7
			b = 4'b0001;  // +1
			#10;

			$display("Test case 7: neg + neg (valid)");
			a = 4'b1011;  // -3
			b = 4'b1011;  // -3
			#10;

			$display("Test case 8: neg + neg (overflow)");
			a = 4'b1111;  // -7
			b = 4'b1001;  // -1
			#10;

			$finish;
	end  // initial
	
endmodule  // sign_mag_add_tb