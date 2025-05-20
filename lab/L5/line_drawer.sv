/* Given two points on the screen this module draws a line between
 * those two points by coloring necessary pixels
 *
 * Inputs:
 *   clk    - should be connected to a 50 MHz clock
 *   reset  - resets the module and starts over the drawing process
 *	  x0 	- x coordinate of the first end point
 *   y0 	- y coordinate of the first end point
 *   x1 	- x coordinate of the second end point
 *   y1 	- y coordinate of the second end point
 *
 * Outputs:
 *   x 		- x coordinate of the pixel to color
 *   y 		- y coordinate of the pixel to color
 *   done	- flag that line has finished drawing
 *
 */
 module line_drawer (
	input  logic clk, reset,
	input  logic [10:0] x0, y0, x1, y1,
	output logic [10:0] x, y,
	output logic done 
);

	logic signed [11:0] dx, dy; //signed difference between start and end coordinate y1-y0, x1-x0
	logic signed [11:0] error; //step variable for vertical offset
	logic signed [10:0] tx0, tx1, ty0, ty1; //swapped coordinates 
	logic signed [10:0] tdx, tdy, absdx, absdy;
	logic signed [10:0] nextX, nextY, ystep;
	logic isSteep; //checks for steepness
	logic active; //indicates initialisation before drawing line

	always_comb begin
		dx = x1 - x0;
		dy = y1 - y0;
		absdx = dx[11] ? -dx[10:0] : dx[10:0];
		absdy = dy[11] ? -dy[10:0] : dy[10:0];
		isSteep = (absdy > absdx); //steepness is true if abs change in y > abs change in x
	end

	always_ff @(posedge clk or posedge reset) begin
		if (reset) begin
			active <= 1;
			done <= 0;

			// Check for steep lines
			if (isSteep) begin
				tx0 <= y0; ty0 <= x0; //swap x coordinates with y
				tx1 <= y1; ty1 <= x1;
			end else begin
				tx0 <= x0; ty0 <= y0;
				tx1 <= x1; ty1 <= y1;
			end
		end
		else if (active) begin
			if (tx0 > tx1) begin //horizontal lines from right-left
				logic [10:0] tmpx, tmpy; //temp variables to swap endpoints so direction is left-right
				tmpx = tx0; tmpy = ty0;
				tx0 <= tx1; ty0 <= ty1;
				tx1 <= tmpx; ty1 <= tmpy;
			end

			tdx <= tx1 - tx0;
			tdy <= (ty1 > ty0) ? ty1 - ty0 : ty0 - ty1; //absolute value of dy
			ystep <= (ty1 > ty0) ? 1 : -1; //upward or downward
			error <= -((tx1 - tx0)/2); 
			nextX <= tx0;
			nextY <= ty0;
			active <= 0; //initialisation is done
		end
	end

	// Drawing line
	always_ff @(posedge clk) begin
		if (!done && !active) begin
			if (nextX > tx1) begin //condition for when drawing line is finished
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
				if ((error + tdy) >= 0) begin 
					error <= error + tdy - tdx; //update error
					nextY <= nextY + ystep; //go +1 higher in y-axis
				end else begin
					error <= error + tdy;
				end
			end
		end
	end

endmodule
