/* Testbench for DE1_SoC top-level module */
module DE1_SoC_tb();
  logic CLOCK_50;
  logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  logic [9:0] LEDR;
  
  // GPIO pins
  wire [35:0] V_GPIO;
  logic [35:0] V_GPIO_in;
  logic [35:0] V_GPIO_dir;  // 1 = input, 0 = output

  // set up tristate buffers for inout pins
  genvar i;
  generate
      for (i = 0; i < 36; i++) begin : gpio
          assign V_GPIO[i] = V_GPIO_dir[i] ? V_GPIO_in[i] : 1'bZ;
      end
  endgenerate

  // Instantiate dut
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
  integer j;
  // Clock generation
  initial begin
      CLOCK_50 = 0;
      for (j = 0; j < 100; j++) begin
          #(PERIOD/2) CLOCK_50 <= ~CLOCK_50;
      end
  end
  

  initial begin
      // Initialize GPIO direction and input values
      V_GPIO_dir[28] = 1'b1;  // Outer sensor
      V_GPIO_dir[29] = 1'b1;  // Inner sensor
      V_GPIO_dir[30] = 1'b1;  // Reset signal
      V_GPIO_dir[26] = 1'b0;  // Outer sensor input
      V_GPIO_dir[27] = 1'b0;  // Inner sensor input

      V_GPIO_in = 36'b0;

      V_GPIO_in[30] = 1'b1; // Reset
      @(posedge CLOCK_50);

      V_GPIO_in[30] = 1'b0; // Release reset
      @(posedge CLOCK_50);

      V_GPIO_in[28] = 1'b1; // Outer sensor activated
      @(posedge CLOCK_50);

      V_GPIO_in[29] = 1'b1; // Inner sensor activated
      @(posedge CLOCK_50);

      V_GPIO_in[28] = 1'b0; // Outer sensor deactivated
      @(posedge CLOCK_50);

      V_GPIO_in[29] = 1'b0; // Inner sensor deactivated
      @(posedge CLOCK_50);

      V_GPIO_in[29] = 1'b1; // Inner sensor activated again
      @(posedge CLOCK_50);

      V_GPIO_in[28] = 1'b1; // Outer sensor activated again
      @(posedge CLOCK_50);

      V_GPIO_in[29] = 1'b0; // Inner sensor deactivated
      @(posedge CLOCK_50);

      V_GPIO_in[28] = 1'b0; // Outer sensor deactivated
      @(posedge CLOCK_50);

      V_GPIO_in[30] = 1'b1; // Reset the system again
      @(posedge CLOCK_50);
      V_GPIO_in[30] = 1'b0; // Release reset
      @(posedge CLOCK_50);

      $stop;
  end

endmodule