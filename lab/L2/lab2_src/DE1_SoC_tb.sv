`timescale 1 ps / 1 ps
/* Testbench for DE1_SoC top level module */
module DE1_SoC_tb();
    // test inputs
    logic        CLOCK_50;
    logic [3:0]  KEY;
    logic [9:0]  SW;
    
    // test outputs
    logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    logic [9:0]  LEDR;
    
    // instantiate the design under test
    DE1_SoC dut(
        .CLOCK_50(CLOCK_50),
        .KEY(KEY),
        .SW(SW),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5),
        .LEDR(LEDR)
    );
    
    // clock generation
    parameter PERIOD = 10;
    initial begin
        CLOCK_50 = 0;
        repeat(20) #(PERIOD/2) CLOCK_50 = ~CLOCK_50;
    end
    
    initial begin
        // initialize inputs
        KEY = 4'b1111;  // all buttons unpressed
        SW = 10'b0000000000;  // all switches off
        
        // wait a few clock cycles
        @(posedge CLOCK_50);
        @(posedge CLOCK_50);
        
        // test case 1: write data 3'b101 to address 5'b00011
        SW[8:4] = 5'b00011;  // set address to 3
        SW[3:1] = 3'b101;    // set data to 5
        SW[0] = 1'b1;        // enable write
        @(posedge CLOCK_50);
        
        // trigger clock
        KEY[0] = 1'b0;
        @(posedge CLOCK_50);
        
        KEY[0] = 1'b1;
        @(posedge CLOCK_50);
        
        // disable write
        SW[0] = 1'b0;
        @(posedge CLOCK_50);
        
        // test case 2: read from address 5'b00011
        @(posedge CLOCK_50);
        
        // trigger clock
        KEY[0] = 1'b0;
        @(posedge CLOCK_50);
        
        KEY[0] = 1'b1;
        @(posedge CLOCK_50);
        
        // test case 3: write data 3'b111 to address 5'b10101
        SW[8:4] = 5'b10101;  // set address to 21
        SW[3:1] = 3'b111;    // set data to 7
        SW[0] = 1'b1;        // enable write
        @(posedge CLOCK_50);
        
        // trigger clock
        KEY[0] = 1'b0;
        @(posedge CLOCK_50);
        
        KEY[0] = 1'b1;
        @(posedge CLOCK_50);
        
        // test case 4: read from address 5'b10101
        SW[0] = 1'b0;        // disable write
        @(posedge CLOCK_50);
        
        // trigger clock
        KEY[0] = 1'b0;
        @(posedge CLOCK_50);
        
        KEY[0] = 1'b1;
        @(posedge CLOCK_50);

        $stop;
    end
    
endmodule