`timescale 1ns / 1ns

module part3(LEDR, SW,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,KEY);
    input [9:0] SW;
	 input [2:0] KEY;
	 
    output [9:0] LEDR;
	 output [7:0] HEX0;
	 output [7:0] HEX1;
	 output [7:0] HEX2;
	 output [7:0] HEX3;
	 output [7:0] HEX4;
	 output [7:0] HEX5;
	 
	 wire 

    ALU my_ALU(
        .S(LEDR[3:0]),
        .cout(LEDR[9]),
        .A(SW[7:4]),
        .B(SW[3:0]),
		  .cin(SW[8])
        );
endmodule

module ALU(ALUout,A,B,function);
	

endmodule
