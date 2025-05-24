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

    // Define states for line drawing algorithm
    typedef enum logic [2:0] {
        STATE_INIT,         // compute steepness and store initial swapped coordinates
        STATE_SWAP_COORDS,  // swap endpoints to ensure left-to-right traversal
        STATE_PREP_DRAW,    // initialize delta values, error, and step direction
        STATE_DRAW_PIXEL,   // output each pixel along the line
        STATE_FINISHED      // mark drawing as complete
    } state_t;

    state_t state, next_state;

    logic signed [11:0] dx, dy;// differences between x and y coordinates
    logic signed [10:0] tx0, ty0, tx1, ty1;// swapped coordinates
    logic signed [10:0] absdx, absdy; // absolute values of dx and dy
    logic signed [11:0] error; // error term
    logic signed [10:0] nextX, nextY, tdx, tdy;// current pixel location and deltas
    logic signed [10:0] ystep;  // direction to step in y
    logic isSteep;// flag for steepness 
    logic signed [10:0] tmpx0, tmpy0;// temp var for safe swapping

    
    // Determine if the line is steep and compute deltas
    always_comb begin
        dx = x1 - x0;                                
        dy = y1 - y0;                                
        absdx = dx[11] ? -dx[10:0] : dx[10:0];       
        absdy = dy[11] ? -dy[10:0] : dy[10:0];       
        isSteep = (absdy > absdx); // if slope > 1, line is steep
    end

    // Update state machine
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= STATE_INIT; // reset state to INIT
        end else begin
            state <= next_state; // advance to next state
        end
    end

    // Determine next state based on current state and logic
    always_comb begin
        next_state = state;
        case (state)
            STATE_INIT:        next_state = STATE_SWAP_COORDS; // proceed to swap coordinates
            STATE_SWAP_COORDS: next_state = STATE_PREP_DRAW;  // proceed to drawing setup
            STATE_PREP_DRAW:   next_state = STATE_DRAW_PIXEL; // begin drawing pixels
            STATE_DRAW_PIXEL:
                if (nextX > tx1) next_state = STATE_FINISHED;      
                else next_state = STATE_DRAW_PIXEL;                
            STATE_FINISHED:    next_state = STATE_FINISHED;        
        endcase
    end

    // Core logic for Bresenham algorithm
    always_ff @(posedge clk) begin
        case (state)
            STATE_INIT: begin
                done <= 0;                                         
                if (isSteep) begin
                    tx0 <= y0; ty0 <= x0;// swap coordinates if steep
                    tx1 <= y1; ty1 <= x1;
                end else begin
                    tx0 <= x0; ty0 <= y0; // Use original coordinates otherwise
                    tx1 <= x1; ty1 <= y1;
                end
            end

            STATE_SWAP_COORDS: begin
                if (tx0 > tx1) begin // Ensure left-to-right drawing
                    tmpx0 <= tx0;                                
                    tmpy0 <= ty0;                                 
                    tx0 <= tx1;                                  
                    ty0 <= ty1;                                  
                    tx1 <= tmpx0;                                 
                    ty1 <= tmpy0;                                 
                end
            end

            STATE_PREP_DRAW: begin
                tdx <= tx1 - tx0;                                 
                tdy <= (ty1 > ty0) ? (ty1 - ty0) : (ty0 - ty1);    
                ystep <= (ty1 > ty0) ? 1 : -1;                     
                error <= -((tx1 - tx0) >> 1);                     
                nextX <= tx0;                                     
                nextY <= ty0;                                     
            end

            STATE_DRAW_PIXEL: begin
                x <= isSteep ? nextY : nextX;                     // output x (swap if steep)
                y <= isSteep ? nextX : nextY;                     // output y (swap if steep)

                nextX <= nextX + 1;                               // advance to next x

                if ((error + tdy) >= 0) begin                     // check if y needs to change
                    nextY <= nextY + ystep;                       // increment/decrement y
                    error <= error + tdy - tdx;                   // update error term with correction
                end else begin
                    error <= error + tdy;                         // update error term only
                end
            end

            STATE_FINISHED: begin
                done <= 1;                                       
            end
        endcase
    end
endmodule
