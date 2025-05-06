module part3 #(parameter LOG2_N = 3) (
	input CLOCK_50,
	input reset,
	input read_ready,
	input write_ready,

	//24-bit sample for left and right audio paths
	input  logic signed [23:0] din_left,
	input  logic signed [23:0] din_right,
	output logic signed [23:0] dout_left,
	output logic signed [23:0] dout_right
);

	localparam int N      = 1 << LOG2_N; //change window of circular queue by shifting left by 1
	localparam int ACC_W  = 24 + LOG2_N; //24-bit samples + LOG2_N bits to avoid wrapping

	logic sample_go; //logic to avoid abruptions in audio
	logic signed [23:0] divL, divR; //scaling
	logic signed [23:0] fifoL, fifoR;
	logic signed [ACC_W-1:0] accL, accR; //circular queue logic

	assign sample_go = read_ready & write_ready;

	assign divL = {{LOG2_N{din_left[23]}},  din_left[23:LOG2_N]}; //given by lab spec
	assign divR = {{LOG2_N{din_right[23]}}, din_right[23:LOG2_N]};

	logic [LOG2_N-1:0] p; //pointer in queue
	logic signed [23:0] fifo_mem_L[N];
	logic signed [23:0] fifo_mem_R[N];

	assign fifoL = fifo_mem_L[p]; //sample to be dropped out
	assign fifoR = fifo_mem_R[p];

	always_ff @(posedge CLOCK_50) begin
		if (reset) begin
			p <= '0;
			accL   <= '0;
			accR   <= '0;
		end
		else if (sample_go) begin
			accL <= accL + divL - fifoL; 
			accR <= accR + divR - fifoR;
 
			fifo_mem_L[p] <= divL; //push new term in queue
			fifo_mem_R[p] <= divR;
			p             <= p + 1'b1; //advance pointer position
		end
	end
 
	assign dout_left  = accL[23:0]; //scale sums back to 24 bit for the DAC
	assign dout_right = accR[23:0];

endmodule

