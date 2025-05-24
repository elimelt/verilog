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

	// Static display values
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	assign LEDR[8:0] = SW[8:0];

	// Coordinates and pixel control
	logic [10:0] x, y;
	logic done, start;
	logic [10:0] x0, y0, x1, y1;
	assign x0 = 11'd10;
	assign y0 = 11'd200;
	assign x1 = 11'd10;
	assign y1 = 11'd10;

	// Pulse start signal when KEY[0] is pressed
	always_ff @(posedge CLOCK_50) begin
		start <= ~KEY[0];
	end

	// Line drawer instance
	line_drawer lines (
		.clk    (CLOCK_50),
		.reset  (start), // re-triggers line drawing on button press
		.x0     (x0),
		.y0     (y0),
		.x1     (x1),
		.y1     (y1),
		.x      (x),
		.y      (y),
		.done   (done)
	);

	// Drive LED to show done
	assign LEDR[9] = done;

	// VGA framebuffer instance: pulse write on every pixel update
	logic pixel_write;
	always_ff @(posedge CLOCK_50) begin
		if (!done)
			pixel_write <= 1'b1;
		else
			pixel_write <= 1'b0;
	end

	VGA_framebuffer fb (
		.clk50        (CLOCK_50),
		.reset        (1'b0),
		.x            (x),
		.y            (y),
		.pixel_color  (1'b1),
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

endmodule
