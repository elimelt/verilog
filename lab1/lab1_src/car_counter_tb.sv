/* testbench for car_counter */
module car_counter_tb();
  // define signals
  logic clk;
  logic reset;
  logic incr;
  logic decr;
  logic [4:0] count;
  
  // instantiate dut
  car_counter dut (
    .clk(clk),
    .reset(reset),
    .incr(incr),
    .decr(decr),
    .count(count)
  );
  
  // clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  initial begin
    // initialize/reset
    reset = 1;
    incr = 0;
    decr = 0;
    @(posedge clk);
    
    reset = 0;
    @(posedge clk);
    
    // increment once
    incr = 1;
    decr = 0;
    @(posedge clk);
    
    // no change
    incr = 0;
    decr = 0;
    @(posedge clk);
    
    // increment again
    incr = 1;
    decr = 0;
    @(posedge clk);
    
    // decrement once
    incr = 0;
    decr = 1;
    @(posedge clk);
    
    // try both signals active (should not change)
    incr = 1;
    decr = 1;
    @(posedge clk);
    
    // reset while counting
    reset = 1;
    @(posedge clk);
    
    // test counter limits
    reset = 0;
    incr = 0;
    decr = 0;
    @(posedge clk);
    
    // count up to max
    incr = 1;
    decr = 0;
    repeat(16) @(posedge clk);
    
    // try to go past 16
    incr = 1;
    decr = 0;
    repeat(5) @(posedge clk);
    
    // count back down to zero
    incr = 0;
    decr = 1;
    repeat(16) @(posedge clk);
    
    // try to go below zero
    incr = 0;
    decr = 1;
    repeat(5) @(posedge clk);
    
    $stop;
  end  // initial
  
endmodule  // car_counter_tb