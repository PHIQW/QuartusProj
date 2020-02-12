`timescale 1ns / 1ns // `timescale time_unit/time_precision

module part1(LEDR, SW, KEY, HEX0, HEX1);
    input [9:0] SW;
	 input [3:0] KEY;
    output [9:0] LEDR;
	 output [7:0] HEX0, HEX1;
	 
	 wire [7:0] counterOut;

    counterSyn8bit my_SynchonousCounter8Bit(
        .Q(counterOut),
        .enable(SW[1]),
        .clock(KEY[0]|KEY[1]|KEY[2]|KEY[3]),
        .clear_b(SW[0])
        );
		  
	 hex_display outLower(
		 .IN(counterOut[3:0]),
		 .OUT(HEX0)
		 );
	 
	 hex_display outUpper(
		 .IN(counterOut[7:0]),
		 .OUT(HEX1)
		 );
	 
endmodule

module flipflopTASYNC(q, d, clock, reset_n);//a synchonous clear
	input d;
	input clock, reset_n;
	output reg q;
	
	always @(posedge clock, negedge reset_n)	//triggered when clock rises
	begin
		if(reset_n == 1'b0)	//when reset_n is 0...
			q <= 0;				//... q is set 0
		else if(d)				//when reset_n not 0, and d is high...
			q <= ~q;				//... toggle q
	end
endmodule

module counterSyn8bit(Q, enable, clock, clear_b);
	input enable, clock, clear_b;
	output [7:0] Q;
	
	wire [7:0] ffOut;
	wire [6:0] andOut;
	
	assign Q = ffOut;
	
	assign andOut[0] = enable & ffOut[0];
	assign andOut[1] = andOut[0] & ffOut[1];
	assign andOut[2] = andOut[1] & ffOut[2];
	assign andOut[3] = andOut[2] & ffOut[3];
	assign andOut[4] = andOut[3] & ffOut[4];
	assign andOut[5] = andOut[4] & ffOut[5];
	assign andOut[6] = andOut[5] & ffOut[6];
	
	flipflopTASYNC ffT0(
					.q(ffOut[0]),
					.d(enable),
					.clock(clock),
					.reset_n(clear_b)
					);
					
	flipflopTASYNC ffT1(
					.q(ffOut[1]),
					.d(andOut[0]),
					.clock(clock),
					.reset_n(clear_b)
					);
					
	flipflopTASYNC ffT2(
					.q(ffOut[2]),
					.d(andOut[1]),
					.clock(clock),
					.reset_n(clear_b)
					);
					
	flipflopTASYNC ffT3(
					.q(ffOut[3]),
					.d(andOut[2]),
					.clock(clock),
					.reset_n(clear_b)
					);
					
	flipflopTASYNC ffT4(
					.q(ffOut[4]),
					.d(andOut[3]),
					.clock(clock),
					.reset_n(clear_b)
					);
					
	flipflopTASYNC ffT5(
					.q(ffOut[5]),
					.d(andOut[4]),
					.clock(clock),
					.reset_n(clear_b)
					);
					
	flipflopTASYNC ffT6(
					.q(ffOut[6]),
					.d(andOut[5]),
					.clock(clock),
					.reset_n(clear_b)
					);
					
	flipflopTASYNC ffT7(
					.q(ffOut[7]),
					.d(andOut[6]),
					.clock(clock),
					.reset_n(clear_b)
					);
	
endmodule
