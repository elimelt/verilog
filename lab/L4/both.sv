module both (
  input  logic        CLOCK_50,
  input  logic [9:0]  SW,
  input  logic [3:0]  KEY,
  output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
  output logic [9:0]  LEDR
);
  
  logic [31:0] div;
  clock_div(CLOCK_50, reset, div);
  logic clk;
  assign clk = div[15];

  logic [3:0] bit_count_result;
  logic bit_count_done;
  
  logic [4:0] bs_loc;
  logic bs_found, bs_done;
  
  logic reset, start;
  logic mode;
  
  assign reset = ~KEY[0];
  assign start = ~KEY[3];
  assign mode = SW[9];
  
  bit_counter counter (
    .result(bit_count_result),
    .done(bit_count_done),
    .A(SW[7:0]),
    .clk(clk),
    .reset(reset),
    .start(start)
  );
  
  binary_search bs (
    .Found(bs_found),
    .Done(bs_done),
    .Loc(bs_loc),
    .A(SW[7:0]),
    .clk(clk),
    .reset(reset),
    .start(start)
  );
  
  logic [3:0] hex0_val, hex1_val;
  logic [9:0] ledr_val;
  
  always_comb begin
    hex0_val = 4'b0000;
    hex1_val = 4'b0000;
    ledr_val = 10'b0000000000;
    
    if (mode == 1'b0) begin
      // Bit Counter Mode
      hex0_val = bit_count_result;
      
      ledr_val = {bit_count_done, 9'b0};
    end else begin
      // Binary Search Mode
      hex0_val = bs_loc % 10;
      hex1_val = bs_loc / 10;
      ledr_val = {bs_done, 8'b0, bs_found};
    end
  end
  
  seg7 hex0_display (
    .hex(hex0_val),
    .leds(HEX0)
  );
  
  seg7 hex1_display (
    .hex(hex1_val),
    .leds(HEX1)
  );

  // unused
  assign HEX2 = 7'b1111111;
  assign HEX3 = 7'b1111111;
  assign HEX4 = 7'b1111111;
  assign HEX5 = 7'b1111111;
  
  assign LEDR = ledr_val;
  
endmodule  // both