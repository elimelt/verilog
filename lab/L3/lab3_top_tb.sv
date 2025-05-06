`timescale 1ns/1ps
module lab3_top_tb;
    logic CLOCK_50 = 0, CLOCK2_50 = 0;
    always #10 CLOCK_50  = ~CLOCK_50;
    always #10 CLOCK2_50 = ~CLOCK2_50;

    logic [9:0] SW = 0;
    logic [3:0] KEY = 4'b1111;

    logic        FPGA_I2C_SCLK;
    tri          FPGA_I2C_SDAT;
    logic        AUD_XCK;
    logic        AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
    logic        AUD_ADCDAT,  AUD_DACDAT;

    lab3_top dut ( .* );

    // Simulate CODEC audio clocks and random input audio signal
    initial begin
        KEY[0] = 0; // apply reset
        #(1000);
        KEY[0] = 1; // release reset

        forever begin
            AUD_ADCLRCK = 1;
            AUD_DACLRCK = 1;
            AUD_BCLK    = 1;
            repeat (1042) @(posedge CLOCK_50); 
            AUD_ADCDAT = ~$random;            
        end
    end

    // Toggle switches
    initial begin
        // Task 1, unfiltered
        SW[9] = 0; // passthrough mode
        SW[8] = 0; // filter OFF
        #(50_000_000);

        // Task 1, filtered
        SW[8] = 1; // filter ON
        #(50_000_000);

        // Task 2, unfiltered
        SW[9] = 1; // ROM tone mode
        SW[8] = 0; // filter OFF
        #(50_000_000);

        // Task 2, filtered
        SW[8] = 1; // filter ON
        #(50_000_000);

        $stop;
    end
endmodule //lab3_top_tb