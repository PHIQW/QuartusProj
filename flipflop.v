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