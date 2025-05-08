
module bit_counter_tb ();
  logic [3:0] result;
  logic [7:0] A;
  logic clk, reset, start, done;

  bit_counter dut (.*);

  parameter CLOCK_PERIOD = 200;

  initial begin
    clk <= 0;
    forever #(CLOCK_PERIOD / 2) clk <= ~clk;
  end

  initial begin
    reset <= 1;                                 @(posedge clk);
    start <= 0; reset <= 0; A <= 8'b1010_1010;  @(posedge clk);
    start <= 1;                                 @(posedge clk);
    repeat(10)                                  @(posedge clk);
    $stop();
  end
endmodule // bit_counter_tb