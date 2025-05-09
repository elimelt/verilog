`timescale 1 ps / 1 ps

module binary_search (
  output logic Found, Done,
  output logic [4:0] Loc,
  input logic [7:0] A,
  input logic clk, reset, start
);

  logic [7:0] curr_data;
  logic [4:0] L, R, M;

  // control signals
  logic load_regs, set_Addr, set_L, set_R, set_Found, set_Done;

  binary_search_ctrl C (.*);
  binary_search_datapath D (.*);

  ram32x8 RAM (
    .q(curr_data),
    .address(M),
    .clock(clk),
    .data(),
    .wren(1'b0)
  );

endmodule // binary_search
