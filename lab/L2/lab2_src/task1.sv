/* Module for task 1, wrapping a ram32x3 */
module task1(
    input  logic [4:0] Address,
    input  logic [2:0] DataIn,
    input  logic       Write,
    input  logic       clk,
    output logic [2:0] DataOut
);
    logic [4:0] address;
    logic [2:0] data;
    logic       wren;
    
    ram32x3 ram (
        .address, .data, .wren, 
        .q(DataOut), .clock(clk)
    );
    
    always_ff @(posedge clk) begin
        address <= Address;
        data    <= DataIn;
        wren    <= Write;
    end
    
endmodule // task1