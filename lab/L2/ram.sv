/* ram module with registered inputs */
module ram(
    input  logic [4:0] Address,
    input  logic [2:0] DataIn,
    input  logic       Write,
    input  logic       clk,
    output logic [2:0] DataOut
);
    // memory array
    logic [2:0] memory_array [0:31];
    
    // internal registers
    logic [4:0] address_reg;
    logic [2:0] data_reg;
    logic       write_reg;
    logic [2:0] data_out_reg;
    
    // register inputs
    always_ff @(posedge clk) begin
        address_reg <= Address;
        data_reg    <= DataIn;
        write_reg   <= Write;
    end
    
    // memory operations
    always_ff @(posedge clk) begin
        if (write_reg) begin
            memory_array[address_reg] <= data_reg;
        end
        data_out_reg <= memory_array[address_reg];
    end
    
    assign DataOut = data_out_reg;
    
endmodule