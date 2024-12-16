module counter(
	input clk,
	input reset,
	input enable,
        input preload,
        input updn,
        input [3:0] pl_data,
        input [3:0] incr,
        output reg [7:0] cout
);	

	always @(posedge clk or posedge reset) begin
                if (reset)
                        cout = 0;
                else if (preload)
                        cout = pl_data;
                else if (enable)
                        if (updn)
                                cout = cout + incr;
                        else
                                cout = cout - incr;
        end
endmodule
