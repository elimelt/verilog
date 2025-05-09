module binary_search_datapath (
  output logic [4:0] L, R, Loc, M,
  output logic Found, Done,
  input logic load_regs, set_Addr, set_L, set_R, set_Found, set_Done,
  input logic clk
);

  assign M = (L + R) / 2;

  always_ff @(posedge clk) begin
    if (load_regs) begin
      L <= 5'd0;
      R <= 5'd31;
      Loc <= 5'd0;
      Done <= 0;
      Found <= 0;
    end
    else begin // metastability?
      if (set_Addr) Loc <= M;
      if (set_L) L <= M + 1;
      if (set_R) R <= M - 1;
      if (set_Found) Found <= 1;
      if (set_Done) Done <= 1;
    end
  end
endmodule // binary_search_datapath