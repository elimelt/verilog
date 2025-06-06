module n8_display (
    input clk,
    input right, left, up, down, select, start, a, b,
    output reg[6:0] HEX0, 
    output reg[6:0] HEX1,
    output reg[6:0] HEX2,
    output reg[6:0] HEX3,
    output reg[6:0] HEX4,
    output reg[6:0] HEX5);

    always @(posedge clk) begin
        // Default all HEX to off
        HEX0 = 7'b1111111;
        HEX1 = 7'b1111111;
        HEX2 = 7'b1111111;
        HEX3 = 7'b1111111;
        HEX4 = 7'b1111111;
        HEX5 = 7'b1111111;

        if (up) begin
            // Display "U P"
            HEX5 = 7'b1000001; // U
            HEX4 = 7'b0001100; // P
        end else if (down) begin
            // Display "D O W N"
            HEX5 = 7'b0100001; // D
            HEX4 = 7'b0100011; // O
        end else if (right) begin
            // Display "R I G H T"
            HEX5 = 7'b0101111; // R
            HEX4 = 7'b1001111; // I
        end else if (left) begin
            // Display "L E F T"
            HEX5 = 7'b1000111; // L
            HEX4 = 7'b0000110; // E
        end
    end

endmodule
