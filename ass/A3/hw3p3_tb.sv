/* Testbench for Homework 3 Problem 3 */
module hw3p3_tb;

   logic clk, reset;
   logic X;
   logic Ya, Yb, Yc, Z1, Z2;

   hw3p3 dut (.*);

   parameter PERIOD = 10;
   integer i;
   initial begin
      clk = 0;
      for (i = 0; i < 200; i++) begin
         #(PERIOD/2) clk <= ~clk;
      end
   end

   initial begin
      X <= 0;
      reset <= 1;  //reset 
      @(posedge clk);
      reset <= 0;
      @(posedge clk);

      X <= 1; @(posedge clk); //s0 -> s1
      X <= 1; @(posedge clk); //s1 -> s2
      assert (Z2 == 1 && Z1 == 0 && Ya == 0 && Yb == 0 && Yc == 1); //s2 -> s2
      @(posedge clk);

      X <= 1; @(posedge clk); //s0 -> s1
      X <= 1; @(posedge clk); //s1 -> s2
      X <= 0; #1; //Z1 =  1 but X = 0
      assert (Z1 == 1 && Z2 == 0 && Yc == 1);  // still in S2
      @(posedge clk);

      X <= 1; @(posedge clk); //s0 -> s1
      X <= 0; @(posedge clk); //s1 -> s0
      assert (Z1 == 0 && Z2 == 0 && Ya == 1); // no Z outputs

      repeat (2) begin
         X <= 1; @(posedge clk); //s0 -> s1
         X <= 1; @(posedge clk); //s1 -> s2
         assert (Z2 == 1); //make sure Z2 is on through 2 cycles of consecutive X=1
         @(posedge clk);
      end

      $stop;
   end

endmodule // hw3p3_tb
