module part2 (
  input  logic        CLOCK_50,    
  input  logic [7:0]  SW,          
  input  logic [3:0]  KEY,         
  output logic [6:0]  HEX0, HEX1,  
  output logic [9:0]  LEDR  
);
  
  logic [4:0] Loc;      
  logic Found, Done;     
  logic reset, start;    
  
  // reset active low
  assign reset = ~KEY[0];
  // start active low
  assign start = ~KEY[3];
  
  binary_search bs (
    .Found(Found),
    .Done(Done),
    .Loc(Loc),
    .A(SW[7:0]),
    .clk(CLOCK_50),
    .reset(reset), 
    .start(start)
  );
  
  // upper digit 
  seg7 hex0_display (
    .hex(Loc[3:0]),
    .leds(HEX0)
  );
  
  // lower digit
  seg7 hex1_display (
    .hex({3'b000, Loc[4]}),
    .leds(HEX1)
  );
  
  // unused
  assign HEX2 = 7'b1111111;
  assign HEX3 = 7'b1111111;
  assign HEX4 = 7'b1111111;
  assign HEX5 = 7'b1111111;
  
  // status signals
  assign LEDR[9] = Done; 
  assign LEDR[0] = Found;
  assign LEDR[8:1] = SW[7:0];
  
endmodule  // part2