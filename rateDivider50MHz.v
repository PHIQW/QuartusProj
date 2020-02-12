//`timescale 1ns / 1ns // `timescale time_unit/time_precision
//
//module part2(SW, HEX0, CLOCK_50);
//    input [17:0] SW;
//	 input CLOCK_50;
//	 output [7:0] HEX0;
//	 
//	 wire dived;
//	 wire [3:0] hexCount;
//
//    rateDivider50MHz my_SynchonousCounter8Bit(
//			.divOut(dived),
//			.enable(SW[8]),
//			.digitControl(SW[1:0]),
//			.clock50M(CLOCK_50),
//			.clear_b(SW[9])
//			);
//			
//	counter4bit my_slowedHexCount(
//		.q(hexCount),
//		.clock(CLOCK_50),
//		.Clear_b(SW[9]),
//		.Enable(SW[8])
//		);
//		
//	 hex_display my_display(
//		.IN(hexCount),
//		.OUT(HEX0)
//		);
//endmodule

module rateDivider50MHz(divOut, enable, digitControl, clock50M, clear_b);
		input enable, clock50M, clear_b;
		input [1:0] digitControl;
		
		output divOut;
		reg [27:0] count;
		
		assign divOut = ~(|count);
		
		always @(posedge clock50M)
		begin
			if((clear_b == 1'b0) || (count == 0))
			begin
				case(digitControl)
					2'b00: count <= 28'd0;
					2'b01: count <= 28'd49999999;
					2'b10: count <= 28'd99999999;
					2'b11: count <= 28'd199999999;
					default: count <= 28'd199999999;
				endcase
			end
			else if(enable == 1'b1)
				count <= count - 1'b1;
		end
endmodule

//taken from lab 4 part 2
module counter4bit(q, clock, Clear_b, Enable);
	input clock, Clear_b, Enable;
	output reg [3:0] q; // declare q
//	wire [3:0] d; // declare d

	always @(posedge clock) // triggered every time clock rises
	begin
		if (Clear_b == 1'b0) // when Clear_b is 0...
			q <= 0; // set q to 0
//		else if (ParLoad == 1'b1) // ...otherwise, check if parallel load
//			q <= d; // load d
		else if (q == 4'b1111) // ...otherwise if q is the maximum counter value
			q <= 0; // reset q to 0
		else if (Enable == 1'b1) // ...otherwise update q (only when Enable is 1)
			q <= q + 1'b1; // increment q
			// q <= q - 1'b1; // alternatively, decrement q
	end
endmodule
