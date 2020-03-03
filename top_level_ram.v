`timescale 1ns / 1ns // `timescale time_unit/time_precision

//SW[3:0] data inputs
//SW[8:4] address input
//SW[9] write enable
//KEY[1] clock

//HEX 5,4 address
//HEX 2 data input
//hex 0 data output

module top_level_ram(SW,KEY,HEX0,HEX2,HEX4,HEX5);
    input [9:0] SW;
	 input [3:0] KEY;
    output [7:0] HEX0,HEX2,HEX4,HEX5;
	 
	 wire [3:0] dataOut;

	ram32x4 my_ram32x4(
		.address(SW[8:4]),
		.clock(KEY[1]),
		.data(SW[3:0]),
		.wren(SW[9]),
		.q(dataOut)
	);
	
	hex_display hhex0(.IN(dataOut),.OUT(HEX0));
	hex_display hhex2(.IN(SW[3:0]),.OUT(HEX2));
	hex_display hhex4(.IN(SW[7:4]),.OUT(HEX4));
	hex_display hhex5(.IN(SW[8]),.OUT(HEX5));
	
endmodule