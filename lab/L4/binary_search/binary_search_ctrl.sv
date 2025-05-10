module binary_search_ctrl (
  output logic load_regs, set_Addr, set_L, set_R, set_Found, set_Done,
  input logic [4:0] L, R,
  input logic [7:0] A,
  input logic [7:0] curr_data,
  input logic clk, reset, start
);
  // define state names (enum) and variables
  enum { S_IDLE, S_LOOP_RANGE_CHECK, S_COMPARE, S_DONE } ps, ns;

  // controller logic with synchronous reset
  always_ff @(posedge clk)
    ps <= reset ? S_IDLE : ns;

  // next state logic
  always_comb
    case (ps)
      S_IDLE:             ns = start       ? S_LOOP_RANGE_CHECK : S_IDLE;
      S_LOOP_RANGE_CHECK: ns =
			  (L > R || (L == R && curr_data != A))   ? S_DONE : S_COMPARE;
      S_COMPARE:          ns = (curr_data == A) ? S_DONE : S_LOOP_RANGE_CHECK;
      S_DONE:             ns = start ? S_DONE : S_IDLE;
    endcase

  // output assignment
  assign load_regs  = (ps == S_IDLE) & (start || reset);
  assign set_Done   = (ps == S_DONE);
  assign set_Addr   = (ps == S_LOOP_RANGE_CHECK);
  assign set_L      = (ps == S_LOOP_RANGE_CHECK) & (curr_data < A);
  assign set_R      = (ps == S_LOOP_RANGE_CHECK) & (curr_data > A);
  assign set_Found  = (ps == S_LOOP_RANGE_CHECK) & (curr_data == A);

endmodule // binary_search_ctrl

