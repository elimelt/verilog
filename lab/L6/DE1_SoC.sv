module DE1_SoC (
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
    output logic [9:0] LEDR,
    input  logic [3:0] KEY,
    input  logic [9:0] SW,
    input  CLOCK_50,
    inout  [35:23] V_GPIO,
    output [7:0] VGA_R, VGA_G, VGA_B,
    output VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS
);

    localparam SCREEN_WIDTH = 640;
    localparam SCREEN_HEIGHT = 480;
    localparam CENTER_X = SCREEN_WIDTH / 2;
    localparam CENTER_Y = SCREEN_HEIGHT / 2;
    localparam STEP_SIZE = 5;
    
    logic reset;
    logic [9:0] x, line_x;
    logic [8:0] y, line_y;
    logic [9:0] x0, x1;
    logic [8:0] y0, y1;
    logic [7:0] r, g, b;
    logic line_pixel, line_done;
    logic up, down, left, right, start, select, a, b1;

    assign reset = ~KEY[0];
    
    logic wall_pixel;
    
    maze_template maze (
        .x(x),
        .y(y),
        .is_wall(wall_pixel)
    );

    // maze template for collision detection
    logic [9:0] check_x;
    logic [8:0] check_y;
    logic check_wall;

    maze_template maze_check (
        .x(check_x),
        .y(check_y),
        .is_wall(check_wall)
    );

    video_driver #(.WIDTH(640), .HEIGHT(480)) v1 (
        .CLOCK_50, .reset, .x, .y, .r, .g, .b,
        .VGA_R, .VGA_G, .VGA_B,
        .VGA_BLANK_N, .VGA_CLK, .VGA_HS, .VGA_SYNC_N, .VGA_VS
    );

    n8_driver controller (
        .clk(CLOCK_50),
        .data_in(V_GPIO[28]),
        .latch(V_GPIO[26]),
        .pulse(V_GPIO[27]),
        .up(up), .down(down), .left(left), .right(right),
        .select(select), .start(start), .a(a), .b(b1)
    );

    n8_display display (
        .clk(CLOCK_50),
        .right(right), .left(left), .up(up), .down(down),
        .select(select), .start(start), .a(a), .b(b1),
        .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5
    );

    // Edge detection
    logic prev_up, prev_down, prev_left, prev_right;
    logic move_up, move_down, move_left, move_right;

    always_ff @(posedge CLOCK_50) begin
        prev_up    <= up;
        prev_down  <= down;
        prev_left  <= left;
        prev_right <= right;

        move_up    <= up    & ~prev_up  ;
        move_down  <= down  & ~prev_down ;
        move_left  <= left  & ~prev_left;
        move_right <= right & ~prev_right;
    end

    // collision detection and movement
    typedef enum logic [1:0] {
        IDLE,
        CHECK_COLLISION,
        MOVE_IF_VALID
    } move_state_t;

    move_state_t move_state;
    logic [9:0] next_x1;
    logic [8:0] next_y1;
    logic move_pending;

    always_ff @(posedge CLOCK_50) begin
        if (reset) begin
            x0 <= CENTER_X;
            y0 <= CENTER_Y + 175;
            x1 <= CENTER_X;
            y1 <= CENTER_Y + 175;
            move_state <= IDLE;
            move_pending <= 0;
        end else begin
            case (move_state)
                IDLE: begin
                    if (move_up || move_down || move_left || move_right) begin
                        // destination coordinates
                        next_x1 <= x1;
                        next_y1 <= y1;

                        if (move_up) begin
                            next_x1 <= x1;
                            next_y1 <= (y1 >= STEP_SIZE) ? y1 - STEP_SIZE : 0;
                        end else if (move_down) begin
                            next_x1 <= x1;
                            next_y1 <= (y1 <= SCREEN_HEIGHT - STEP_SIZE - 1) ? y1 + STEP_SIZE : SCREEN_HEIGHT - 1;
                        end else if (move_left) begin
                            next_x1 <= (x1 >= STEP_SIZE) ? x1 - STEP_SIZE : 0;
                            next_y1 <= y1;
                        end else if (move_right) begin
                            next_x1 <= (x1 <= SCREEN_WIDTH - STEP_SIZE - 1) ? x1 + STEP_SIZE : SCREEN_WIDTH - 1;
                            next_y1 <= y1;
                        end

                        move_state <= CHECK_COLLISION;
                        move_pending <= 1;
                    end
                end

                CHECK_COLLISION: begin
                    // load coordinates for collision check
                    check_x <= next_x1;
                    check_y <= next_y1;
                    move_state <= MOVE_IF_VALID;
                end

                MOVE_IF_VALID: begin
                    // move if not a wall
                    if (!check_wall) begin
                        x1 <= next_x1;
                        y1 <= next_y1;
                    end
                    move_state <= IDLE;
                    move_pending <= 0;
                end
            endcase
        end
    end

    assign restart_draw = (move_state == MOVE_IF_VALID) && !check_wall;

    line_drawer drawer (
        .clk(CLOCK_50),
        .reset(reset),
        .x0, .y0, .x1, .y1,
        .x(line_x), .y(line_y),
        .done(line_done),
        .pixel(line_pixel),
        .start(restart_draw)
    );

    logic drawing;
    always_ff @(posedge CLOCK_50 or posedge reset) begin
        if (reset)
            drawing <= 1;
        else if (line_done)
            drawing <= 0;
    end
    
    logic [9:0] line_x_buf;
    logic [8:0] line_y_buf;
    
    always_ff @(posedge CLOCK_50) begin
        line_x_buf <= line_x;
        line_y_buf <= line_y;
    end
    assign LEDR[3:0] = {move_right, move_left, move_down, move_up};
    assign LEDR[8:4] = {right, left, down, up, check_wall};

    /// Pixel coloring
    always_ff @(posedge CLOCK_50) begin
        if (reset) begin
            r <= 8'h00; g <= 8'h00; b <= 8'h00;
        end else begin
            // Default to black background
            r <= 8'h00; g <= 8'h00; b <= 8'h00;
    
            // Optional: draw maze walls here if you have wall_pixel signal
            if (wall_pixel) begin
                r <= 8'hFF; g <= 8'h00; b <= 8'h00;
            end
    
            // // Draw white line (takes priority over background/walls)
            // if (drawing && x == line_x_buf && y == line_y_buf) begin
            //     r <= 8'hFF; g <= 8'hFF; b <= 8'hFF;
            // end
    
            // Draw green dot for current endpoint
            if (x >= x1 - 2 && x <= x1 + 2 && y >= y1 - 2 && y <= y1 + 2) begin
                r <= 8'h00; g <= 8'hFF; b <= 8'h00;
            end
        end
    end

endmodule