/* Module for EE/CSE371 Homework 1 Problem 2.
 * An arbitrary Mealy FSM.
 */
module hw1p2 (
    input  logic clk, reset, in,
    output logic out
);

	// State encoding
	// Signals ps = "Present State" and ns = "Next State".
	enum {ooi, oii, oio, ooo, ioo} ps, ns;

	always_comb
		case (ps)
			ooi:	 	ns = in ? ioo : ooi;
			oii:	 	ns = in ? oio : ooi;
			oio:	 	ns = in ? ooo : oio;
			ooo:	 	ns = in ? ioo : oii;
			ioo:	 	ns = in ? oii : oio;
			default:	ns = ooo;
		endcase

	// Output logic: if input is high and 
	// on any state except for ioo
	assign out = in && (
		(ps == ooi) || 
		(ps == oii) ||
		(ps == oio) ||
		(ps == ooo)
	);

	// Sequential logic (DFFs) - reset state is zero.
	always_ff @(posedge clk)
		ps <= reset ? ooo : ns;

endmodule  // hw1p2
