/* Testbench for lab1 module */
module lab1_tb();
  logic clk;
  logic reset;
  logic outer, inner;
  logic [4:0] count;
  
  lab1 dut (
    .clk(clk),
    .reset(reset),
    .outer(outer),
    .inner(inner),
    .count(count)
  );
  
  parameter PERIOD = 10;
  
  // Generate clock
  initial begin
    clk = 0;
    forever #(PERIOD/2) clk = ~clk;
  end
  
  initial begin
    // Initialize and reset
    outer = 0; inner = 0; reset = 1;
    @(posedge clk);
    
    reset = 0;
    @(posedge clk);
    
    // Test Case 1: Car enters
    // IDLE -> ENTER_OUTER
    outer = 1; inner = 0;
    @(posedge clk);
    
    // ENTER_OUTER -> ENTER_BOTH
    outer = 1; inner = 1;
    @(posedge clk);
    
    // ENTER_BOTH -> ENTER_INNER (inc should be asserted)
    outer = 0; inner = 1;
    @(posedge clk);
    
    // ENTER_INNER -> IDLE
    outer = 0; inner = 0;
    @(posedge clk);
    
    assert (count == 5'd1);
    @(posedge clk);
    
    // Test Case 2: Car exits
    // IDLE -> EXIT_INNER
    outer = 0; inner = 1;
    @(posedge clk);
    
    // EXIT_INNER -> EXIT_BOTH
    outer = 1; inner = 1;
    @(posedge clk);
    
    // EXIT_BOTH -> EXIT_OUTER
    outer = 1; inner = 0;
    @(posedge clk);
    
    // EXIT_OUTER -> IDLE
    outer = 0; inner = 0;
    @(posedge clk);
    
    assert(count == 5'd0);
    @(posedge clk);
    
    // Test Case 3: Multiple cars enter
    // First car
    outer = 1; inner = 0;
    @(posedge clk);
    outer = 1; inner = 1;
    @(posedge clk);
    outer = 0; inner = 1;
    @(posedge clk);
    outer = 0; inner = 0;
    @(posedge clk);
    
    // Second car
    outer = 1; inner = 0;
    @(posedge clk);
    outer = 1; inner = 1;
    @(posedge clk);
    outer = 0; inner = 1;
    @(posedge clk);
    outer = 0; inner = 0;
    @(posedge clk);
    
    assert(count == 5'd2);
    @(posedge clk);
    
    // Test Case 4: Pedestrian enters (should not count)
    // IDLE -> ENTER_OUTER
    outer = 1; inner = 0;
    @(posedge clk);
    
    // ENTER_OUTER -> ENTER_INNER (skipping ENTER_BOTH)
    outer = 0; inner = 1;
    @(posedge clk);
    
    // ENTER_INNER -> IDLE
    outer = 0; inner = 0;
    @(posedge clk);
    
    assert(count == 5'd2);
    @(posedge clk);
    
    // Test Case 5: Pedestrian exits (should not count)
    // IDLE -> EXIT_INNER
    outer = 0; inner = 1;
    @(posedge clk);
    
    // EXIT_INNER -> EXIT_OUTER (skipping EXIT_BOTH)
    outer = 1; inner = 0;
    @(posedge clk);
    
    // EXIT_OUTER -> IDLE
    outer = 0; inner = 0;
    @(posedge clk);
    
    // Check count value (should still be 2)
    assert(count == 5'd2);
    @(posedge clk);
    
    // Test Case 6: Reset functionality
    reset = 1;
    @(posedge clk);
    reset = 0;
    @(posedge clk);
    
    assert(count == 5'd0);
    @(posedge clk);
    
    // Test Case 7: count hits maximum
    // Add cars until count reaches 16 (max)
    repeat (31) begin
      // Car enters
      outer = 1; inner = 0;
      @(posedge clk);
      outer = 1; inner = 1;
      @(posedge clk);
      outer = 0; inner = 1;
      @(posedge clk);
      outer = 0; inner = 0;
      @(posedge clk);
    end
    
    assert(count == 5'd16);
    @(posedge clk);
    
    // Try to add one more car (should stay at 16)
    outer = 1; inner = 0;
    @(posedge clk);
    outer = 1; inner = 1;
    @(posedge clk);
    outer = 0; inner = 1;
    @(posedge clk);
    outer = 0; inner = 0;
    @(posedge clk);
    
    assert(count == 5'd16);
    @(posedge clk);
    
    $stop;
  end
  
endmodule  // lab1_tb