module part2 (CLOCK_50, CLOCK2_50, KEY, SW, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK,
		        AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);
	input CLOCK_50, CLOCK2_50;
	input [0:0] KEY;
	input [9:0] SW;
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	// Local wires.
	wire read_ready, write_ready, read, write;
	wire [23:0] readdata_left, readdata_right;
	wire [23:0] writedata_left, writedata_right;
	wire reset = ~KEY[0];
	/////////////////////////////////
	// Combined part 1 and part 2 functionality
	/////////////////////////////////

	// ram data
	reg [15:0] address;
	wire [23:0] ram_data;

	ram audio_data_rom (
		.address(address),
		.clock(CLOCK_50),
		.data(24'd0),      // not writing
		.wren(1'b0),       // only reading
		.q(ram_data)
	);

	// toggle mode with SW[9].
	// when SW[9] is high, use ram_data as input to CODEC
	// when SW[9] is low, use audio input from CODEC
	assign writedata_left 	= SW[9] ? ram_data 		: readdata_left;
	assign writedata_right 	= SW[9] ? ram_data 		: readdata_right;
	assign read 						= SW[9] ? 1'b0 				: read_ready;
	assign write 						= SW[9] ? write_ready  : (read_ready & write_ready);

	// update address on write
	always @(posedge CLOCK_50) begin
		if (reset)
			address <= 16'd0;
		else if (SW[9] && write && write_ready) // write when CODEC is ready
			address <= (address == 16'd48000) ? 16'd0 : address + 1'b1; // wrap around
	end
/////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface. 
//
// The interface consists of the following wires:
// read_ready, write_ready - CODEC ready for read/write operation 
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		reset,
		// outputs
		AUD_XCK
	);
	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		reset,
		// Bidirectionals
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);
	audio_codec codec(
		// Inputs
		CLOCK_50,
		reset,
		read,	write,
		writedata_left, writedata_right,
		AUD_ADCDAT,
		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,
		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);
endmodule // part2