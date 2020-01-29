//`timescale 1ns / 1ns
//
//module part2(LEDR, SW);
//    input [9:0] SW;
//    output [9:0] LEDR;
//
//    rippleCarryAdder4Bit my_4bitAdder(
//        .S(LEDR[3:0]),
//        .cout(LEDR[9]),
//        .A(SW[7:4]),
//        .B(SW[3:0]),
//		  .cin(SW[8])
//        );
//endmodule

//Adds a and b with modifier cin
module fullAdder(s,cout,a,b,cin);
	input a,b;
	input cin;
	
	output s;
	output cout;
	
	wire axorb;
	
	assign axorb = a ^ b;
	assign s = cin ^ axorb;
	mux2to1 my_mux(
        .x(b),
        .y(cin),
        .s(axorb),
        .m(cout)
        );
	
endmodule

//strings 4 full adders along with the the carry values
module rippleCarryAdder4Bit(S, cout, A, B, cin);
	input [3:0] A,B;
	input cin;
	
	output [3:0] S;
	output cout;
	
	wire [2:0] carryWire;
	
	//ripple carry
	fullAdder add0(
				.s(S[0]),
				.cout(carryWire[0]),
				.a(A[0]),
				.b(B[0]),
				.cin(cin));
	fullAdder add1(
				.s(S[1]),
				.cout(carryWire[1]),
				.a(A[1]),
				.b(B[1]),
				.cin(carryWire[0]));
	fullAdder add2(
				.s(S[2]),
				.cout(carryWire[2]),
				.a(A[2]),
				.b(B[2]),
				.cin(carryWire[1]));
	fullAdder add3(
				.s(S[3]),
				.cout(cout),
				.a(A[3]),
				.b(B[3]),
				.cin(carryWire[2]));
endmodule
