
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
    reset <= 0; A <= 8'd5; start <= 1; @(posedge clk);
    repeat (32)  @(posedge clk);
    $stop();
  end
endmodule // binary_search_tb