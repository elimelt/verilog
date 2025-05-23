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

    logic signed [11:0] dx, dy;                  // signed difference between start and end coordinate y1-y0, x1-x0
    logic signed [11:0] error;                   // step variable for vertical offset
    logic signed [10:0] tx0, tx1, ty0, ty1;      // swapped coordinates 
    logic signed [10:0] absdx, absdy;            // absolute values of dx and dy
    logic signed [10:0] nextX, nextY, tdx, tdy;  // internal line state
    logic signed [10:0] ystep;                   // direction for y-axis stepping
    logic isSteep;                               // checks for steepness
    logic active;                                // indicates initialisation before drawing line

    // Compute steepness and absolute deltas
    always_comb begin
        dx = x1 - x0;
        dy = y1 - y0;
        absdx = dx[11] ? -dx[10:0] : dx[10:0];
        absdy = dy[11] ? -dy[10:0] : dy[10:0];
        isSteep = (absdy > absdx);               // steepness is true if abs change in y > abs change in x
    end

    // Initialization and line drawing FSM
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            done <= 0;
            active <= 1;

            // Swap x/y if steep
            if (isSteep) begin
                tx0 <= y0; ty0 <= x0;            // swap x and y
                tx1 <= y1; ty1 <= x1;
            end else begin
                tx0 <= x0; ty0 <= y0;
                tx1 <= x1; ty1 <= y1;
            end
        end

        else if (active) begin
            // Ensure line is drawn left to right
            if (tx0 > tx1) begin                 // horizontal lines from right-left
                logic [10:0] tmpx, tmpy;         // temporary variables for swapping
                tmpx = tx0; tmpy = ty0;
                tx0 <= tx1; ty0 <= ty1;          // swap endpoints so direction is left-right
                tx1 <= tmpx; ty1 <= tmpy;
            end

            tdx <= tx1 - tx0;
            tdy <= (ty1 > ty0) ? (ty1 - ty0) : (ty0 - ty1); // absolute value of dy
            ystep <= (ty1 > ty0) ? 1 : -1;       // upward or downward
            error <= -((tx1 - tx0) >> 1);        // initialize error term
            nextX <= tx0;                        // leftmost x
            nextY <= ty0;

            active <= 0;                         // move to drawing phase
            done <= 0;
        end

        else if (!done) begin
            if (nextX > tx1) begin               // condition for when drawing line is finished
                done <= 1;
            end else begin
                // Output current pixel
                x <= isSteep ? nextY : nextX;
                y <= isSteep ? nextX : nextY;

                // Move to next pixel
                nextX <= nextX + 1;

                // Adjust error and y coordinate
                if ((error + tdy) >= 0) begin 
                    nextY <= nextY + ystep;
                    error <= error + tdy - tdx;
                end else begin
                    error <= error + tdy;
                end
            end
        end
    end
endmodule // line_drawer
