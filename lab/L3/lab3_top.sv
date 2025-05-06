module lab3_top
(   input  CLOCK_50, CLOCK2_50,
    input  [9:0] SW,
    input  [3:0] KEY,
    output FPGA_I2C_SCLK, inout FPGA_I2C_SDAT,
    output AUD_XCK,
    input  AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK,
    input  AUD_ADCDAT,  output AUD_DACDAT
);

    wire reset = ~KEY[0];
    wire read_ready, write_ready, read, write;
	 wire [23:0] readdata_left, readdata_right;
    wire [23:0] writedata_left, writedata_right;

    wire signed [23:0] din_left  = readdata_left;
	 wire signed [23:0] din_right = readdata_right;
	 wire signed [23:0] dout_left, dout_right;

	 part3 #(.LOG2_N(3)) fir ( .* ); //instantiating filter module
	 
	 //switch logic to go between filtered and unfiltered audio
    wire signed [23:0] out_left  = SW[8] ? dout_left  : din_left;
    wire signed [23:0] out_right = SW[8] ? dout_right : din_right;
	 
	 //switch logic to use task 2 functionality
	 assign read = SW[9] ? 1'b0 : read_ready;
	 
    assign write = (SW[9] ? write_ready : (read_ready & write_ready));
	 


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

endmodule