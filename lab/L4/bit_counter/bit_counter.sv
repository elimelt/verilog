module bit_counter (
  output logic [3:0] result,
  output logic done,
  input logic [7:0] A,
  input logic clk, reset, start
);

  logic [7:0] A_curr;
  logic incr_res, init_res, init_A, shiftr_A;

  bit_counter_datapath dp (.*);
  bit_counter_ctrl ctrl (.*);

endmodule // bit_counter