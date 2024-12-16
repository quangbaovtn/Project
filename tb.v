`timescale 1ns/1ps
`define PERIOD 10
module tb (
        //input clk,
        //input reset,
);
        reg clk, reset, preload, enable, updn;
        reg [3:0] pl_data;
        reg [3:0] incr;
        wire [7:0] cout;
        wire clk_delay;

        assign clk_delay = clk;

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
                .cout(cout)
        );


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
                incr = 4;
                waitforclk(100);
                updn = 0;
                waitforclk(100);
                $finish();
        end
endmodule

