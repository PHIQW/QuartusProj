`timescale 1ns / 1ns // `timescale time_unit/time_precision

module part3(SW, LEDR, KEY, CLOCK_50);
    input [17:0] SW;
	 input [3:0] KEY;
	 input CLOCK_50;
	 output LEDR;
	 
	 wire [11:0] morseCode;
	 wire dived;

    morseLUT(.in3b(SW[2:0]),.letter(morseCode));
	 rateDivider50MHz my_50hzToHalfSecondTick(
			.divOut(dived),
			.enable(1'b1),
			.digitControl(2'b10),
			.clock50M(CLOCK_50),
			.clear_b(KEY[0])
			);
	shiftRegister12bit(
			.Q(LEDR),
			.load_val(morseCode),
			.load_n(KEY[1]),
			.ShiftRight(1'b1),
			.ASR(1'b0),
			.clk(dived),
			.reset_n(KEY[0])
			);
			
endmodule

module morseLUT(in3b, letter);
	input [2:0] in3b;
	output reg [11:0] letter;
	
	always @(*)
	begin
		case(in3b)
			3'b000: letter <= 12'b000000011101;
			3'b001: letter <= 12'b000101010111;
			3'b010: letter <= 12'b010111010111;
			3'b011: letter <= 12'b000001010111;
			3'b100: letter <= 12'b000000000001;
			3'b101: letter <= 12'b000101110101;
			3'b110: letter <= 12'b000101110111;
			3'b111: letter <= 12'b000001010101;
			default: letter <= 12'b0;
		endcase
	end
endmodule

module shiftRegister12bit(Q, load_val, load_n, ShiftRight, ASR, clk, reset_n);
	input [11:0] load_val;
	input load_n, ShiftRight, ASR, clk, reset_n;
	output Q;
	
	wire ASR_out;
	wire [11:0] sbit_wire;
	
	assign Q = sbit_wire[0];
	
	mux2to1 ASR_mux(
	.x(1'b0),
	.y(sbit_wire[7]),
	.s(ASR),
	.m(ASR_out)
	);
	
	shifterBitASYNCR sbit11(.out(sbit_wire[11]),.in(ASR_out),.load_val(load_val[11]),.load_n(load_n),.shift(ShiftRight),.clk(clk),.reset_n(reset_n));
	shifterBitASYNCR sbit10(.out(sbit_wire[10]),.in(sbit_wire[11]),.load_val(load_val[10]),.load_n(load_n),.shift(ShiftRight),.clk(clk),.reset_n(reset_n));
	shifterBitASYNCR sbit9(.out(sbit_wire[9]),.in(sbit_wire[10]),.load_val(load_val[9]),.load_n(load_n),.shift(ShiftRight),.clk(clk),.reset_n(reset_n));
	shifterBitASYNCR sbit8(.out(sbit_wire[8]),.in(sbit_wire[9]),.load_val(load_val[8]),.load_n(load_n),.shift(ShiftRight),.clk(clk),.reset_n(reset_n));
	shifterBitASYNCR sbit7(.out(sbit_wire[7]),.in(sbit_wire[8]),.load_val(load_val[7]),.load_n(load_n),.shift(ShiftRight),.clk(clk),.reset_n(reset_n));
	shifterBitASYNCR sbit6(.out(sbit_wire[6]),.in(sbit_wire[7]),.load_val(load_val[6]),.load_n(load_n),.shift(ShiftRight),.clk(clk),.reset_n(reset_n));
	shifterBitASYNCR sbit5(.out(sbit_wire[5]),.in(sbit_wire[6]),.load_val(load_val[5]),.load_n(load_n),.shift(ShiftRight),.clk(clk),.reset_n(reset_n));
	shifterBitASYNCR sbit4(.out(sbit_wire[4]),.in(sbit_wire[5]),.load_val(load_val[4]),.load_n(load_n),.shift(ShiftRight),.clk(clk),.reset_n(reset_n));
	shifterBitASYNCR sbit3(.out(sbit_wire[3]),.in(sbit_wire[4]),.load_val(load_val[3]),.load_n(load_n),.shift(ShiftRight),.clk(clk),.reset_n(reset_n));
	shifterBitASYNCR sbit2(.out(sbit_wire[2]),.in(sbit_wire[3]),.load_val(load_val[2]),.load_n(load_n),.shift(ShiftRight),.clk(clk),.reset_n(reset_n));
	shifterBitASYNCR sbit1(.out(sbit_wire[1]),.in(sbit_wire[2]),.load_val(load_val[1]),.load_n(load_n),.shift(ShiftRight),.clk(clk),.reset_n(reset_n));
	shifterBitASYNCR sbit0(.out(sbit_wire[0]),.in(sbit_wire[1]),.load_val(load_val[0]),.load_n(load_n),.shift(ShiftRight),.clk(clk),.reset_n(reset_n));
endmodule

module shifterBitASYNCR(load_val, load_n, shift, in, out, clk, reset_n);
	input load_val, load_n, shift, in, clk, reset_n;
	output out;
	
	wire wire_ShiftOut, wireLoadOut;
	
	mux2to1 shift_mux(
			.x(out),
			.y(in),
			.s(shift),
			.m(wire_ShiftOut)
			);
			
	mux2to1 load_mux(
			.x(load_val),
			.y(wire_ShiftOut),
			.s(load_n),
			.m(wire_LoadOut)
			);
			
	flipflopASYNCR shift_flipflop(
				.q(out),
				.d(wire_LoadOut),
				.clock(clk),
				.reset_n(reset_n)
				);
endmodule

module flipflopASYNCR(q, d, clock, reset_n);//1 bit
	input d;
	input clock, reset_n;
	output reg q;
	
	always @(posedge clock, negedge reset_n)	//triggered when clock rises
	begin
		if(reset_n == 1'b0)	//when reset_n is 0...
			q <= 0;				//... q is set 0
		else						//when reset_n not 0...
			q <= d;				//... value d is passed to q
	end
endmodule