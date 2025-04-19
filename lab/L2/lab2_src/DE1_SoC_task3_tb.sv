`timescale 1ps / 1ps
module DE1_SoC_task3_tb();
    // hardware inputs
    logic        CLOCK_50;
    logic [3:0]  KEY;
    logic [9:0]  SW;
    // hardware outputs
    logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    logic [9:0]  LEDR;
    
    // local variables aliases
    logic [2:0]  data_in;        // 3-bit data input (SW[3:1])
    logic [4:0]  write_address;  // 5-bit write address (SW[8:4])
    logic        write_enable;   // Write enable signal (SW[0])
    logic        ram_toggle;     // Toggle between RAM types (SW[9])
    
    logic [2:0]  data_out;       // Data output displayed on HEX0
    logic [4:0]  read_address;   // Read address counter (shown in HEX3-HEX2)
    
    // Create dut
    DE1_SoC_task3 dut(
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
    
    // Inputs to dut
    assign SW[3:1] = data_in;
    assign SW[8:4] = write_address;
    assign SW[0] = write_enable;
    assign SW[9] = ram_toggle;
    
    // Outputs from dut
    assign data_out = dut.data_out;
    assign read_address = dut.r_address;
    
    // Create clock
    parameter CLOCK_PERIOD = 20;
    
    initial begin
        CLOCK_50 = 0;
        forever #(CLOCK_PERIOD/2) CLOCK_50 = ~CLOCK_50;
    end
    
    initial begin
        // init all inputs
        KEY = 4'b1111;             // all buttons unpressed
        data_in = 3'b000;          // initial data input
        write_address = 5'b00000;  // initial write address
        write_enable = 1'b0;       // write disabled
        ram_toggle = 1'b0;         // start with task2 ram
        
        // reset
        KEY[3] = 1'b0;
        repeat(16) @(posedge CLOCK_50);
        KEY[3] = 1'b1;
        repeat(16) @(posedge CLOCK_50);
        
        $display("1: Writing to all addresses in single-port RAM");
        ram_toggle = 1'b0;
        write_enable = 1'b1;
        
        // write to every address from 0-31, value = addr % 2
        for (int i = 0; i < 32; i++) begin
            write_address = i;
            data_in = i % 2;
            repeat(4) @(posedge CLOCK_50);
        end // for
        
        $display("2: Reading from single-port RAM");
        write_enable = 1'b0;       // disable writing
        
        // reset (counter)
        KEY[3] = 1'b0;
        repeat(16) @(posedge CLOCK_50);
        KEY[3] = 1'b1;
        // let counter read all addresses
        repeat(512) @(posedge CLOCK_50);
        
        $display("3: read initial values from dual-port RAM");
        // reset again
        KEY[3] = 1'b0;
        repeat(16) @(posedge CLOCK_50);
        KEY[3] = 1'b1;
        
        ram_toggle = 1'b1; // switch to dual-port RAM
        
        // let counter read all addresses
        repeat(512) @(posedge CLOCK_50);
        
        $display("4: writing to all addresses in dual-port RAM");
        write_enable = 1'b1; // enable writing
        
        // write to every address from 0-31, value = ~(address % 2)
        for (int i = 0; i < 32; i++) begin
            write_address = i;
            data_in = ~(i % 2) & 3'b001;
            repeat(4) @(posedge CLOCK_50);
        end // for
        
        $display("5: reading from dual-port RAM after writing");
        write_enable = 1'b0;       // disable writing
        
        // reset again
        KEY[3] = 1'b0;
        repeat(16) @(posedge CLOCK_50);
        KEY[3] = 1'b1;
        
        // let counter read all addresses
        repeat(512) @(posedge CLOCK_50);
        $stop;
    end // initial
endmodule // DE1_SoC_task3_tb