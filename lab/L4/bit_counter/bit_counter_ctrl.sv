module bit_counter_ctrl (
  output logic init_res, incr_res, init_A, shiftr_A, done,
  input logic start, clk, reset,
  input logic [7:0] A_curr
);

  // define state names (enum) and variables
  enum {S1, S2, S3} ps, ns;

  // controller logic with synchronous reset
  always_ff @(posedge clk)
      ps <= reset ? S1 : ns;

  // next state logic
  always_comb begin
    case (ps)
      S1: ns = start          ? S2 : S1;
      S2: ns = (A_curr == 0)  ? S3 : S2;
      S3: ns = start          ? S3 : S1;
    endcase
  end

  // output assignment
  assign incr_res  = (ps == S2) & (ns == S2) & (A_curr[0] == 1);
  assign init_A       = (ps == S1) & (~start);
  assign shiftr_A     = (ps == S2);
  assign done         = (ps == S3);
  assign init_res  = (ps == S1);

endmodule