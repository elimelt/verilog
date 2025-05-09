`timescale 1 ps / 1 ps

module binary_search_tb ();
  logic Found, Done;
  logic [4:0] Loc;
  logic [7:0] A;
  logic clk, reset, start;

  binary_search dut (.*);

  parameter CLOCK_PERIOD = 200;
  initial begin
    clk <= 0;
    forever #(CLOCK_PERIOD/2) clk <= ~clk;
  end

  initial begin
    reset <= 1; @(posedge clk);
    reset <= 0; A <= 8'd15; start <= 1; @(posedge clk);
    repeat (32)  @(posedge clk);
	 reset <= 1; @(posedge clk);
    reset <= 0; A <= 8'd31; start <= 1; @(posedge clk);
    repeat (32)  @(posedge clk);
	 reset <= 1; @(posedge clk);
	 reset <= 0; A <= 8'd0; start <= 1; @(posedge clk);
    repeat (32)  @(posedge clk);
	 reset <= 1; @(posedge clk);
	 reset <= 0; A <= 8'd48; start <= 1; @(posedge clk);
    repeat (32)  @(posedge clk);
    $stop();
  end
endmodule // binary_search_tb