/* Given two points on the screen this module draws a line between
 * those two points by coloring necessary pixels
 *
 * Inputs:
 *   clk    - should be connected to a 50 MHz clock
 *   reset  - resets the module and starts over the drawing process
 *   x0     - x coordinate of the first end point
 *   y0     - y coordinate of the first end point
 *   x1     - x coordinate of the second end point
 *   y1     - y coordinate of the second end point
 *
 * Outputs:
 *   x      - x coordinate of the pixel to color
 *   y      - y coordinate of the pixel to color
 *   done   - flag that line has finished drawing
 *
 */
module line_drawer (
	input  logic clk, reset,
	input  logic [10:0] x0, y0, x1, y1, 
	output logic [10:0] x, y,
	output logic done 
);
<<<<<<< HEAD
	logic signed [11:0] dx, dy; //signed difference between start and end coordinate y1-y0, x1-x0
	logic signed [11:0] error; //step variable for vertical offset
	logic signed [10:0] tx0, tx1, ty0, ty1; //swapped coordinates 
	logic signed [10:0] tdx, tdy, absdx, absdy;
	logic signed [10:0] nextX, nextY, ystep;
	logic isSteep; //checks for steepness
	logic active; //indicates initialisation before drawing line
	logic init_done; //tracks if initialization is complete
	
	always_comb begin
		dx = x1 - x0;
		dy = y1 - y0;
		absdx = dx[11] ? -dx[10:0] : dx[10:0];
		absdy = dy[11] ? -dy[10:0] : dy[10:0];
		isSteep = (absdy > absdx); //steepness is true if abs change in y > abs change in x
	end
	
	always_ff @(posedge clk) beginq
		if (reset) begin
			active <= 1;
			done <= 0;
			init_done <= 0;
			
=======

	logic signed [11:0] dx, dy, error; // signed difference between start and end coordinate y1-y0, x1-x0
	logic signed [10:0] tx0, tx1, ty0, ty1; // swapped coordinates
	logic signed [10:0] tdx, tdy, nextX, nextY, ystep;
	logic isSteep; // checks for steepness
	logic active; // indicates initialisation before drawing line

	// Initialization and line drawing FSM
	always_ff @(posedge clk or posedge reset) begin
		if (reset) begin
			active <= 1;
			done <= 0;
			x <= 0;
			y <= 0;

			// Calculate differences
			dx <= x1 - x0;
			dy <= y1 - y0;

>>>>>>> 2fac007 (updated line_drawer module)
			// Check for steep lines
			isSteep <= (dy[11] ? -dy[10:0] : dy[10:0]) > (dx[11] ? -dx[10:0] : dx[10:0]);

			// Swap coordinates if steep (to simplify iteration logic)
			if ((dy[11] ? -dy[10:0] : dy[10:0]) > (dx[11] ? -dx[10:0] : dx[10:0])) begin
				tx0 <= y0; ty0 <= x0; // swap x and y
				tx1 <= y1; ty1 <= x1;
			end else begin
				tx0 <= x0; ty0 <= y0;
				tx1 <= x1; ty1 <= y1;
			end
		end
<<<<<<< HEAD
		else if (active && !init_done) begin
			if (tx0 > tx1) begin //horizontal lines from right-left
				tx0 <= tx1; ty0 <= ty1; //swap endpoints so direction is left-right
				tx1 <= tx0; ty1 <= ty0;
			end
			
			tdx <= (tx0 > tx1) ? tx0 - tx1 : tx1 - tx0;
			tdy <= (ty1 > ty0) ? ty1 - ty0 : ty0 - ty1; //absolute value of dy
			ystep <= (ty1 > ty0) ? 1 : -1; //upward or downward
			error <= -((tx0 > tx1 ? tx0 - tx1 : tx1 - tx0)/2);
			nextX <= (tx0 > tx1) ? tx1 : tx0;  // leftmost x
			nextY <= (tx0 > tx1) ? ty1 : ty0;
			init_done <= 1;
		end
		else if (active && init_done) begin
			active <= 0; // drawing time
		end
		else if (!done && !active) begin
			// Drawing line
			if (nextX > (tx0 > tx1 ? tx0 : tx1)) begin //condition for when drawing line is finished
				done <= 1;
			end else begin
				if (isSteep) begin //for steep lines, we swap
					x <= nextY;
					y <= nextX;
				end else begin
					x <= nextX;
					y <= nextY;
				end
				
				nextX <= nextX + 1; //move forward in x-axis regardless of direction
				
=======

		else if (active) begin
			// Ensure line is drawn left to right
			if (tx0 > tx1) begin
				logic [10:0] tmpx, tmpy; // temporary variables for swapping
				tmpx = tx0; tmpy = ty0;
				tx0 <= tx1; ty0 <= ty1;
				tx1 <= tmpx; ty1 <= tmpy;
			end

			// Calculate absolute differences
			tdx <= tx1 - tx0;
			tdy <= (ty1 > ty0) ? ty1 - ty0 : ty0 - ty1;
			ystep <= (ty1 > ty0) ? 1 : -1; // determine direction of y step

			// Initialize error term and starting coordinates
			error <= -((tx1 - tx0) / 2); 
			nextX <= tx0;
			nextY <= ty0;

			active <= 0; // move to drawing phase
			done <= 0;
		end

		else if (!done) begin
			if (nextX > tx1) begin // if we've reached the end, finish
				done <= 1;
			end else begin
				// Output current pixel
				x <= isSteep ? nextY : nextX;
				y <= isSteep ? nextX : nextY;

				// Move to next pixel
				nextX <= nextX + 1;

				// Adjust error and y coordinate
>>>>>>> 2fac007 (updated line_drawer module)
				if ((error + tdy) >= 0) begin 
					error <= error + tdy - tdx;
					nextY <= nextY + ystep;
				end else begin
					error <= error + tdy;
				end
			end
		end
	end
<<<<<<< HEAD
endmodule // line_drawer
=======
endmodule
>>>>>>> 2fac007 (updated line_drawer module)
