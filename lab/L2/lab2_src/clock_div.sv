/* Simple Clock Divider taken from CSE 369 */
module clock_div(clock, reset, div);

	input logic reset, clock;
	output logic [31:0] div = 0;
	
	always_ff @(posedge clock) begin
		div <= div + 1'b1;
	end
endmodule // clock_div