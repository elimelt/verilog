/* Module for parking lot occupancy tracker.
* FSM to detect car entering and exiting
*/
module parking_fsm (
	input  logic clk,
	input  logic reset,
	input  logic outer,		// 1 when blocked
	input  logic inner,   // 1 when blocked
	output logic enter,		// 1 when a car enters
	output logic exit			// 1 when a car exits
);
	// State def
	enum logic [3:0] {
		IDLE,           // Both sensors unblocked
		ENTER_OUTER,    // Outer sensor active, something beginning to enter
		ENTER_BOTH,     // Both sensors active, car entering
		ENTER_INNER,    // Inner sensor active, something finishing entering
		EXIT_INNER,     // Inner sensor active, something beginning to exit
		EXIT_BOTH,      // Both sensors active, car exiting
		EXIT_OUTER      // Outer sensor active, something finishing exiting
	} ps, ns;         // Present State and Next State

	logic [1:0] sensors;
	assign sensors = {outer, inner};

	// Next state logic
	always_comb begin
		// Default to staying in the same state
		ns = ps;

		case (ps)
			IDLE: begin
				case (sensors)
					2'b10: ns = ENTER_OUTER;   // something entering
					2'b01: ns = EXIT_INNER;    // something exiting
					default: ns = IDLE;
				endcase
			end

			ENTER_OUTER: begin
				case (sensors)
					2'b11: ns = ENTER_BOTH;    	// car entering
					2'b00: ns = IDLE;          	// possibly a thin pedestrian
					2'b01: ns = ENTER_INNER;		// possibly a quick pedestrian
					default: ns = ENTER_OUTER;
				endcase
			end

			ENTER_BOTH: begin
				case (sensors)
					2'b01: ns = ENTER_INNER;   // car finishing entering
					2'b00: ns = IDLE;          // car vanished... should be impossible
					2'b10: ns = EXIT_OUTER;    // car reversed direction...should be impossible
					default: ns = ENTER_BOTH;
				endcase
			end

			ENTER_INNER: begin
				case (sensors)
					2'b00: ns = IDLE;          // car or ped fully entered
					2'b11: ns = ENTER_BOTH;    // car reversed direction...should be impossible
					2'b10: ns = ENTER_OUTER;   // possibly a new pedestrian, or a pedestrian switch directions
					default: ns = ENTER_INNER;
				endcase
			end

			EXIT_INNER: begin
				case (sensors)
					2'b11: ns = EXIT_BOTH;     // car exiting
					2'b00: ns = IDLE;          // possibly a quick pedestrian exiting
					2'b10: ns = EXIT_OUTER;    // possibly a thin pedestrian exiting
					default: ns = EXIT_INNER;
				endcase
			end

			EXIT_BOTH: begin
				case (sensors)
					2'b10: ns = EXIT_OUTER;    // car finishing exit
					2'b00: ns = IDLE;          // car vanished...should be impossible...
					2'b01: ns = ENTER_INNER;   // car reversed direction...should be impossible
					default: ns = EXIT_BOTH;
				endcase
			end

			EXIT_OUTER: begin
				case (sensors)
					2'b00: ns = IDLE;          // car or ped fully exited
					2'b11: ns = EXIT_BOTH;     // car reversed direction...should be impossible
					2'b01: ns = EXIT_INNER;    // possibly a new pedestrian, or a pedestrian switch directions
					default: ns = EXIT_OUTER;
				endcase
			end
		endcase
	end // always_comb

	always_comb begin
		// output values
		enter = 1'b0;
		exit = 1'b0;

		if (ps == ENTER_INNER && ns == IDLE)
			enter = 1'b1;

		if (ps == EXIT_OUTER && ns == IDLE)
			exit = 1'b1;
	end // always_comb


	always_ff @(posedge clk)
		ps <= reset ? IDLE : ns;

endmodule  // parking_fsm