/* Top level module of the FPGA that takes the onboard resources 
 * as input and outputs the lines drawn from the VGA port.
 *
 * Inputs:
 *   KEY 			- On board keys of the FPGA
 *   SW 			- On board switches of the FPGA
 *   CLOCK_50 		- On board 50 MHz clock of the FPGA
 *
 * Outputs:
 *   HEX 			- On board 7 segment displays of the FPGA
 *   LEDR 			- On board LEDs of the FPGA
 *   VGA_R 			- Red data of the VGA connection
 *   VGA_G 			- Green data of the VGA connection
 *   VGA_B 			- Blue data of the VGA connection
 *   VGA_BLANK_N 	- Blanking interval of the VGA connection
 *   VGA_CLK 		- VGA's clock signal
 *   VGA_HS 		- Horizontal Sync of the VGA connection
 *   VGA_SYNC_N 	- Enable signal for the sync of the VGA connection
 *   VGA_VS 		- Vertical Sync of the VGA connection
 */
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, CLOCK_50, 
	VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	
	localparam SCREEN_WIDTH = 641;
	localparam SCREEN_HEIGHT = 480;
	localparam ORIGIN_X = 0;
	localparam ORIGIN_Y = 0;
	localparam TOP_LEFT_X = 50;
	localparam TOP_LEFT_Y = 50;
	localparam TOP_RIGHT_X = 400;
	localparam TOP_RIGHT_Y = 50;
	localparam BOTTOM_LEFT_X = 50;
	localparam BOTTOM_LEFT_Y = 400;
	localparam BOTTOM_RIGHT_X = 400;
	localparam BOTTOM_RIGHT_Y = 400;
	localparam MID_X = 240;
	localparam MID_Y = 240;
	localparam NEAR_LEFT_X = 100;
	localparam NEAR_RIGHT_X = 300;
	localparam NEAR_TOP_Y = 100;
	localparam NEAR_BOTTOM_Y = 340;
	localparam FAR_RIGHT_X = 400;
	localparam FAR_BOTTOM_Y = 400;
	localparam SMALL_OFFSET_X = 200;
	localparam LARGE_OFFSET_Y = 300;
	
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	input CLOCK_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	assign LEDR[8:0] = SW[8:0];
	
	logic [10:0] x0, y0, x1, y1, x, y;
	logic color;
	
	VGA_framebuffer fb (
		.clk50			(CLOCK_50), 
		.reset			(1'b0), 
		.x, 
		.y,
		.pixel_color	(color), 
		.pixel_write	(1'b1),
		.VGA_R, 
		.VGA_G, 
		.VGA_B, 
		.VGA_CLK, 
		.VGA_HS, 
		.VGA_VS,
		.VGA_BLANK_n	(VGA_BLANK_N), 
		.VGA_SYNC_n		(VGA_SYNC_N));
				
	logic done, init_clear, reset;

	line_drawer lines (.clk(CLOCK_50), .reset(reset), .x0, .y0, .x1, .y1, .x, .y, .done);
	
	logic [31:0] clocks; 

	clock_div cdiv (.clock(CLOCK_50),  
                       .reset(reset),  
                       .div(clocks));
	// controls state
	logic divided_clk; 
	assign divided_clk = clocks[25];
	
	enum {
		CLEAR, 
		LEFT, 
		RIGHT, 
		HORIZONTAL, 
		VERTICAL,
		STEEP, 
		SHALLOW,
		NEGATIVE, 
		POSITIVE
	} ps, ns;
	
	assign reset = (ps == CLEAR);
	
	
	always_ff @(posedge CLOCK_50) begin
		if(reset) begin
			x0 <= 0;
			x1 <= 0;
			y0 <= 0;
			y1 <= SCREEN_HEIGHT;
			ns <= CLEAR;
		end else if(ps == CLEAR) begin
			
			case (ps)
				CLEAR : begin
							color <= 1'b0;
							y0 <= 0;
							y1 <= SCREEN_HEIGHT;
							
							if(x0 < SCREEN_WIDTH) begin
								if(done) begin
									x0 <= x0 + 1;
									x1 <= x1 + 1;
								end
							end 
						end 
				LEFT : begin
							x0 <= BOTTOM_RIGHT_X;
							y0 <= BOTTOM_RIGHT_Y;
							x1 <= TOP_LEFT_X;
							y1 <= TOP_LEFT_Y;
							ns <= RIGHT;
						 end
				RIGHT : begin
							x0 <= ORIGIN_X;
							y0 <= ORIGIN_Y;
							x1 <= MID_X;
							y1 <= MID_Y;
							ns <= NEGATIVE;
						 end
				NEGATIVE : begin
							x0 <= TOP_RIGHT_X;
							y0 <= TOP_RIGHT_Y;
							x1 <= NEAR_LEFT_X;
							y1 <= NEAR_BOTTOM_Y;
							ns <= POSITIVE;
						 end
				POSITIVE : begin
							x0 <= BOTTOM_LEFT_X;
							y0 <= BOTTOM_LEFT_Y;
							x1 <= SMALL_OFFSET_X;
							y1 <= TOP_LEFT_Y;
							ns <= STEEP;
						 end
				STEEP : begin
							x0 <= TOP_LEFT_X;
							y0 <= TOP_LEFT_Y;
							x1 <= NEAR_LEFT_X;
							y1 <= FAR_BOTTOM_Y;
							ns <= SHALLOW;
						 end
				SHALLOW : begin
							x0 <= TOP_LEFT_X;
							y0 <= TOP_LEFT_Y;
							x1 <= FAR_RIGHT_X;
							y1 <= NEAR_TOP_Y;
							ns <= HORIZONTAL;
						 end
				HORIZONTAL : begin
							x0 <= TOP_LEFT_X;
							y0 <= TOP_LEFT_Y;
							x1 <= NEAR_RIGHT_X;
							y1 <= TOP_LEFT_Y;
							ns <= VERTICAL;
						 end
				VERTICAL : begin
							x0 <= TOP_LEFT_X;
							y0 <= TOP_LEFT_Y;
							x1 <= TOP_LEFT_X;
							y1 <= LARGE_OFFSET_Y;
							ns <= LEFT;
						 end
			endcase
			
		end
	
	end
	
	
	always_ff @(posedge divided_clk) begin
		
		if(ps == CLEAR)
			ps <= ns;
		else begin
			ps <= CLEAR;
		end
		
	end
	
	assign LEDR[9] = done;

endmodule  // DE1_SoC