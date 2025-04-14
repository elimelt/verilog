/* testbench for hex_decoder */
module hex_decoder_tb();
  // define signals
  logic [4:0] value;
  logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  
  // instantiate dut
  hex_decoder dut (
    .value(value),
    .HEX0(HEX0),
    .HEX1(HEX1),
    .HEX2(HEX2),
    .HEX3(HEX3),
    .HEX4(HEX4),
    .HEX5(HEX5)
  );
  
  // test all possible inputs
  initial begin
    // clear
    value = 5'd0;
    #10;
    
    value = 5'd1;
    #10;
    
    value = 5'd2;
    #10;
    
    value = 5'd3;
    #10;
    
    value = 5'd4;
    #10;
    
    value = 5'd5;
    #10;
    
    value = 5'd6;
    #10;
    
    value = 5'd7;
    #10;
    
    value = 5'd8;
    #10;
    
    value = 5'd9;
    #10;
    
    value = 5'd10;
    #10;
    
    value = 5'd11;
    #10;
    
    value = 5'd12;
    #10;
    
    value = 5'd13;
    #10;
    
    value = 5'd14;
    #10;
    
    value = 5'd15;
    #10;
    
    // full
    value = 5'd16;
    #10;
    
    // default case
    value = 5'd17;
    #10;
    
    $stop;
  end  // initial
  
endmodule  // hex_decoder_tb