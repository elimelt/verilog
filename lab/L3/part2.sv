module part2 (CLOCK_50, CLOCK2_50, KEY, SW, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, 
                    AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);
    input CLOCK_50, CLOCK2_50;
    input [0:0] KEY;
    input [9:0] SW;           // Added switch input
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
    // Combined code for both modes
    /////////////////////////////////
    
    // Define address counter and RAM interface signals
    reg [6:0] address;
    wire [23:0] ram_data;
    
    // RAM module instantiation
    ram audio_data_rom (
        .address(address),
        .clock(CLOCK_50),
        .data(24'd0),      // Not writing, so data input doesn't matter
        .wren(1'b0),       // We're only reading from the RAM
        .q(ram_data)
    );
    
    // Switch between modes based on SW[9]
    assign writedata_left = SW[9] ? readdata_left : ram_data;
    assign writedata_right = SW[9] ? readdata_right : ram_data;
    
    // Control read signal based on mode
    assign read = SW[9] ? read_ready : 1'b0;
    
    // Write when ready (with appropriate conditions for each mode)
    assign write = SW[9] ? (read_ready & write_ready) : write_ready;
    
    // Update RAM address counter when in memory mode and writing
    always @(posedge CLOCK_50) begin
        if (reset)
            address <= 7'd0;
        else if (!SW[9] && write && write_ready)  // Only increment when in memory mode and writing
            address <= (address == 7'd127) ? 7'd0 : address + 7'd1;  // Loop back to start
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
        read,    write,
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