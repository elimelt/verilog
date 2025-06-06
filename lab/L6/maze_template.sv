module maze_template (
    input  logic [9:0] x,             // screen x coordinate
    input  logic [8:0] y,             // screen y coordinate
    output logic is_wall             // high if pixel is part of a wall
);
    localparam MAZE_WIDTH  = 65;
    localparam MAZE_HEIGHT = 45;

    // Scale screen coordinates to maze grid position
    logic [5:0] grid_x;
    logic [5:0] grid_y;

    assign grid_x = x / 10;
    assign grid_y = y / 10;

    // Maze storage (1 = wall, 0 = path)
    logic [0:MAZE_HEIGHT-1][0:MAZE_WIDTH-1] maze;

    initial begin
        // Clear all cells to 0 (path)
        for (int row = 0; row < MAZE_HEIGHT; row++) begin
            for (int col = 0; col < MAZE_WIDTH; col++) begin
                maze[row][col] = 0;
            end
        end

       
         // Vertical walls from row 5 to 40 at columns 5 and 60
        for (int i = 5; i <= 40; i++) begin
            maze[i][5] = 1;
            maze[i][55] = 1;
        end
        for (int i = 5; i <= 55; i++) begin
            maze[5][i] = 1;
            maze[40][i] = 1;
        end
        
       
    end

    assign is_wall = maze[grid_y][grid_x];
endmodule
