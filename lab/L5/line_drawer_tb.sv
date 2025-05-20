module line_drawer_tb ();
	logic clk, reset;
	logic [10:0]	x0, y0, x1, y1;
	logic [10:0]	x, y;
	logic done;
	
	line_drawer dut (.*);

	parameter CLOCK_PERIOD = 300;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end

	integer i;
	initial begin
	
	// 1. Gradual, Left-Up
	reset <= 1; 
	x0 <= 11'd0; y0 <= 11'd0;
	x1 <= 11'd100; y1 <= 11'd20;
	@(posedge clk); reset <= 0;
	for (i = 0; i < 110; i++) @(posedge clk);
	
	// 2. Steep, Left-Up
	reset <= 1; 
	x0 <= 11'd0; y0 <= 11'd0;
	x1 <= 11'd20; y1 <= 11'd100;
	@(posedge clk); reset <= 0;
	for (i = 0; i < 110; i++) @(posedge clk);
	
	// 3. Gradual, Right-Down
	reset <= 1; 
	x0 <= 11'd100; y0 <= 11'd20;
	x1 <= 11'd0; y1 <= 11'd0;
	@(posedge clk); reset <= 0;
	for (i = 0; i < 110; i++) @(posedge clk);

	// 4. Steep, Right-Down
	reset <= 1; 
	x0 <= 11'd20; y0 <= 11'd100;
	x1 <= 11'd0; y1 <= 11'd0;
	@(posedge clk); reset <= 0;
	for (i = 0; i < 110; i++) @(posedge clk);
	
	// 5. Gradual, Right-Left, Up
	reset <= 1; 
	x0 <= 11'd100; y0 <= 11'd0;
	x1 <= 11'd0;   y1 <= 11'd20;
	@(posedge clk); reset <= 0;
	for (i = 0; i < 110; i++) @(posedge clk);

	// 6. Steep, Right-Left, Up
	reset <= 1; 
	x0 <= 11'd20; y0 <= 11'd0;
	x1 <= 11'd0;  y1 <= 11'd100;
	@(posedge clk); reset <= 0;
	for (i = 0; i < 110; i++) @(posedge clk);

	// 7. Gradual, Left-Right, Down
	reset <= 1; 
	x0 <= 11'd0; y0 <= 11'd100;
	x1 <= 11'd100; y1 <= 11'd80;
	@(posedge clk); reset <= 0;
	for (i = 0; i < 110; i++) @(posedge clk);

	// 8. Steep, Left-Right, Down
	reset <= 1; 
	x0 <= 11'd0; y0 <= 11'd100;
	x1 <= 11'd20; y1 <= 11'd0;
	@(posedge clk); reset <= 0;
	for (i = 0; i < 110; i++) @(posedge clk);


	$stop();
	end
endmodule
