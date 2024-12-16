`timescale 1ns/1ps
//`define PERIOD 10
module tb (
	//input clk,
	//input reset,
);
	reg clk, reset, preload, enable, updn;
	reg [3:0] pl_data;
	reg [3:0] incr;
	wire [7:0] cout;
	wire clk_delay;
	/*
	reg [31:0] table_ [0:255];

	initial
		for (integer i=0; i<256; i=i+1) begin
		        table_[i] = $sin(i*$acos(-1)/128.0) * (2**31-1);
			$display("assign table_[%3d] = 32'H%h;", i, table_[i]);
		end
	*/
	assign #(`CLK_DELAY) clk_delay = clk;

	initial begin
		clk = 0;
		forever
			#(`PERIOD/2) clk = ~clk;
	end

	task waitforclk (input integer n);
		repeat (n)
			@(posedge clk_delay);
	endtask

	task preload_ (input [3:0] n);
	begin
		preload = 1;
		pl_data = n;
		@(posedge clk_delay);
		preload = 0;
	end
	endtask

	task stopforclk (input integer n);
	begin
		enable = 0;
		repeat (n)
			@(posedge clk_delay);
		enable = 1;
	end
	endtask

	counter dut (
		.clk(clk),
		.reset(reset),
		.enable(enable),
		.updn(updn),
		.preload(preload),
		.pl_data(pl_data),
		.incr(incr),
		//.table_(table_),
		.cout(cout)
	);

	//initial $display("Hello world\n");

	initial begin
		$dumpfile("counter.vcd");
		$dumpvars();
		incr = 1;
		preload = 0;
		pl_data = 0;
		enable = 1;
		updn = 1;
		reset = 1;
		waitforclk(3);
		reset = 0;
		waitforclk(26);
		preload_(5);
		waitforclk(10);
		preload_(2);
		waitforclk(10);
		stopforclk(10);
		incr = 1;
		waitforclk(100);
		//updn = 0;
		waitforclk(1000);
		incr = 2;
		waitforclk(1000);
		incr = 3;
		waitforclk(1000);
		incr = 4;
		waitforclk(1000);
		incr = 5;
		waitforclk(1000);
		incr = 6;
		waitforclk(1000);
		$finish();
	end
endmodule
