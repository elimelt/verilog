
/* Top-level module for LandsLand hardware connections to implement the parking lot system.*/

module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, V_GPIO);

  input  logic       	CLOCK_50;    // 50MHz clock
  output logic [6:0] 	HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;    // active low
  output logic [9:0] 	LEDR;
  inout  logic [35:0] 	V_GPIO;    // expansion header 0 (LabsLand board)
  
  logic inc, dec, reset, outer, inner;
  logic [4:0] count;

  assign V_GPIO[26] = outer;
  assign V_GPIO[27] = inner;
  assign outer = V_GPIO[28];
  assign inner = V_GPIO[29];
  assign reset = V_GPIO[30];

  lab1 controller(
		.clk(CLOCK_50),
		.reset(reset),
		.outer(outer),
		.inner(inner),
		.count(count)
	);
  
  
  hex_decoder display_count (
	  .value(count),
	  .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2),
	  .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5)
	);



endmodule  // DE1_SoC