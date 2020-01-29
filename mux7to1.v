`timescale 1ns / 1ns

module part1(LEDR, SW);
    input [9:0] SW;
    output [9:0] LEDR;

    mux7to1 my_mux(
        .muxInput(SW[6:0]),
        .muxSelect(SW[9:7]),
        .out(LEDR[0])
        );
endmodule

//selects 1 bit of output from input(or default) from 3bit selector
module mux7to1(out, muxInput, muxSelect);
	input [6:0] muxInput;
	input [2:0] muxSelect;
	output reg out;//reg is output for the cases
	
	//declare block with sensitivity(*)
	//so any changes to any variable updates the cases
	always @(*)
	begin
		case(muxSelect[2:0])
			3'b000: out = muxInput[0];
			3'b001: out = muxInput[1];
			3'b010: out = muxInput[2];
			3'b011: out = muxInput[3];
			3'b100: out = muxInput[4];
			3'b101: out = muxInput[5];
			3'b110: out = muxInput[6];
			default: out = 1'b0;	//always have a default
		endcase
	end
endmodule
