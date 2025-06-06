module line_drawer (
    input  logic clk, reset,
    input logic start,
    input  logic [9:0] x0, x1,  // 10-bit x coordinates (0-639)
    input  logic [8:0] y0, y1,  // 9-bit y coordinates (0-479)
    output logic [9:0] x,       // 10-bit x output
    output logic [8:0] y,       // 9-bit y output
    output logic done,
    output logic pixel
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

    // Signal declarations with proper widths
    logic signed [10:0] dx, dy;        // 11-bit differences (signed)
    logic [9:0] tx0, tx1;              // 10-bit swapped x coordinates
    logic [8:0] ty0, ty1;              // 9-bit swapped y coordinates
    logic [9:0] absdx;                 // 10-bit absolute dx
    logic [8:0] absdy;                 // 9-bit absolute dy
    logic signed [10:0] error;         // 11-bit error term (signed)
    logic [9:0] nextX, tdx;            // 10-bit current x and delta x
    logic [8:0] nextY, tdy;            // 9-bit current y and delta y
    logic signed [8:0] ystep;          // 9-bit y step (signed)
    logic isSteep;                     // steep line flag
    logic [9:0] tmpx;                  // 10-bit temp for x swapping
    logic [8:0] tmpy;                  // 9-bit temp for y swapping

    // Determine if the line is steep and compute deltas
    always_comb begin
        dx = $signed({1'b0, x1}) - $signed({1'b0, x0});  // 11-bit signed
        dy = $signed({2'b0, y1}) - $signed({2'b0, y0});  // 11-bit signed
        absdx = dx[10] ? (~dx[9:0] + 1) : dx[9:0];      // absolute value
        absdy = dy[9] ? (~dy[8:0] + 1) : dy[8:0];        // absolute value
        isSteep = (absdy > absdx);                       // steep line check
    end

    logic prev_start;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= STATE_INIT;
            prev_start <= 0;
        end else begin
            prev_start <= start;
    
            // Rising edge detection on start
            if (start && !prev_start)
                state <= STATE_INIT;
            else
                state <= next_state;
        end
    end


    // Next state logic
    always_comb begin
        next_state = state;
        case (state)
            STATE_INIT:        next_state = STATE_SWAP_COORDS;
            STATE_SWAP_COORDS: next_state = STATE_PREP_DRAW;
            STATE_PREP_DRAW:   next_state = STATE_DRAW_PIXEL;
            STATE_DRAW_PIXEL:  next_state = (nextX >= tx1) ? STATE_FINISHED : STATE_DRAW_PIXEL;
            STATE_FINISHED:    next_state = STATE_FINISHED;
        endcase
    end

    // Core Bresenham algorithm
    always_ff @(posedge clk) begin
        case (state)
            STATE_INIT: begin
                done <= 0;
                if (isSteep) begin
                    // Swap x and y for steep lines
                    tx0 <= y0;
                    ty0 <= x0[8:0];  // Truncate x0 to 9 bits
                    tx1 <= y1;
                    ty1 <= x1[8:0];
                end else begin
                    tx0 <= x0;
                    ty0 <= y0;
                    tx1 <= x1;
                    ty1 <= y1;
                end
            end

            STATE_SWAP_COORDS: begin
                if (tx0 > tx1) begin
                    // Swap endpoints to ensure left-to-right drawing
                    tmpx = tx0;
                    tmpy = ty0;
                    tx0 <= tx1;
                    ty0 <= ty1;
                    tx1 <= tmpx;
                    ty1 <= tmpy;
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
                // Output coordinates (swap back if steep)
                x <= isSteep ? {1'b0, nextY} : nextX;
                y <= isSteep ? nextX[8:0] : nextY;
                pixel <= 1;


                nextX <= nextX + 1;

                if ($signed({2'b0, error}) + $signed({2'b0, tdy}) >= 0) begin
                    nextY <= nextY + ystep;
                    error <= error + $signed({2'b0, tdy}) - $signed({1'b0, tdx});
                end else begin
                    error <= error + $signed({2'b0, tdy});
                end
            end

            STATE_FINISHED: begin
                done <= 1;
            end
        endcase
    end
endmodule