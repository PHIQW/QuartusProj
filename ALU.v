`timescale 1ns / 1ns

module part3(LEDR, SW,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
    input [17:0] SW;
	 
    output [9:0] LEDR;
	 output [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	 
	 wire [7:0] wireALUout;

    ALU my_ALU(
        .ALUout(wireALUout[7:0]),
        .A(SW[7:4]),
        .B(SW[3:0]),
		  .key(SW[17:15])
        );
		  
	 lightDisplays my_lights(
			.outLEDs(LEDR[7:0]),
			.hex0(HEX0[7:0]),
			.hex1(HEX1[7:0]),
			.hex2(HEX2[7:0]),
			.hex3(HEX3[7:0]),
			.hex4(HEX4[7:0]),
			.hex5(HEX5[7:0]),
			.A(SW[7:4]),
			.B(SW[3:0]),
			.ALUout(wireALUout)
			);
endmodule

//for displaying the output of ALU processor
module lightDisplays(outLEDs, hex0, hex1, hex2, hex3, hex4, hex5, A, B, ALUout);
	input [3:0] A, B;
	input [7:0] ALUout;
	output [7:0] outLEDs, hex0, hex1, hex2, hex3, hex4, hex5;
	
	assign outLEDs = ALUout;
	hex_display hx0(.IN(B),.OUT(hex0));
	hex_display hx1(.IN(4'b0000),.OUT(hex1));
	hex_display hx2(.IN(A),.OUT(hex2));
	hex_display hx3(.IN(4'b0000),.OUT(hex3));
	hex_display hx4(.IN(ALUout[3:0]),.OUT(hex4));
	hex_display hx5(.IN(ALUout[7:4]),.OUT(hex5));
	
endmodule

//for processing the calculations of the inputs
module ALU(ALUout,A,B,key);
	input [3:0] A,B;
	input [2:0] key;
	
	output reg [7:0] ALUout;
	
	wire [7:0] wirec0, wirec1, wirec2, wirec3, wirec4, wirec5;
	wire [4:0] rippleResult;
	wire andResult, orResult;
	
	//case 0:ripple adder
	assign wirec0 = {3'b000, rippleResult};
	rippleCarryAdder4Bit my_4bitAdder(
								  .S(rippleResult[3:0]),
								  .cout(rippleResult[4]),
								  .A(A[3:0]),
								  .B(B[3:0]),
								  .cin(1'b0)
								  );							  
  //case 1: verilog + operator
	assign wirec1 = A+B;
	
	//case 2: or upper, xor lower
	assign wirec2 = {A|B, A^B};
	
	//case3: at least 1 value 1
	assign wirec3 = |{A, B};
	or(orResult,A[0],B[0],A[1],B[1],A[2],B[2],A[3],B[3]);
	
	//case4: all values 1
	assign wirec4 = {7'b0000000, andResult};
	and(andResult,A[0],B[0],A[1],B[1],A[2],B[2],A[3],B[3]);
	
	//case5: A upper B lower
	assign wirec5 = {A, B};
	
	always @(*)
	begin
		case(key)
			3'b000: ALUout = wirec0;//ripple adder
			3'b001: ALUout = wirec1;//verilog + operator
			3'b010: ALUout = wirec2;//or upper xor lower
			3'b011: ALUout = wirec3;//at least 1 value 1
			3'b100: ALUout = wirec4;//All value 1
			3'b101: ALUout = wirec5;//A upper, b lower
			default: ALUout = 8'b00000000; //default 0
		endcase
	end
endmodule
