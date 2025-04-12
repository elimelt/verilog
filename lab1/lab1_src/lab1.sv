/* Top-level module for LandsLand hardware connections to implement the parking lot system. */

module lab1 (
	input  logic        clk,    // 50MHz clock
	input  logic        reset,
	input  logic        outer,
	input  logic        inner,
	output logic [4:0]  count
);

	logic inc, dec;

	// FSM to handle car detection
	parking_fsm fsm (
		.clk(clk),
		.reset(reset),
		.outer(outer),						// 1 when blocked
		.inner(inner),						// 1 when blocked
		.enter(inc),  						// 1 when a car enters
		.exit(dec)    						// 1 when a car exits
	);

	// 5-bit counter
	car_counter inst (
		.clk(clk),
		.reset(reset),
		.incr(inc),
		.decr(dec),
		.count(count)
	);

endmodule  // lab1
