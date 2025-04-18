`timescale 1 ps / 1 ps
/* Testbench for task1 */
module task1_tb();
    logic [4:0] Address;
    logic [2:0] DataIn;
    logic       Write;
    logic       clk;
    logic [2:0] DataOut;
    integer i;
    
    // constants
    localparam [2:0] DATA0 = 3'b101;
    localparam [2:0] DATA1 = 3'b110;
    localparam [2:0] DATA16 = 3'b011;
    localparam [2:0] DATA31 = 3'b111;
    
    localparam [4:0] ADDR0 = 5'b00000;
    localparam [4:0] ADDR1 = 5'b00001;
    localparam [4:0] ADDR16 = 5'b10000;
    localparam [4:0] ADDR31 = 5'b11111;
    
    // create dut
    ram dut (.Address, .DataIn, .Write, .clk, .DataOut);
    
    // create clock
    parameter PERIOD = 10;
    initial begin
        clk = 0;
        for (i = 0; i < 200; i++) begin 
            #(PERIOD/2) clk <= ~clk;
        end
    end
    
    initial begin
        // init inputs
        Address <= 0;
        DataIn <= 0;
        Write <= 0;
        @(posedge clk);
        
        // test 1: write to address 0 and read back
        Address <= ADDR0;
        DataIn <= DATA0;
        Write <= 1;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        
        Write <= 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        $display("address 0: wrote %b, read %b", DATA0, DataOut);
        
        // test 2: write to address 1 and read back
        Address <= ADDR1;
        DataIn <= DATA1;
        Write <= 1;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        
        Write <= 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        $display("address 1: wrote %b, read %b", DATA1, DataOut);
        
        // test 3: write to address 16 and read back
        Address <= ADDR16;
        DataIn <= DATA16;
        Write <= 1;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        
        Write <= 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        $display("address 16: wrote %b, read %b", DATA16, DataOut);
        
        // test 4: write to address 31 and read back
        Address <= ADDR31;
        DataIn <= DATA31;
        Write <= 1;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        
        Write <= 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        $display("address 31: wrote %b, read %b", DATA31, DataOut);
        
        // read all addresses back and verify persistence
        
        Address <= ADDR0;
        Write <= 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        assert(DataOut == DATA0) 
            else $error(
					"failed for ADDR0: expected %b, got %b",
					DATA0, DataOut
				);
        
        Address <= ADDR1;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        assert(DataOut == DATA1) 
            else $error(
					"failed for ADDR1: expected %b, got %b",
					DATA1, DataOut
				);
        
        Address <= ADDR16;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        assert(DataOut == DATA16) 
            else $error(
					"failed for ADDR16: expected %b, got %b",
					DATA16, DataOut
				);
        
        Address <= ADDR31;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        assert(DataOut == DATA31) 
            else $error(
					"failed for ADDR31: expected %b, got %b",
					DATA31, DataOut
				);
        
        $stop;
    end
    
endmodule