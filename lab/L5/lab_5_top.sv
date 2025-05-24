module DE1_SoC (
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
	output logic [9:0] LEDR,
	input  logic [3:0] KEY,
	input  logic [9:0] SW,
	input  logic CLOCK_50,
	output logic [7:0] VGA_R,
	output logic [7:0] VGA_G,
	output logic [7:0] VGA_B,
	output logic VGA_BLANK_N,
	output logic VGA_CLK,
	output logic VGA_HS,
	output logic VGA_SYNC_N,
	output logic VGA_VS
);

	localparam SCREEN_WIDTH = 640;
	localparam SCREEN_HEIGHT = 480;
	localparam CENTER_X = 320;     // center of screen
	localparam CENTER_Y = 240;     // center of screen
	localparam LINE_LENGTH = 150;  // length of rotating line

	localparam POS0_X1 = CENTER_X + LINE_LENGTH;
	localparam POS0_Y1 = CENTER_Y;
	localparam POS1_X1 = CENTER_X + 133;
	localparam POS1_Y1 = CENTER_Y - 69;
	localparam POS2_X1 = CENTER_X + 86;
	localparam POS2_Y1 = CENTER_Y - 123;
	localparam POS3_X1 = CENTER_X + 20;
	localparam POS3_Y1 = CENTER_Y - 149;
	localparam POS4_X1 = CENTER_X - 51;
	localparam POS4_Y1 = CENTER_Y - 141;
	localparam POS5_X1 = CENTER_X - 112;
	localparam POS5_Y1 = CENTER_Y - 101;
	localparam POS6_X1 = CENTER_X - 145;
	localparam POS6_Y1 = CENTER_Y - 39;
	localparam POS7_X1 = CENTER_X - 148;
	localparam POS7_Y1 = CENTER_Y + 33;
	localparam POS8_X1 = CENTER_X - 115;
	localparam POS8_Y1 = CENTER_Y + 96;
	localparam POS9_X1 = CENTER_X - 57;
	localparam POS9_Y1 = CENTER_Y + 137;
	localparam POS10_X1 = CENTER_X + 13;
	localparam POS10_Y1 = CENTER_Y + 150;
	localparam POS11_X1 = CENTER_X + 79;
	localparam POS11_Y1 = CENTER_Y + 127;
	localparam POS12_X1 = CENTER_X + 130;
	localparam POS12_Y1 = CENTER_Y + 75;

	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;

	logic [10:0] x, y;
	logic done, start;
	logic [10:0] x0, y0, x1, y1;
	logic state_advance;
	logic clear_done;
	logic [10:0] clear_x, clear_y;

	enum {
		IDLE,
		CLEAR, WAIT_CLEAR,
		POS0,  WAIT_POS0,
		POS1,  WAIT_POS1,
		POS2,  WAIT_POS2,
		POS3,  WAIT_POS3,
		POS4,  WAIT_POS4,
		POS5,  WAIT_POS5,
		POS6,  WAIT_POS6,
		POS7,  WAIT_POS7,
		POS8,  WAIT_POS8,
		POS9,  WAIT_POS9,
		POS10, WAIT_POS10,
		POS11, WAIT_POS11,
		POS12, WAIT_POS12
	} ps, ns;

	logic [31:0] div_clocks;
	clock_div clk_div (
		.clock (CLOCK_50),
		.reset (1'b0),
		.div   (div_clocks)
	);

	assign slow_clk = div_clocks[23];

	// pulse state_advance for one CLOCK_50 cycle every slow_clk rising edge
	logic slow_clk_d;
	always_ff @(posedge CLOCK_50) begin
		slow_clk_d <= slow_clk;
		state_advance <= slow_clk & ~slow_clk_d;
	end

	// advance state
	always_ff @(posedge CLOCK_50) begin
		if (start)
			ps <= CLEAR;
		else
			ps <= ns;
	end

	// next state logic
	always_comb begin
		ns = ps;
		case (ps)
			IDLE: begin
				if (start) ns = CLEAR;
			end
			CLEAR: begin
				ns = WAIT_CLEAR;
			end
			WAIT_CLEAR: begin
				if (clear_done && state_advance) ns = POS0;
			end
			POS0: begin
				ns = WAIT_POS0;
			end
			WAIT_POS0: begin
				if (done && state_advance) ns = POS1;
			end
			POS1: begin
				ns = WAIT_POS1;
			end
			WAIT_POS1: begin
				if (done && state_advance) ns = POS2;
			end
			POS2: begin
				ns = WAIT_POS2;
			end
			WAIT_POS2: begin
				if (done && state_advance) ns = POS3;
			end
			POS3: begin
				ns = WAIT_POS3;
			end
			WAIT_POS3: begin
				if (done && state_advance) ns = POS4;
			end
			POS4: begin
				ns = WAIT_POS4;
			end
			WAIT_POS4: begin
				if (done && state_advance) ns = POS5;
			end
			POS5: begin
				ns = WAIT_POS5;
			end
			WAIT_POS5: begin
				if (done && state_advance) ns = POS6;
			end
			POS6: begin
				ns = WAIT_POS6;
			end
			WAIT_POS6: begin
				if (done && state_advance) ns = POS7;
			end
			POS7: begin
				ns = WAIT_POS7;
			end
			WAIT_POS7: begin
				if (done && state_advance) ns = POS8;
			end
			POS8: begin
				ns = WAIT_POS8;
			end
			WAIT_POS8: begin
				if (done && state_advance) ns = POS9;
			end
			POS9: begin
				ns = WAIT_POS9;
			end
			WAIT_POS9: begin
				if (done && state_advance) ns = POS10;
			end
			POS10: begin
				ns = WAIT_POS10;
			end
			WAIT_POS10: begin
				if (done && state_advance) ns = POS11;
			end
			POS11: begin
				ns = WAIT_POS11;
			end
			WAIT_POS11: begin
				if (done && state_advance) ns = POS12;
			end
			POS12: begin
				ns = WAIT_POS12;
			end
			WAIT_POS12: begin
				if (done && state_advance) ns = POS0; // loop back to start
			end
		endcase
	end // always_comb

	// set line endpoints
	always_comb begin
		x0 = CENTER_X; // all lines start from center
		y0 = CENTER_Y;
		x1 = 11'd0;
		y1 = 11'd0;

		// x1, y1 assignments
		case (ps)
			POS0, WAIT_POS0: begin
				x1 = POS0_X1;
				y1 = POS0_Y1;
			end
			POS1, WAIT_POS1: begin
				x1 = POS1_X1;
				y1 = POS1_Y1;
			end
			POS2, WAIT_POS2: begin
				x1 = POS2_X1;
				y1 = POS2_Y1;
			end
			POS3, WAIT_POS3: begin
				x1 = POS3_X1;
				y1 = POS3_Y1;
			end
			POS4, WAIT_POS4: begin
				x1 = POS4_X1;
				y1 = POS4_Y1;
			end
			POS5, WAIT_POS5: begin
				x1 = POS5_X1;
				y1 = POS5_Y1;
			end
			POS6, WAIT_POS6: begin
				x1 = POS6_X1;
				y1 = POS6_Y1;
			end
			POS7, WAIT_POS7: begin
				x1 = POS7_X1;
				y1 = POS7_Y1;
			end
			POS8, WAIT_POS8: begin
				x1 = POS8_X1;
				y1 = POS8_Y1;
			end
			POS9, WAIT_POS9: begin
				x1 = POS9_X1;
				y1 = POS9_Y1;
			end
			POS10, WAIT_POS10: begin
				x1 = POS10_X1;
				y1 = POS10_Y1;
			end
			POS11, WAIT_POS11: begin
				x1 = POS11_X1;
				y1 = POS11_Y1;
			end
			POS12, WAIT_POS12: begin
				x1 = POS12_X1;
				y1 = POS12_Y1;
			end
		endcase
	end

	logic start_d, start_pulse;
	always_ff @(posedge CLOCK_50) begin
		start_d <= KEY[0];
		start_pulse <= start_d & ~KEY[0];
	end
	assign start = start_pulse;

	// reset logic
	logic line_reset;
	always_ff @(posedge CLOCK_50) begin
		line_reset <= (ps == POS0) || (ps == POS1) || (ps == POS2) || (ps == POS3) ||
		              (ps == POS4) || (ps == POS5) || (ps == POS6) || (ps == POS7) ||
		              (ps == POS8) || (ps == POS9) || (ps == POS10) || (ps == POS11) || (ps == POS12);
	end

	// pixel_write logic
	logic pixel_write;
	assign pixel_write = (ps == WAIT_CLEAR && !clear_done) || (
											 (ps == WAIT_POS0 || ps == WAIT_POS1 || ps == WAIT_POS2 || ps == WAIT_POS3 ||
												ps == WAIT_POS4 || ps == WAIT_POS5 || ps == WAIT_POS6 || ps == WAIT_POS7 ||
												ps == WAIT_POS8 || ps == WAIT_POS9 || ps == WAIT_POS10 || ps == WAIT_POS11 || ps == WAIT_POS12)
												&& !done);

	line_drawer lines (
		.clk    (CLOCK_50),
		.reset  (line_reset),
		.x0     (x0),
		.y0     (y0),
		.x1     (x1),
		.y1     (y1),
		.x      (x),
		.y      (y),
		.done   (done)
	);

	// clear screan logic
	always_ff @(posedge CLOCK_50) begin
		if (ps == CLEAR) begin
			clear_x <= '0;
			clear_y <= '0;
			clear_done <= 1'b0;
		end else if (ps == WAIT_CLEAR && !clear_done) begin
			if (clear_x < SCREEN_WIDTH - 1) begin
				clear_x <= clear_x + 1'b1;
			end else if (clear_y < SCREEN_HEIGHT - 1) begin
				clear_x <= '0;
				clear_y <= clear_y + 1'b1;
			end else begin
				clear_done <= 1'b1;
			end
		end
	end

	logic [10:0] vga_x, vga_y;
	logic pixel_color;
	always_comb begin
		if (ps == WAIT_CLEAR && !clear_done) begin
			vga_x = clear_x;
			vga_y = clear_y;
			pixel_color = 1'b0;
		end else begin
			vga_x = x;
			vga_y = y;
			pixel_color = 1'b1;
		end
	end

	VGA_framebuffer fb (
		.clk50        (CLOCK_50),
		.reset        (1'b0),
		.x            (vga_x),
		.y            (vga_y),
		.pixel_color  (pixel_color),
		.pixel_write  (pixel_write),
		.VGA_R        (VGA_R),
		.VGA_G        (VGA_G),
		.VGA_B        (VGA_B),
		.VGA_CLK      (VGA_CLK),
		.VGA_HS       (VGA_HS),
		.VGA_VS       (VGA_VS),
		.VGA_BLANK_n  (VGA_BLANK_N),
		.VGA_SYNC_n   (VGA_SYNC_N)
	);

	assign LEDR[9] = done;
	assign LEDR[8] = (ps == POS0 || ps == WAIT_POS0);
	assign LEDR[7] = (ps == POS1 || ps == WAIT_POS1) || (ps == POS2 || ps == WAIT_POS2);
	assign LEDR[6] = (ps == POS3 || ps == WAIT_POS3) || (ps == POS4 || ps == WAIT_POS4);
	assign LEDR[5] = (ps == POS5 || ps == WAIT_POS5) || (ps == POS6 || ps == WAIT_POS6);
	assign LEDR[4] = (ps == POS7 || ps == WAIT_POS7) || (ps == POS8 || ps == WAIT_POS8);
	assign LEDR[3] = (ps == POS9 || ps == WAIT_POS9) || (ps == POS10 || ps == WAIT_POS10);
	assign LEDR[2] = (ps == POS11 || ps == WAIT_POS11) || (ps == POS12 || ps == WAIT_POS12);
	assign LEDR[1] = 1'b0;
	assign LEDR[0] = (ps == CLEAR || ps == WAIT_CLEAR);

endmodule