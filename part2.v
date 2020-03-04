// Part 2 skeleton

module part2
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.

	 wire [4:0] control_counter;
    // Instansiate datapath
	// datapath d0(...);
	datapath d0(
		.x(x),
		.y(y),
		.colourOut(colour),
		.plot(wireEn),
		.resetn(resetn),
		.inputxy(SW[6:0]),
		.enable_load(KEY[3]),
		.start_plot(KEY[1]),
		.colour(SW[9:7]),
		.control_counter(control_counter)
		);

    // Instansiate FSM control
    // control c0(...);
	 control c0(
		 .control_counter(control_counter),
		 .resetn(resetn),
		 .enable_load(KEY[3]),
		 .plot(KEY[1]),
		 .clock(CLOCK_50)
		 );
    
endmodule

module datapath(x,y,colour,plot,resetn,inputxy,enable_load,start_plot,colourOut, control_counter);
	input resetn, enable_load, start_plot;
	input [6:0] inputxy;
	input [2:0] colour;
	input [4:0] control_counter;
	output reg plot;//enables vga adapter to plot points
	output reg [6:0] x,y;//outputted xy based on state
	output reg [2:0] colourOut;
	reg [6:0] xs,ys;//stored xy
	
	always @(control_counter, enable_load, start_plot)
	begin
		if(resetn == 1'b1)
			begin
			x <= 7'd0;
			y <= 7'd0;
			xs <= 7'd0;
			ys <= 7'd0;
			plot <= 1'b0;
			colourOut <= 3'b000;
			end
		else if(control_counter[4:0] == 5'b00000 & !enable_load)//in state a and load is activated
			xs <= inputxy;//load x
		else if(control_counter[4:0] == 5'b10000 & !enable_load)//in state b and load is activated
			ys <= inputxy;//load y
		else if(control_counter[3:0] != 4'b0000 | (control_counter[4:0] == 5'b00000 & !start_plot))//not in state a nor b, therefore states c-Q, or in a and plot is activated
			begin
			x <= xs + control_counter[1:0];//offsetx
			y <= ys + control_counter[3:2];//offsety
			colourOut <= colour;
			plot <= 1'b1;
			end
		else//in state a or b and nothing activated
			plot <= 0;
	end
endmodule

module control(control_counter, resetn, enable_load, plot, clock);
	input resetn, enable_load, plot, clock;
	output reg [4:0] control_counter;
	
	always @(negedge clock)
	begin
		if(resetn == 1'b1)
			control_counter <=5'b00000;//return to state a
		else if(control_counter[3:0] == 4'b0000 & !enable_load)//in state a or b and you load value
			control_counter[4] <= ~control_counter[4];	//toggle state a/b
		else if(control_counter[4:0] == 5'b00000 & !plot)//in state a and you start plotting plot so it is state c
			control_counter <= 5'b00001;	//go to state d
		else if(control_counter[3:0] == 4'b1111)//state Q, plot last square in 4x4
			control_counter <= 5'b00000;	//go to state a
		else if(control_counter[3:0] != 0)//between states c and Q, travel through
			control_counter <= control_counter + 1'b1;	//go to next state
	end
	
endmodule

