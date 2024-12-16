`timescale 1ns/1ps
`define PERIOD 10
module tb;
	reg clk, reset;
	wire [7:0] qout;

	counter dut(
		.clk(clk),
		.reset(reset),
		.qout(qout)
	);
	task waitforclk (input integer n);
		begin
			repeat (n)
			@(posedge clk);
		end
	endtask

	initial begin
		clk = 0;
		forever begin
			#(`PERIOD/2) clk = ~clk;
		end
	end

	initial begin
		$dumpfile("tb.vcd");
		$dumpvars();
	end

	initial begin
		reset = 1;
		waitforclk(3);
		reset = 0;
		waitforclk(30);
		$finish();
	end
endmodule

