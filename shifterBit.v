module flipflop(q, d, clock, reset_n);//1 bit
	input d;
	input clock, reset_n;
	output reg q;
	
	always @(posedge clock)	//triggered when clock rises
	begin
		if(reset_n == 1'b0)	//when reset_n is 0...
			q <= 0;				//... q is set 0
		else						//when reset_n not 0...
			q <= d;				//... value d is passed to q
	end
endmodule

module shifterBit(load_val, load_n, shift, in, out, clk, reset_n);
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
			
	flipflop shift_flipflop(
				.q(out),
				.d(wire_LoadOut),
				.clock(clk),
				.reset_n(reset_n)
				);
endmodule
