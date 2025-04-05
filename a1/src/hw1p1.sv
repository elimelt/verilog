/* Module for EE/CSE371 Homework 1 Problem 1.
 * A simple synchronous signal with a DFF and fullAdder.
 */
module hw1p1 (
	input  logic x, 
	input  logic y, 
	input  logic clk, 
	input  logic reset,
	output logic S,
	output logic Q,
	output logic C
);

	// for you to implement
	fullAdder fa (.a(x), .b(y), .cin(Q), .sum(S), .cout(C));
	
	// trigger on clk or reset (async)
	always_ff @(posedge clk or posedge reset) begin
		Q <= reset ? 1'b0 : C;
	end // always_ff

endmodule  // hw1p1
