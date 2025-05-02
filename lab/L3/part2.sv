module part2 (CLOCK_50, CLOCK2_50, KEY, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, 
		        AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);
	input CLOCK_50, CLOCK2_50;
	input [0:0] KEY;
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
	// Directly hook up input and output
	/////////////////////////////////
	
//	assign writedata_left = readdata_left;   // Pass audio from left input to left output
//	assign writedata_right = readdata_right; // Pass audio from right input to right output
//	assign read = read_ready;                // Assert read when read_ready is high
//	assign write = read_ready & write_ready; // Only write when both read and write are ready
	
	/////////////////////////////////
	// Instead of reading from input, read directly from audio_data_rom's
	// initial contents, cycling 48,000/sec
	/////////////////////////////////
	
	reg [15:0] address;			// read address for the RAM
	wire [23:0] ram_data;		// RAM data output
	
	// rom we read from, initialized with audio data from mif
	ram audio_data_rom (
		.address(address),
		.clock(CLOCK_50),
		.data(24'd0),      // not writing
		.wren(1'b0),       // only reading
		.q(ram_data)
	);
	
	// RAM data to audio output
	assign writedata_left = ram_data;
	assign writedata_right = ram_data;
	
	// don't read from input anymore
	assign read = 1'b0;
	
	// write when CODEC is ready
	assign write = write_ready;
	
	// update address on write
	always @(posedge CLOCK_50) begin
		if (reset)
			address <= 15'd0;
		else if (write && write_ready) // write when CODEC is ready
			address <= (address == 15'd48000) ? 15'd0 : address + 1'b1; // wrap around
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