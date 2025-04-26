/* Arbitrary ASM chart implementation to examine output timings */
module hw3p3 (
    input  logic clk,
    input  logic reset,
    input  logic X,
    output logic Ya, Yb, Yc,
    output logic Z1, Z2);
	
	 typedef enum logic [1:0] { S0, S1, S2 } state_t; //three states

    state_t ps, ns;  //ps and ns according to assignment spec
	 
	  always_ff @(posedge clk) begin //reset 
        if (reset)  ps <= S0;
        else        ps <= ns;
     end
	  
	  always_comb begin
	      ns = ps;
			Z1 = 1'b0;
			Z2 = 1'b0;
			
			case(ps) 
			   S0: begin
				    ns = X ? S1 : S0;
					 end
				S1: begin
				    ns = X ? S2 : S0;
					 end		
				S2 : begin
                 if (X) begin
                     Z2 = 1'b1;   
                 end
                 else begin
                     Z1 = 1'b1;
                 end
                 ns = S0;         
            end
		  endcase
	  end
	  assign Ya = (ps == S0);
	  assign Yb = (ps == S1);
	  assign Yc = (ps == S2);
	
endmodule  // hw3p3
