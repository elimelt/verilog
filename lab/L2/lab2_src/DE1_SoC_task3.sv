/*
Top-level module for DE1-SoC that instantiates two
different rams (single-port and dual-port)and
maps inputs/outputs to the DE1-SoC board, allowing
user to toggle between the two.
*/
module DE1_SoC_task3 (
    input  logic        CLOCK_50,
    input  logic [3:0]  KEY,
    input  logic [9:0]  SW,
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
    output logic [9:0]  LEDR
);
    logic [4:0]     w_address;   // 5-bit write address
    logic [4:0]     r_address;   // 5-bit read address (controlled by a counter)
    logic [4:0]     ram_address; // address to use with single-port RAM
    logic [2:0]     data_in;     // 3-bit data input
    logic [2:0]     data_out;    // 3-bit data output (currently selected RAM output)
    logic [2:0]     data_out2;   // 3-bit data output from single-port RAM
    logic [2:0]     data_out3;   // 3-bit data output from dual-port RAM
    logic [31:0]    divided;     // clock divider output
    logic           write;       // write enable
    logic           clk;         // hardware clock (CLOCK_50)
    logic           addr_clk;    // address clock from clock divider (to control read address)
    logic           toggle;      // toggle between RAM types
    logic           reset;       // reset signal
    
    // for displaying address in decimal
    logic [3:0]     w_address_tens;
    logic [3:0]     w_address_ones;
    logic [3:0]     r_address_tens;
    logic [3:0]     r_address_ones;
     
    // connect to inputs
    assign data_in   = SW[3:1];  // SW3-SW1 for DataIn
    assign w_address = SW[8:4];  // SW8-SW4 for Write Address
    assign write     = SW[0];    // SW0 for Write signal
    assign toggle    = SW[9];    // SW9 to toggle between dual and single port RAM
    assign reset     = ~KEY[3];  // KEY3 for reset (active low), resets read address to 0
    assign clk       = CLOCK_50; // hardware clock (CLOCK_50)
    
    // select address for single-port RAM
    assign ram_address = write ? w_address : r_address;
    // Select which RAM's output to display based on toggle switch
    assign data_out = toggle ? data_out3 : data_out2;
     
    // get digits for display
    assign w_address_tens = w_address / 10;
    assign w_address_ones = w_address % 10;
    assign r_address_tens = r_address / 10;
    assign r_address_ones = r_address % 10;

	clock_div cd(.clock(CLOCK_50), .reset(reset), .div(divided));
	 
	assign addr_clk = divided[26];
    
    // Single-port RAM (task2)
    ram ram_task2_inst (
        .Address(ram_address),  // Use the selected address
        .DataIn(data_in),
        .Write(write & ~toggle),
        .clk(clk),
        .DataOut(data_out2)
    );
    
    // Dual-port RAM (task3)
    ram32x3port2 ram_task3_inst (
        .clock(clk),
        .data(data_in),
        .rdaddress(r_address),  // Read port always uses counter address
        .wraddress(w_address),  // Write port always uses switch address
        .wren(write & toggle),
        .q(data_out3)
    );
    
    logic [6:0] hex0_out, hex1_out, hex2_out, hex3_out, hex4_out, hex5_out;
    
    seg7 hex5_display (.hex(w_address_tens), .leds(hex5_out));    // write address tens on HEX5
    seg7 hex4_display (.hex(w_address_ones), .leds(hex4_out));    // write address ones on HEX4
    seg7 hex3_display (.hex(r_address_tens), .leds(hex3_out));    // read address tens on HEX3
    seg7 hex2_display (.hex(r_address_ones), .leds(hex2_out));    // read address ones on HEX2
    seg7 hex1_display (.hex({1'b0, data_in}), .leds(hex1_out));   // DataIn on HEX1
    seg7 hex0_display (.hex({1'b0, data_out}), .leds(hex0_out));  // DataOut on HEX0
    
    // assign outputs
    assign HEX0 = hex0_out;
    assign HEX1 = hex1_out;
    assign HEX2 = hex2_out;
    assign HEX3 = hex3_out;
    assign HEX4 = hex4_out;
    assign HEX5 = hex5_out;
    
    // connect LEDR for visual feedback - show correct address based on toggle
    assign LEDR[9:5] = toggle ? (write ? w_address : r_address) : ram_address;
    assign LEDR[4] = write;         // show write signal
    assign LEDR[3:1] = data_in;     // show data input
    assign LEDR[0] = toggle;        // Show toggle state on LED0
	 
    always_ff @(posedge addr_clk) begin
        if (reset) begin
            r_address = 5'b00000; // reset read address to 0
        end else begin
            r_address = r_address + 1'b1; // increment read address
        end
    end // always_ff
    
endmodule //DE1_SoC_task3