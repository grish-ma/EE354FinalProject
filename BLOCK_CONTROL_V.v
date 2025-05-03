`timescale 1ns / 1ps

module block_controller(
	input clk, //this clock must be a slow enough clock to view the changing positions of the objects
	input bright,
	input rst,
	input up, input down, input left, input right,
	input [9:0] hCount, vCount,
	output reg [11:0] rgb,
	output reg [11:0] background,
	output reg [7:0] xpos,
	output reg [7:0] ypos
   );
	reg block_fill;
	reg maze [13:0][39:0];
	reg maze_fill;
	reg [5:0] row_size, col_size;
	reg [4:0] row_index, col_index;
	reg [11:0] maze_color;
	reg db_flag;

	//these two values dictate the center of the block, incrementing and decrementing them leads the block to move in certain directions
	reg [7:0]  x_f, y_f; //xpos, ypos,
	
	parameter RED   = 12'b1111_0000_0000;
	
	/*when outputting the rgb value in an always block like this, make sure to include the if(~bright) statement, as this ensures the monitor 
	will output some data to every pixel and not just the images you are trying to display*/
	always@ (*) begin
    	if(~bright )	//force black if not inside the display area
			rgb = 12'b0000_0000_0000;
		else if (block_fill) 
			rgb = RED; 
		else if (maze_fill)
			rgb = maze_color;
		else	
			rgb=background;
	end
		//the +-5 for the positions give the dimension of the block (i.e. it will be 10x10 pixels)
//	assign block_fill=vCount>=(ypos) && vCount<=(ypos+10) && hCount>=(xpos) && hCount<=(xpos+10);
	// assign block_fill=vCount >= (ypos * 10 + 100) && vCount < (ypos * 10 + 110) && hCount >= (xpos * 10 + 300) && hCount < (xpos * 10 + 310);
	// assign maze_fill=vCount>=(50) && vCount<=(70) && hCount>=(50) && hCount<=(70);
	// This will create 10x10 pixels block for each index of the maze
	// assign maze_fill=vCount>=(row_index*10 + 100) && vCount<=(row_index*10 + 110) && hCount>=(col_index*10 + 300) && hCount<=(col_index*10 + 310); 
	integer r, c;

	always @(*) begin
		maze_fill = 0;
        block_fill = 0;
        maze_color = 12'b0000_0000_0000;
		if (vCount >= (ypos * 10 + 100) && vCount < (ypos * 10 + 110) && hCount >= (xpos * 10 + 300) && hCount < (xpos * 10 + 310))begin
			block_fill= 1;
		end
		for (r = 0; r <= row_size; r = r + 1) begin
			for (c = 0; c <= col_size; c = c + 1) begin
				if (maze[r][c] == 1) begin
					if (vCount >= (r * 10 + 100) && vCount < (r * 10 + 110) &&
						hCount >= (c * 10 + 300) && hCount < (c * 10 + 310)) begin
						maze_fill = 1;
						maze_color = 12'b0000_0000_0000; // white wall
					end
				end
			end
		end
	end
	
	
	always@(posedge clk, posedge rst) 
	begin
		if(rst)
		begin 
			//rough values for center of screen
			// xpos<=450;
			// ypos<=250;
			db_flag <=0;
			row_index <=0;
			col_index <=0;
			row_size <= 13;
			col_size <= 39;
			xpos<=0; // @ reset
			ypos<=1;
			x_f = 38;
			y_f = 13;
			// 1 1 1 1 1 1 1 1 1 1 1 - 0
			// 1 0 0 0 1 0 0 0 1 0 0 - 1
			// 1 0 1 0 1 0 1 0 1 0 1 - 2
			// 1 0 1 0 1 0 1 0 1 0 1 - 3
			// 1 0 1 0 1 0 1 0 1 0 1 - 4
			// 1 0 1 0 1 0 1 0 1 0 1 - 5
			// 1 0 1 0 1 0 1 0 1 0 1 - 6
			// 0 0 1 0 0 0 1 0 0 0 1 - 7
			// 1 1 1 1 1 1 1 1 1 1 1 - 8
			
		    maze[0][0] <= 1;
		    maze[0][1] <= 1;
		    maze[0][2] <= 1;
		    maze[0][3] <= 1;
			maze[0][4] <= 1;
			maze[0][5] <= 1;
			maze[0][6] <= 1;
			maze[0][7] <= 1;
			maze[0][8] <= 1;
			maze[0][9] <= 1;
			maze[0][10] <= 1;
		    maze[0][11] <= 1;
		    maze[0][12] <= 1;
		    maze[0][13] <= 1;
			maze[0][14] <= 1;
			maze[0][15] <= 1;
			maze[0][16] <= 1;
			maze[0][17] <= 1;
			maze[0][18] <= 1;
			maze[0][19] <= 1;
			maze[0][20] <= 1;
		    maze[0][21] <= 1;
		    maze[0][22] <= 1;
		    maze[0][23] <= 1;
			maze[0][24] <= 1;
			maze[0][25] <= 1;
			maze[0][26] <= 1;
			maze[0][27] <= 1;
			maze[0][28] <= 1;
			maze[0][29] <= 1;
			maze[0][30] <= 1;
		    maze[0][31] <= 1;
		    maze[0][32] <= 1;
		    maze[0][33] <= 1;
			maze[0][34] <= 1;
			maze[0][35] <= 1;
			maze[0][36] <= 1;
			maze[0][37] <= 1;
			maze[0][38] <= 1;
			maze[0][39] <= 1;
			
			maze[1][0] <= 0;
		    maze[1][1] <= 0;
		    maze[1][2] <= 0;
		    maze[1][3] <= 1;
			maze[1][4] <= 0;
			maze[1][5] <= 0;
			maze[1][6] <= 0;
			maze[1][7] <= 0;
			maze[1][8] <= 0;
			maze[1][9] <= 0;
			maze[1][10] <= 0;
		    maze[1][11] <= 0;
		    maze[1][12] <= 0;
		    maze[1][13] <= 0;
			maze[1][14] <= 0;
			maze[1][15] <= 0;
			maze[1][16] <= 0;
			maze[1][17] <= 0;
			maze[1][18] <= 1;
			maze[1][19] <= 0;
			maze[1][20] <= 0;
		    maze[1][21] <= 0;
		    maze[1][22] <= 1;
		    maze[1][23] <= 0;
			maze[1][24] <= 0;
			maze[1][25] <= 0;
			maze[1][26] <= 0;
			maze[1][27] <= 0;
			maze[1][28] <= 0;
			maze[1][29] <= 0;
			maze[1][30] <= 1;
		    maze[1][31] <= 0;
		    maze[1][32] <= 0;
		    maze[1][33] <= 0;
			maze[1][34] <= 0;
			maze[1][35] <= 0;
			maze[1][36] <= 1;
			maze[1][37] <= 0;
			maze[1][38] <= 0;
			maze[1][39] <= 1;
			
			maze[2][0] <= 1;
		    maze[2][1] <= 1;
		    maze[2][2] <= 0;
		    maze[2][3] <= 1;
			maze[2][4] <= 0;
			maze[2][5] <= 0;
			maze[2][6] <= 0;
			maze[2][7] <= 0;
			maze[2][8] <= 0;
			maze[2][9] <= 0;
			maze[2][10] <= 1;
		    maze[2][11] <= 1;
		    maze[2][12] <= 1;
		    maze[2][13] <= 1;
			maze[2][14] <= 1;
			maze[2][15] <= 1;
			maze[2][16] <= 0;
			maze[2][17] <= 0;
			maze[2][18] <= 0;
			maze[2][19] <= 0;
			maze[2][20] <= 1;
		    maze[2][21] <= 1;
		    maze[2][22] <= 1;
		    maze[2][23] <= 1;
			maze[2][24] <= 1;
			maze[2][25] <= 1;
			maze[2][26] <= 0;
			maze[2][27] <= 1;
			maze[2][28] <= 0;
			maze[2][29] <= 0;
			maze[2][30] <= 1;
		    maze[2][31] <= 1;
		    maze[2][32] <= 1;
		    maze[2][33] <= 1;
			maze[2][34] <= 0;
			maze[2][35] <= 0;
			maze[2][36] <= 1;
			maze[2][37] <= 1;
			maze[2][38] <= 0;
			maze[2][39] <= 1;
			
			maze[3][0] <= 1;
		    maze[3][1] <= 0;
		    maze[3][2] <= 0;
		    maze[3][3] <= 0;
			maze[3][4] <= 1;
			maze[3][5] <= 1;
			maze[3][6] <= 1;
			maze[3][7] <= 0;
			maze[3][8] <= 0;
			maze[3][9] <= 0;
			maze[3][10] <= 1;
		    maze[3][11] <= 0;
		    maze[3][12] <= 0;
		    maze[3][13] <= 0;
			maze[3][14] <= 0;
			maze[3][15] <= 1;
			maze[3][16] <= 0;
			maze[3][17] <= 0;
			maze[3][18] <= 1;
			maze[3][19] <= 0;
			maze[3][20] <= 0;
		    maze[3][21] <= 0;
		    maze[3][22] <= 1;
		    maze[3][23] <= 0;
			maze[3][24] <= 0;
			maze[3][25] <= 0;
			maze[3][26] <= 0;
			maze[3][27] <= 1;
			maze[3][28] <= 0;
			maze[3][29] <= 0;
			maze[3][30] <= 0;
		    maze[3][31] <= 0;
		    maze[3][32] <= 0;
		    maze[3][33] <= 1;
			maze[3][34] <= 0;
			maze[3][35] <= 0;
			maze[3][36] <= 0;
			maze[3][37] <= 1;
			maze[3][38] <= 0;
			maze[3][39] <= 1;
			
			
			maze[4][0] <= 1;
		    maze[4][1] <= 1;
		    maze[4][2] <= 1;
		    maze[4][3] <= 0;
			maze[4][4] <= 0;
			maze[4][5] <= 0;
			maze[4][6] <= 0;
			maze[4][7] <= 0;
			maze[4][8] <= 0;
			maze[4][9] <= 0;
			maze[4][10] <= 1;
		    maze[4][11] <= 0;
		    maze[4][12] <= 1;
		    maze[4][13] <= 0;
			maze[4][14] <= 0;
			maze[4][15] <= 1;
			maze[4][16] <= 0;
			maze[4][17] <= 0;
			maze[4][18] <= 1;
			maze[4][19] <= 0;
			maze[4][20] <= 0;
		    maze[4][21] <= 0;
		    maze[4][22] <= 1;
		    maze[4][23] <= 0;
			maze[4][24] <= 0;
			maze[4][25] <= 0;
			maze[4][26] <= 0;
			maze[4][27] <= 1;
			maze[4][28] <= 1;
			maze[4][29] <= 1;
			maze[4][30] <= 0;
		    maze[4][31] <= 0;
		    maze[4][32] <= 0;
		    maze[4][33] <= 1;
			maze[4][34] <= 0;
			maze[4][35] <= 0;
			maze[4][36] <= 0;
			maze[4][37] <= 1;
			maze[4][38] <= 0;
			maze[4][39] <= 1;
			
			maze[5][0] <= 1;
		    maze[5][1] <= 0;
		    maze[5][2] <= 1;
		    maze[5][3] <= 0;
			maze[5][4] <= 1;
			maze[5][5] <= 1;
			maze[5][6] <= 1;
			maze[5][7] <= 1;
			maze[2][8] <= 0;
			maze[5][9] <= 0;
			maze[5][10] <= 1;
		    maze[5][11] <= 0;
		    maze[5][12] <= 1;
		    maze[5][13] <= 0;
			maze[5][14] <= 0;
			maze[5][15] <= 1;
			maze[5][16] <= 0;
			maze[5][17] <= 0;
			maze[5][18] <= 1;
			maze[5][19] <= 0;
			maze[5][20] <= 0;
		    maze[5][21] <= 0;
		    maze[5][22] <= 0;
		    maze[5][23] <= 1;
			maze[5][24] <= 1;
			maze[5][25] <= 0;
			maze[5][26] <= 0;
			maze[5][27] <= 0;
			maze[5][28] <= 0;
			maze[5][29] <= 0;
			maze[5][30] <= 0;
		    maze[5][31] <= 0;
		    maze[5][32] <= 0;
		    maze[5][33] <= 1;
			maze[5][34] <= 0;
			maze[5][35] <= 0;
			maze[5][36] <= 0;
			maze[5][37] <= 0;
			maze[5][38] <= 0;
			maze[5][39] <= 1;
			
			maze[6][0] <= 1;
		    maze[6][1] <= 0;
		    maze[6][2] <= 1;
		    maze[6][3] <= 0;
			maze[6][4] <= 0;
			maze[6][5] <= 0;
			maze[6][6] <= 0;
			maze[6][7] <= 1;
			maze[6][8] <= 1;
			maze[6][9] <= 1;
			maze[6][10] <= 1;
		    maze[6][11] <= 0;
		    maze[6][12] <= 1;
		    maze[6][13] <= 1;
			maze[6][14] <= 0;
			maze[6][15] <= 0;
			maze[6][16] <= 0;
			maze[6][17] <= 0;
			maze[6][18] <= 1;
			maze[6][19] <= 1;
			maze[6][20] <= 1;
		    maze[6][21] <= 1;
		    maze[6][22] <= 0;
		    maze[6][23] <= 0;
			maze[6][24] <= 0;
			maze[6][25] <= 0;
			maze[6][26] <= 0;
			maze[6][27] <= 1;
			maze[6][28] <= 0;
			maze[6][29] <= 0;
			maze[6][30] <= 0;
		    maze[6][31] <= 0;
		    maze[6][32] <= 1;
		    maze[6][33] <= 1;
			maze[6][34] <= 0;
			maze[6][35] <= 0;
			maze[6][36] <= 0;
			maze[6][37] <= 0;
			maze[6][38] <= 0;
			maze[6][39] <= 1;
			
			
			maze[7][0] <= 1;
		    maze[7][1] <= 0;
		    maze[7][2] <= 1;
		    maze[7][3] <= 0;
			maze[7][4] <= 0;
			maze[7][5] <= 0;
			maze[7][6] <= 0;
			maze[7][7] <= 1;
			maze[7][8] <= 0;
			maze[7][9] <= 0;
			maze[7][10] <= 0;
		    maze[7][11] <= 0;
		    maze[7][12] <= 0;
		    maze[7][13] <= 0;
			maze[7][14] <= 0;
			maze[7][15] <= 1;
			maze[7][16] <= 0;
			maze[7][17] <= 0;
			maze[7][18] <= 1;
			maze[7][19] <= 0;
			maze[7][20] <= 0;
		    maze[7][21] <= 1;
		    maze[7][22] <= 0;
		    maze[7][23] <= 0;
			maze[7][24] <= 0;
			maze[7][25] <= 0;
			maze[7][26] <= 0;
			maze[7][27] <= 1;
			maze[7][28] <= 0;
			maze[7][29] <= 0;
			maze[7][30] <= 0;
		    maze[7][31] <= 1;
		    maze[7][32] <= 0;
		    maze[7][33] <= 0;
			maze[7][34] <= 0;
			maze[7][35] <= 1;
			maze[7][36] <= 1;
			maze[7][37] <= 1;
			maze[7][38] <= 1;
			maze[7][39] <= 1;
			
			maze[8][0] <= 1;
		    maze[8][1] <= 0;
		    maze[8][2] <= 1;
		    maze[8][3] <= 0;
			maze[8][4] <= 1;
			maze[8][5] <= 1;
			maze[8][6] <= 0;
			maze[8][7] <= 1;
			maze[8][8] <= 0;
			maze[8][9] <= 1;
			maze[8][10] <= 1;
		    maze[8][11] <= 1;
		    maze[8][12] <= 1;
		    maze[8][13] <= 1;
			maze[8][14] <= 0;
			maze[8][15] <= 1;
			maze[8][16] <= 0;
			maze[8][17] <= 0;
			maze[8][18] <= 0;
			maze[8][19] <= 0;
			maze[8][20] <= 0;
		    maze[8][21] <= 1;
		    maze[8][22] <= 1;
		    maze[8][23] <= 0;
			maze[8][24] <= 1;
			maze[8][25] <= 1;
			maze[8][26] <= 1;
			maze[8][27] <= 1;
			maze[8][28] <= 0;
			maze[8][29] <= 0;
			maze[8][30] <= 0;
		    maze[8][31] <= 1;
		    maze[8][32] <= 0;
		    maze[8][33] <= 1;
			maze[8][34] <= 1;
			maze[8][35] <= 1;
			maze[8][36] <= 0;
			maze[8][37] <= 0;
			maze[8][38] <= 0;
			maze[8][39] <= 1;
			
			maze[9][0] <= 1;
		    maze[9][1] <= 0;
		    maze[9][2] <= 0;
		    maze[9][3] <= 0;
			maze[9][4] <= 0;
			maze[9][5] <= 1;
			maze[9][6] <= 0;
			maze[9][7] <= 1;
			maze[9][8] <= 0;
			maze[9][9] <= 0;
			maze[9][10] <= 0;
		    maze[9][11] <= 0;
		    maze[9][12] <= 0;
		    maze[9][13] <= 1;
			maze[9][14] <= 0;
			maze[9][15] <= 1;
			maze[9][16] <= 1;
			maze[9][17] <= 0;
			maze[9][18] <= 1;
			maze[9][19] <= 1;
			maze[9][20] <= 0;
		    maze[9][21] <= 0;
		    maze[9][22] <= 1;
		    maze[9][23] <= 0;
			maze[9][24] <= 1;
			maze[9][25] <= 0;
			maze[9][26] <= 0;
			maze[9][27] <= 0;
			maze[9][28] <= 0;
			maze[9][29] <= 0;
			maze[9][30] <= 0;
		    maze[9][31] <= 1;
		    maze[9][32] <= 0;
		    maze[9][33] <= 1;
			maze[9][34] <= 0;
			maze[9][35] <= 1;
			maze[9][36] <= 0;
			maze[9][37] <= 0;
			maze[9][38] <= 0;
			maze[9][39] <= 1;
			
			maze[10][0] <= 1;
		    maze[10][1] <= 0;
		    maze[10][2] <= 0;
		    maze[10][3] <= 1;
			maze[10][4] <= 0;
			maze[10][5] <= 0;
			maze[10][6] <= 1;
			maze[10][7] <= 1;
			maze[10][8] <= 1;
			maze[10][9] <= 1;
			maze[10][10] <= 1;
		    maze[10][11] <= 1;
		    maze[10][12] <= 0;
		    maze[10][13] <= 1;
			maze[10][14] <= 0;
			maze[10][15] <= 0;
			maze[10][16] <= 0;
			maze[10][17] <= 0;
			maze[10][18] <= 0;
			maze[10][19] <= 1;
			maze[10][20] <= 0;
		    maze[10][21] <= 0;
		    maze[10][22] <= 1;
		    maze[10][23] <= 0;
			maze[10][24] <= 0;
			maze[10][25] <= 0;
			maze[10][26] <= 1;
			maze[10][27] <= 1;
			maze[10][28] <= 1;
			maze[10][29] <= 0;
			maze[10][30] <= 0;
		    maze[10][31] <= 0;
		    maze[10][32] <= 0;
		    maze[10][33] <= 1;
			maze[10][34] <= 0;
			maze[10][35] <= 0;
			maze[10][36] <= 0;
			maze[10][37] <= 0;
			maze[10][38] <= 0;
			maze[10][39] <= 1;
			
			maze[11][0] <= 1;
		    maze[11][1] <= 0;
		    maze[11][2] <= 1;
		    maze[11][3] <= 0;
			maze[11][4] <= 1;
			maze[11][5] <= 1;
			maze[11][6] <= 0;
			maze[11][7] <= 0;
			maze[11][8] <= 0;
			maze[11][9] <= 0;
			maze[11][10] <= 0;
		    maze[11][11] <= 0;
		    maze[11][12] <= 0;
		    maze[11][13] <= 1;
			maze[11][14] <= 1;
			maze[11][15] <= 1;
			maze[11][16] <= 1;
			maze[11][17] <= 1;
			maze[11][18] <= 0;
			maze[11][19] <= 1;
			maze[11][20] <= 0;
		    maze[11][21] <= 1;
		    maze[11][22] <= 0;
		    maze[11][23] <= 0;
			maze[11][24] <= 1;
			maze[11][25] <= 0;
			maze[11][26] <= 1;
			maze[11][27] <= 1;
			maze[11][28] <= 1;
			maze[11][29] <= 0;
			maze[11][30] <= 1;
		    maze[11][31] <= 1;
		    maze[11][32] <= 0;
		    maze[11][33] <= 0;
			maze[11][34] <= 0;
			maze[11][35] <= 1;
			maze[11][36] <= 1;
			maze[11][37] <= 1;
			maze[11][38] <= 0;
			maze[11][39] <= 1;
			
			maze[12][0] <= 1;
		    maze[12][1] <= 0;
		    maze[12][2] <= 1;
		    maze[12][3] <= 0;
			maze[12][4] <= 0;
			maze[12][5] <= 0;
			maze[12][6] <= 0;
			maze[12][7] <= 0;
			maze[12][8] <= 0;
			maze[12][9] <= 0;
			maze[12][10] <= 0;
		    maze[12][11] <= 0;
		    maze[12][12] <= 0;
		    maze[12][13] <= 1;
			maze[12][14] <= 0;
			maze[12][15] <= 1;
			maze[12][16] <= 0;
			maze[12][17] <= 1;
			maze[12][18] <= 0;
			maze[12][19] <= 1;
			maze[12][20] <= 0;
		    maze[12][21] <= 0;
		    maze[12][22] <= 0;
		    maze[12][23] <= 1;
			maze[12][24] <= 1;
			maze[12][25] <= 0;
			maze[12][26] <= 1;
			maze[12][27] <= 0;
			maze[12][28] <= 0;
			maze[12][29] <= 0;
			maze[12][30] <= 0;
		    maze[12][31] <= 0;
		    maze[12][32] <= 0;
		    maze[12][33] <= 1;
			maze[12][34] <= 1;
			maze[12][35] <= 1;
			maze[12][36] <= 0;
			maze[12][37] <= 0;
			maze[12][38] <= 0;
			maze[12][39] <= 1;
			
			maze[13][0] <= 1;
		    maze[13][1] <= 1;
		    maze[13][2] <= 1;
		    maze[13][3] <= 1;
			maze[13][4] <= 1;
			maze[13][5] <= 1;
			maze[13][6] <= 1;
			maze[13][7] <= 1;
			maze[13][8] <= 1;
			maze[13][9] <= 1;
			maze[13][10] <= 1;
		    maze[13][11] <= 1;
		    maze[13][12] <= 1;
		    maze[13][13] <= 1;
			maze[13][14] <= 1;
			maze[13][15] <= 1;
			maze[13][16] <= 1;
			maze[13][17] <= 1;
			maze[13][18] <= 1;
			maze[13][19] <= 1;
			maze[13][20] <= 1;
		    maze[13][21] <= 1;
		    maze[13][22] <= 1;
		    maze[13][23] <= 1;
			maze[13][24] <= 1;
			maze[13][25] <= 1;
			maze[13][26] <= 1;
			maze[13][27] <= 1;
			maze[13][28] <= 1;
			maze[13][29] <= 1;
			maze[13][30] <= 1;
		    maze[13][31] <= 1;
		    maze[13][32] <= 1;
		    maze[13][33] <= 1;
			maze[13][34] <= 1;
			maze[13][35] <= 1;
			maze[13][36] <= 1;
			maze[13][37] <= 1;
			maze[13][38] <= 0;
			maze[13][39] <= 1;
		
			// if maze[0][0] == 1) begin
			//	maze_color <= 12'b0000_0000_0000;	
			// end
			// else begin
			//	maze_color <= 12'b1111_1111_1111;
			// end
		end
		else if (clk) begin
		
		/* Note that the top left of the screen does NOT correlate to vCount=0 and hCount=0. The display_controller.v file has the 
			synchronizing pulses for both the horizontal sync and the vertical sync begin at vcount=0 and hcount=0. Recall that after 
			the length of the pulse, there is also a short period called the back porch before the display area begins. So effectively, 
			the top left corner corresponds to (hcount,vcount)~(144,35). Which means with a 640x480 resolution, the bottom right corner 
			corresponds to ~(783,515).  
		*/	
		//	if ((vCount == row_index*10 + 110) && (hCount == col_index*10 + 310)) begin
		//		col_index <= col_index + 1;
		//		if (col_index == col_size)
		//			begin
		//				row_index <= row_index + 1;
		//				col_index <= 0;
		//			end
		//			if (row_index == row_size) begin
		//				row_index <= 0;
		//				col_index <= 0;
		//			end

		//		if (maze[row_index][col_index] == 1) begin
		//			maze_color = 12'b1111_1111_1111;	
		//		end
		//		else begin
		//			maze_color = 12'b0000_0000_0000;
		//		end
		//	end
			
			if(right && (xpos != x_f || ypos != y_f) && (xpos < col_size) && (maze[ypos][xpos+1]!=1)) begin
			     if (db_flag == 0)begin
				    xpos<=xpos+1; //change the amount you increment to make the speed faster 
				    db_flag <= 1;
				end
//				$display("xpos = %d", xpos);
//				$display("ypos = %d", ypos);
//				$display("RIGHT - maze[ypos][xpos+1] = %d", maze[ypos][xpos+1]);
//				if(xpos==800) //these are rough values to attempt looping around, you can fine-tune them to make it more accurate- refer to the block comment above
//					xpos<=150;
			end
			else if(left && (xpos != x_f || ypos != y_f) && (xpos > 0) && (maze[ypos][xpos-1]!=1)) begin
			     if (db_flag == 0)begin
				    xpos<=xpos-1; //change the amount you increment to make the speed faster 
				    db_flag <= 1;
				end
				
//				$display("xpos = %d", xpos);
//				$display("ypos = %d", ypos);
//				$display("LEFT - maze[ypos][xpos-1] = %d", maze[ypos][xpos+1]);
//				if(xpos==150)
//					xpos<=800;
			end
			//  !(xpos == x_f && ypos == y_f)
			else if(up && (xpos != x_f || ypos != y_f) && (ypos > 0) && (maze[ypos-1][xpos]!=1)) begin
                if (db_flag == 0)begin
				    ypos<=ypos-1;//change the amount you increment to make the speed faster 
				    db_flag <= 1;
				end
				
//				$display("xpos = %d", xpos);
//				$display("ypos = %d", ypos);
//				$display("UP - maze[ypos-1][xpos] = %d", maze[ypos][xpos+1]);
//				if(ypos==34)
//					ypos<=514;
			end
			else if(down && (xpos != x_f || ypos != y_f)&& (ypos < row_size) && (maze[ypos+1][xpos]!=1)) begin
				if (db_flag == 0)begin
				    ypos<=ypos+1;//change the amount you increment to make the speed faster 
				    db_flag <= 1;
				end
//				$display("xpos = %d", xpos);
//				$display("ypos = %d", ypos);
//				$display("DOWN - maze[ypos+1][xpos] = %d", maze[ypos][xpos+1]);
//				if(ypos==514)
//					ypos<=34;
			end
			else begin
			   db_flag <=0;
			end
		end
	end
	
	//the background color reflects the most recent button press
	always@(posedge clk, posedge rst) begin
		if(rst)
			background <= 12'b1111_1111_1111;
		else 
			if(right)
				background <= 12'b1111_1111_0000;
			else if(left)
				background <= 12'b0000_1111_1111;
			else if(down)
				background <= 12'b0000_1111_0000;
			else if(up)
				background <= 12'b0000_0000_1111;
	end

	
	
endmodule
