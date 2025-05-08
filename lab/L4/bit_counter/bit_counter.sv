module bit_counter (
  output logic [3:0] result,
  output logic done,
  input logic [7:0] A,
  input logic clk, reset, start
);

  logic incr_res, init_res, init_A, shiftr_A;
  logic [7:0] A_curr;

  bit_counter_datapath D (.*);
  bit_counter_ctrl C (.*);

endmodule // bit_counter