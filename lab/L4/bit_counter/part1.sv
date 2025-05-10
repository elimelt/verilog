module part1 (
  input  logic        CLOCK_50,    
  input  logic [7:0]  SW,          
  input  logic [3:0]  KEY,  
  output logic [6:0]  HEX0, 
  output logic [9:0]  LEDR         
);

  logic [31:0] div;
  clock_div(CLOCK_50, reset, div);
  logic clk;
  assign clk = div[25];
  
  logic [3:0] result;
  logic done;           
  logic reset, start;   
  
  // reset active low
  assign reset = ~KEY[0];
  // start active low
  assign start = ~KEY[3];
  assign LEDR[9] = done;
  assign LEDR[7:0] = SW[7:0];
  
  // SW to A (8-bit)
  bit_counter counter (
    .result(result),
    .done(done),
    .A(SW[7:0]),
    .clk(clk),
    .reset(reset),
    .start(start)
  );
  
  
  // unused
  assign HEX1 = 7'b1111111;
  assign HEX2 = 7'b1111111;
  assign HEX3 = 7'b1111111;
  assign HEX4 = 7'b1111111;
  assign HEX5 = 7'b1111111;
  
  // counter to HEX0
  seg7 hex_display (
    .hex(result),
    .leds(HEX0)
  );
  
  
endmodule  // part1