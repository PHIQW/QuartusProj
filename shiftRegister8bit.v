`timescale 1ns / 1ns // `timescale time_unit/time_precision

module part2(LEDR, SW);
    input [17:0] SW;
    output [9:0] LEDR;

    shiftRegister8bit my_shiftR8(
        .Q(LEDR[7:0]),
        .load_val(SW[7:0]),
        .load_n(SW[15]),
        .ShiftRight(SW[16]),
		  .ASR(SW[17]),
		  .clk(SW[10]),
		  .reset_n(SW[9])
        );
endmodule

module shiftRegister8bit(Q, load_val, load_n, ShiftRight, ASR, clk, reset_n);
	input [7:0] load_val;
	input load_n, ShiftRight, ASR, clk, reset_n;
	output [7:0] Q;
	
	wire ASR_out;
	wire [7:0] sbit_wire;
	
	assign Q = sbit_wire;
	
	mux2to1 ASR_mux(
	.x(1'b0),
	.y(sbit_wire[7]),
	.s(ASR),
	.m(ASR_out)
	);
	
	shifterBit sbit7(
        .out(sbit_wire[7]),
		  .in(ASR_out),
        .load_val(load_val[7]),
        .load_n(load_n),
        .shift(ShiftRight),
		  .clk(clk),
		  .reset_n(reset_n)
        );
		  
	shifterBit sbit6(
        .out(sbit_wire[6]),
		  .in(sbit_wire[7]),
        .load_val(load_val[6]),
        .load_n(load_n),
        .shift(ShiftRight),
		  .clk(clk),
		  .reset_n(reset_n)
        );
		  
	shifterBit sbit5(
        .out(sbit_wire[5]),
		  .in(sbit_wire[6]),
        .load_val(load_val[5]),
        .load_n(load_n),
        .shift(ShiftRight),
		  .clk(clk),
		  .reset_n(reset_n)
        );
	
	shifterBit sbit4(
        .out(sbit_wire[4]),
		  .in(sbit_wire[5]),
        .load_val(load_val[4]),
        .load_n(load_n),
        .shift(ShiftRight),
		  .clk(clk),
		  .reset_n(reset_n)
        );
		  
	shifterBit sbit3(
        .out(sbit_wire[3]),
		  .in(sbit_wire[4]),
        .load_val(load_val[3]),
        .load_n(load_n),
        .shift(ShiftRight),
		  .clk(clk),
		  .reset_n(reset_n)
        );
	
	shifterBit sbit2(
        .out(sbit_wire[2]),
		  .in(sbit_wire[3]),
        .load_val(load_val[2]),
        .load_n(load_n),
        .shift(ShiftRight),
		  .clk(clk),
		  .reset_n(reset_n)
        );
	
	shifterBit sbit1(
        .out(sbit_wire[1]),
		  .in(sbit_wire[2]),
        .load_val(load_val[1]),
        .load_n(load_n),
        .shift(ShiftRight),
		  .clk(clk),
		  .reset_n(reset_n)
        );
	shifterBit sbit0(
        .out(sbit_wire[0]),
		  .in(sbit_wire[1]),
        .load_val(load_val[0]),
        .load_n(load_n),
        .shift(ShiftRight),
		  .clk(clk),
		  .reset_n(reset_n)
        );
		  
endmodule
