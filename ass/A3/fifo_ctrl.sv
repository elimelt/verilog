/* FIFO controller to manage a register file as a circular queue.
 * Manipulates output read and write addresses based on 1-bit
 * read (rd) and write (wr) requests and current buffer status
 * signals empty and full.
 */
module fifo_ctrl #(parameter ADDR_WIDTH=4)
				 (clk, reset, rd, wr, empty, full, w_addr, r_addr, upper);
	input  logic clk, reset, rd, wr;
	output logic empty, full;
	output logic [ADDR_WIDTH-1:0] w_addr, r_addr;
	output logic upper;  // flag for upper/lower half of data being read
	// signal declarations
	logic [ADDR_WIDTH-1:0] rd_ptr, rd_ptr_next;
	logic [ADDR_WIDTH-1:0] wr_ptr, wr_ptr_next;
	logic empty_next, full_next;
	logic upper_next;
	// output assignments
	assign w_addr = wr_ptr;
	assign r_addr = rd_ptr;

	// fifo controller logic
	always_ff @(posedge clk) begin
		if (reset)
			begin
				wr_ptr <= 0;
				rd_ptr <= 0;
				full   <= 0;
				empty  <= 1;
				upper <= 1;
			end
		else
			begin
				wr_ptr <= wr_ptr_next;
				rd_ptr <= rd_ptr_next;
				full   <= full_next;
				empty  <= empty_next;
				upper <= upper_next;
			end
	end  // always_ff

	// next state logic
	always_comb begin
		// default to keeping the current values
		rd_ptr_next = rd_ptr;
		wr_ptr_next = wr_ptr;
		empty_next = empty;
		full_next = full;
		upper_next = upper;

		case ({rd, wr})
			2'b11:  // read and write
				begin
					// write then read
					wr_ptr_next = wr_ptr + 1'b1;

					// toggle upper and advance pointer
					if (upper) begin
						upper_next = 0;
					end else begin
						// toggle upper and advance pointer
						upper_next = 1;
						rd_ptr_next = rd_ptr + 1'b1;
					end

					full_next = 0;
				end

			2'b10:  // read
				if (~empty)
					begin
						if (upper) begin
							// already in upper half, read lower half next
							upper_next = 0;
						end else begin
							// toggle upper and advance pointer
							upper_next = 1;
							rd_ptr_next = rd_ptr + 1'b1;
							// check empty
							if (rd_ptr_next == wr_ptr)
								empty_next = 1;
						end
						// can't be full after reading
						full_next = 0;
					end

			2'b01:  // write only
				if (~full)
					begin
						wr_ptr_next = wr_ptr + 1'b1;

						// can't be empty after writing
						empty_next = 0;

						// check full
						if ((wr_ptr_next == rd_ptr))
							full_next = 1;
					end

			2'b00: ; // no change
		endcase
	end  // always_comb

endmodule  // fifo_ctrl
