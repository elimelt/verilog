module hex_decoder (
  input  logic [4:0] value,
  output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
  );
  always_comb begin
    HEX0 = 7'b1111111;
    HEX1 = 7'b1111111;
    HEX2 = 7'b1111111;
    HEX3 = 7'b1111111;
    HEX4 = 7'b1111111;
    HEX5 = 7'b1111111;
  
    case (value) //7'b6543210
      5'd0: begin HEX5 = 7'b1000110; HEX4 = 7'b1000111; HEX3 = 7'b0000110; HEX2 = 7'b0001000; HEX1 = 7'b0101111; HEX0 = 7'b1000000; end //CLEAr 0
      5'd1: begin HEX0 = 7'b1111001; HEX1 = 7'b1111111; end
      5'd2: begin HEX0 = 7'b0100100; HEX1 = 7'b1111111; end
      5'd3: begin HEX0 = 7'b0110000; HEX1 = 7'b1111111; end
      5'd4: begin HEX0 = 7'b0011001; HEX1 = 7'b1111111; end
      5'd5: begin HEX0 = 7'b0010010; HEX1 = 7'b1111111; end
      5'd6: begin HEX0 = 7'b0000010; HEX1 = 7'b1111111; end
      5'd7: begin HEX0 = 7'b1111000; HEX1 = 7'b1111111; end
      5'd8: begin HEX0 = 7'b0000000; HEX1 = 7'b1111111; end
      5'd9: begin HEX0 = 7'b0010000; HEX1 = 7'b1111111; end
      5'd10: begin HEX1 = 7'b1111001; HEX0 = 7'b1000000; end
      5'd11: begin HEX1 = 7'b1111001; HEX0 = 7'b1111001; end
      5'd12: begin HEX1 = 7'b1111001; HEX0 = 7'b0100100; end
      5'd13: begin HEX1 = 7'b1111001; HEX0 = 7'b0110000; end
      5'd14: begin HEX1 = 7'b1111001; HEX0 = 7'b0011001; end
      5'd15: begin HEX1 = 7'b1111001; HEX0 = 7'b0010010; end
      5'd16: begin HEX5 = 7'b0111000; HEX4 = 7'b1000001; HEX3 = 7'b1110001; HEX2 = 7'b1110001; end //FULL
      default: ;  // blank
    endcase
  end
endmodule
