module counter(clk, reset, qout);
	input clk;
	input reset;
	output reg[7:0] qout;

	always @(posedge clk or posedge reset)
	begin
		if (reset)
			qout = 8'h0;
		else 
			qout <= qout + 8'h1;
	end
endmodule
