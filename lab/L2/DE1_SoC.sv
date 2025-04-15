/*
Top-level module for DE1-SoC that instantiates ram and maps
inputs/outputs to the DE1-SoC board.
*/
module DE1_SoC (
    input  logic        CLOCK_50,
    input  logic [3:0]  KEY,
    input  logic [9:0]  SW,
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
    output logic [9:0]  LEDR
);
    // signal declarations
    logic [4:0] address;     // 5-bit address
    logic [2:0] data_in;     // 3-bit data input
    logic [2:0] data_out;    // 3-bit data output
    logic       write;       // write enable
    logic       clk;         // clock from KEY0
    
    // for displaying address in decimal on HEX5 and HEX4
    logic [3:0] address_tens;
    logic [3:0] address_ones;

    // connect switches to inputs
    assign data_in = SW[3:1];    // SW3-SW1 for DataIn
    assign address = SW[8:4];    // SW8-SW4 for Address
    assign write = SW[0];        // SW0 for Write signal
    assign clk = ~KEY[0];        // KEY0 for Clock (active low to active high)
    
    // get digits for display
    assign address_tens = address / 10;
    assign address_ones = address % 10;

    // instantiate ram module
    ram ram_inst (
        .Address(address),
        .DataIn(data_in),
        .Write(write),
        .clk(clk),
        .DataOut(data_out)
    );
    
    logic [6:0] hex0_out, hex1_out, hex4_out, hex5_out;
    
    seg7 hex5_display (.hex(address_tens), .leds(hex5_out));        // address on HEX5
    seg7 hex4_display (.hex(address_ones), .leds(hex4_out));        // and HEX4
    seg7 hex1_display (.hex({1'b0, data_in}), .leds(hex1_out));     // DataIn on HEX1
    seg7 hex0_display (.hex({1'b0, data_out}), .leds(hex0_out));    // DataOut on HEX0
    
    // assign outputs
    assign HEX0 = hex0_out;
    assign HEX1 = hex1_out;
    assign HEX2 = 7'b1111111;  // off
    assign HEX3 = 7'b1111111;  // off
    assign HEX4 = hex4_out;
    assign HEX5 = hex5_out;
    
    // connect LEDR for visual feedback
    assign LEDR[9:5] = address;  // show address on LEDs
    assign LEDR[4] = write;      // show write signal
    assign LEDR[3:1] = data_in;  // show data input
    assign LEDR[0] = clk;        // show clock
    
endmodule