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