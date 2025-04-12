module car_counter (
  input logic clk, 
  input logic reset,
  input logic incr,
  input logic decr,
  output logic [4:0] count
);
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      count <= 5'b00000;
    end else begin
      if (incr && count < 5'b10000 && !decr) begin
        count <= count + 1;
      end else if (decr && count > 5'b00000 && !incr) begin
        count <= count - 1;
      end
      // No change if both or neither incr/decr
    end
  end
endmodule