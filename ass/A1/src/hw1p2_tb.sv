/* Testbench for Homework 1 Problem 2 */
module hw1p2_tb();
    // for you to implement
    logic clk, reset, in;
    logic out;
    integer i;
    
    hw1p2 dut (.clk, .reset, .in, .out);
    
    parameter PERIOD = 10;
    initial begin
        clk = 0;
        for (i = 0; i < 24; i++) begin 
            #(PERIOD/2) clk <= ~clk;
        end   // for
    end    // initial
    initial begin
    
        in <= 0; reset <= 1;   // reset - should go to state ooo
        @(posedge clk);
        
        reset <= 0;            // turn off reset
        @(posedge clk);
        
        // From state ooo with in=0, should go to oii, out=0
        in <= 0;
        @(posedge clk);
        
        // From state oii with in=0, should go to ooi, out=0
        in <= 0;
        @(posedge clk);
        
        // From state ooi with in=0, should stay in ooi, out=0
        in <= 0;
        @(posedge clk);
        
        // From state ooi with in=1, should go to ioo, out=1
        in <= 1;
        @(posedge clk);
        
        // From state ioo with in=0, should go to oio, out=0
        in <= 0;
        @(posedge clk);
        
        // From state oio with in=0, should stay in oio, out=0
        in <= 0;
        @(posedge clk);
        
        // From state oio with in=1, should go to ooo, out=1
        in <= 1;
        @(posedge clk);
        
        // From state ooo with in=1, should go to ioo, out=1
        in <= 1;
        @(posedge clk);
        
        // From state ioo with in=1, should go to oii, out=0
        in <= 1;
        @(posedge clk);
        
        // From state oii with in=1, should go to oio, out=1
        in <= 1;
        @(posedge clk);
        
        // Test reset from arbitrary state
        reset <= 1;   // Should go to ooo
        @(posedge clk);
        
        reset <= 0;
        @(posedge clk);
        
        // From ooo to oii to ooi to ioo
        in <= 0;   // ooo -> oii
        @(posedge clk);
        in <= 0;   // oii -> ooi
        @(posedge clk);
        in <= 1;   // ooi -> ioo, out=1
        @(posedge clk);
        
        // From ioo to oii to oio to ooo
        in <= 1;   // ioo -> oii, out=0
        @(posedge clk);
        in <= 1;   // oii -> oio, out=1
        @(posedge clk);
        in <= 1;   // oio -> ooo, out=1
        @(posedge clk);
		  
		  $stop;   // end the sim
        
    end  // initial
    
endmodule  // hw1p2_tb