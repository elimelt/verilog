/*
 * controller for bit counter
*/
module bit_counter_ctrl (
  output logic init_res, incr_res, init_A, shiftr_A, done,
  input logic start, clk, reset,
  input logic [7:0] A_curr
);

  // define state names (enum) and variables
  enum {S_IDLE, S_COUNT, S_DONE} ps, ns;

  // controller logic with synchronous reset
  always_ff @(posedge clk)
      ps <= reset ? S_IDLE : ns;

  // next state logic
  always_comb begin
    case (ps)
      S_IDLE:  ns = start           ? S_COUNT : S_IDLE;
      S_COUNT: ns = (A_curr == 0)  ? S_DONE : S_COUNT;
      S_DONE:  ns = S_DONE;
    endcase
  end

  // output assignment
  assign incr_res  = (ps == S_COUNT) & (ns == S_COUNT) & (A_curr[0] == 1);
  assign shiftr_A  = (ps == S_COUNT);
  assign done      = (ps == S_DONE);
  assign init_res  = (ps == S_IDLE);
  assign init_A    = (ps == S_IDLE) & ~start;

endmodule