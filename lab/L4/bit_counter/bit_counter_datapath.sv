/*
 * datapath for bit counter
*/
module bit_counter_datapath (
  output logic [7:0] A_curr,
  output logic [3:0] result,
  input logic init_res, incr_res, init_A, shiftr_A, done,
  input logic [7:0] A,
  input logic clk
);

  // datapath logic
  always_ff @(posedge clk) begin
    if (init_A)
      A_curr <= A;
    if (init_res)
      result <= 0;
    if (incr_res)
      result <= result + 4'd1;
    if (shiftr_A)
      A_curr <= A_curr >> 8'b1;
  end
endmodule // bit_counter_datapath