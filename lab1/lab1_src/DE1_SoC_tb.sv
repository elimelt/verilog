/* testbench for DE1_SoC top-level module */
module DE1_SoC_tb();
  logic CLOCK_50;
  logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  logic [9:0] LEDR;
  logic [35:0] V_GPIO;
  integer i;
  
  // instantiate device under test
  DE1_SoC dut (
      .CLOCK_50(CLOCK_50),
      .HEX0(HEX0),
      .HEX1(HEX1),
      .HEX2(HEX2),
      .HEX3(HEX3),
      .HEX4(HEX4),
      .HEX5(HEX5),
      .LEDR(LEDR),
      .V_GPIO(V_GPIO)
  );
  
  parameter PERIOD = 10;
  
  // Generate clock
  initial begin
      CLOCK_50 = 0;
      for (i = 0; i < 100; i++) begin
          #(PERIOD/2) CLOCK_50 <= ~CLOCK_50;
      end
  end  // initial
  
  initial begin
      // Initialize all GPIO and reset
      V_GPIO = 36'b0;
      @(posedge CLOCK_50);

      V_GPIO[30] = 1;  // reset
      @(posedge CLOCK_50);

      V_GPIO[30] = 0;  // reset
      @(posedge CLOCK_50);

      // 1: Car enters
      V_GPIO[28] = 1;  // outer
      @(posedge CLOCK_50);

      V_GPIO[29] = 1;  // inner
      @(posedge CLOCK_50);

      V_GPIO[28] = 0;  // outer
      @(posedge CLOCK_50);

      V_GPIO[29] = 0;  // inner
      @(posedge CLOCK_50);

      // 2: Car exits
      V_GPIO[29] = 1;  // inner
      @(posedge CLOCK_50);

      V_GPIO[28] = 1;  // outer
      @(posedge CLOCK_50);

      V_GPIO[29] = 0;  // inner
      @(posedge CLOCK_50);

      V_GPIO[28] = 0;  // outer
      @(posedge CLOCK_50);

      // 3: Reset everything
      V_GPIO[30] = 1;  // reset
      @(posedge CLOCK_50);
      V_GPIO[30] = 0;  // reset
      @(posedge CLOCK_50);

      // End simulation
      $stop;
  end  // initial

endmodule  // DE1_SoC_tb