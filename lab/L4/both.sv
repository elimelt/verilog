module both (
  input  logic        CLOCK_50,    // 50MHz clock
  input  logic [9:0]  SW,          // Slide switches
  input  logic [3:0]  KEY,         // Push buttons (active low)
  output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,  // 7-segment displays
  output logic [9:0]  LEDR         // LEDs (active high)
);
  
  // Signal declarations
  logic [3:0] bit_count_result;  // Result of bit counter
  logic bit_count_done;          // Bit counter done signal
  
  logic [4:0] bs_loc;            // Binary search location result
  logic bs_found, bs_done;       // Binary search status signals
  
  logic reset, start;            // Control signals
  logic mode;                    // Mode select
  
  assign reset = ~KEY[0];
  assign start = ~KEY[3];
  assign mode = SW[9];
  
  bit_counter counter (
    .result(bit_count_result),
    .done(bit_count_done),
    .A(SW[7:0]),
    .clk(CLOCK_50),
    .reset(reset),
    .start(start)
  );
  
  binary_search bs (
    .Found(bs_found),
    .Done(bs_done),
    .Loc(bs_loc),
    .A(SW[7:0]),
    .clk(CLOCK_50),
    .reset(reset),
    .start(start)
  );
  
  logic [6:0] hex0_val, hex1_val;
  logic [9:0] ledr_val;
  
  always_comb begin
    hex0_val = 7'b1111111;
    hex1_val = 7'b1111111;
    ledr_val = 10'b0000000000;
    
    if (mode == 1'b0) begin

      // Display bit count result on HEX0
      hex0_val = (bit_count_result == 4'h0 && !bit_count_done) ? 7'b1111111 :
                 (bit_count_result == 4'h0) ? 7'b1000000 :
                 (bit_count_result == 4'h1) ? 7'b1111001 :
                 (bit_count_result == 4'h2) ? 7'b0100100 :
                 (bit_count_result == 4'h3) ? 7'b0110000 :
                 (bit_count_result == 4'h4) ? 7'b0011001 :
                 (bit_count_result == 4'h5) ? 7'b0010010 :
                 (bit_count_result == 4'h6) ? 7'b0000010 :
                 (bit_count_result == 4'h7) ? 7'b1111000 :
                 (bit_count_result == 4'h8) ? 7'b0000000 : 7'b0010000;
      
      // Turn off HEX1 for bit counter mode
      hex1_val = 7'b1111111;
      
      // Show done status on LEDR9
      ledr_val = {bit_count_done, 9'b0};
    end else begin
      // Binary Search Mode
      // Display location on HEX1:HEX0
      // HEX0 displays lower 4 bits
      hex0_val = (bs_loc[3:0] == 4'h0 && !bs_done) ? 7'b1111111 :
                 (bs_loc[3:0] == 4'h0) ? 7'b1000000 :
                 (bs_loc[3:0] == 4'h1) ? 7'b1111001 :
                 (bs_loc[3:0] == 4'h2) ? 7'b0100100 :
                 (bs_loc[3:0] == 4'h3) ? 7'b0110000 :
                 (bs_loc[3:0] == 4'h4) ? 7'b0011001 :
                 (bs_loc[3:0] == 4'h5) ? 7'b0010010 :
                 (bs_loc[3:0] == 4'h6) ? 7'b0000010 :
                 (bs_loc[3:0] == 4'h7) ? 7'b1111000 :
                 (bs_loc[3:0] == 4'h8) ? 7'b0000000 :
                 (bs_loc[3:0] == 4'h9) ? 7'b0010000 :
                 (bs_loc[3:0] == 4'hA) ? 7'b0001000 :
                 (bs_loc[3:0] == 4'hB) ? 7'b0000011 :
                 (bs_loc[3:0] == 4'hC) ? 7'b1000110 :
                 (bs_loc[3:0] == 4'hD) ? 7'b0100001 :
                 (bs_loc[3:0] == 4'hE) ? 7'b0000110 : 7'b0001110;
      
      // HEX1 displays upper bit (bit 4) of the location
      hex1_val = (bs_loc[4] == 1'b0 && !bs_done) ? 7'b1111111 :
                 (bs_loc[4] == 1'b0) ? 7'b1000000 : 7'b1111001;
      
      // Show done status on LEDR9 and found status on LEDR0
      ledr_val = {bs_done, 8'b0, bs_found};
    end
  end
  
  assign HEX0 = hex0_val;
  assign HEX1 = hex1_val;
  
  // unused
  assign HEX2 = 7'b1111111;
  assign HEX3 = 7'b1111111;
  assign HEX4 = 7'b1111111;
  assign HEX5 = 7'b1111111;
  
  assign LEDR = ledr_val;
  
endmodule  // DE1_SoC