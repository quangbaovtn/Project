`timescale 1ns/100ps
`define USE_RAM
module counter (
	input clk,
	input reset,
	input enable,
	input preload,
	input updn,
	input [7:0] pl_data,
	input [3:0] incr,
`ifdef USE_RAM
	input  csb00,
	input  csb10,
	input  csb20,
	input  csb30,
	input  csb40,
	input  csb50,
	input  csb60,
	input  csb70,
	input web0,
	input [3:0] wmask0,
	input [7:0] addr0,
	input [31:0] din0,
`endif
	//input [31:0] table_ [0:255],
	//output reg [7:0] cout,
	output [31:0] sine_out
);
	reg [7:0] cout;

`ifndef USE_RAM
	reg [31:0] table_ [0:255];
	`include "table.vh"
	assign sine_out = table_[cout];
`else
	wire [7:0] temp_sine_out [0:7][0:3];
	reg [7:0] temp_sine_out_reg [0:7][0:3];
	reg [31:0] reg_sine_out;
	reg [7:0] cout_reg;
	reg [7:0] cout_reg2;
	wire [3:0] csb0[0:7];
	wire [7:0] din08[0:3];
	
	assign sine_out = reg_sine_out;
	assign csb0[0] = {csb00,csb00,csb00,csb00};
	assign csb0[1] = {csb10,csb10,csb10,csb10};
	assign csb0[2] = {csb20,csb20,csb20,csb20};
	assign csb0[3] = {csb30,csb30,csb30,csb30};
	assign csb0[4] = {csb40,csb40,csb40,csb40};
	assign csb0[5] = {csb50,csb50,csb50,csb50};
	assign csb0[6] = {csb60,csb60,csb60,csb60};
	assign csb0[7] = {csb70,csb70,csb70,csb70};
	//assign {din08[3],din08[2],din08[1],din08[0]} = din0;
	assign {din08[3],din08[2],din08[1],din08[0]} = din0;

	genvar i, j;
	generate
		for (i=0; i<8; i=i+1) begin
		for (j=0; j<4; j=j+1) begin
		sky130_sram_32byte_1rw1r_8x32_8 u_mem (
			.clk0(clk),
			.csb0(csb0[i][j]),
			.web0(web0),
			//.wmask0(wmask0),
			.addr0(addr0[4:0]),
			.din0(din08[j]),
			//.dout0(dout0),
			.clk1(clk),
			.csb1(1'b0),
			.addr1(cout[4:0]),
			.dout1(temp_sine_out[i][j])
		);
		always @(posedge clk) begin
			temp_sine_out_reg[i][j] <= temp_sine_out[i][j];
		end
		end
		end
	endgenerate

	always @(posedge clk) begin
		cout_reg2 <= cout_reg;
		cout_reg <=  cout;
	end

	always @(posedge clk or posedge reset) begin
		if (reset)
			reg_sine_out = 0;
		else begin
			case (cout_reg2[7:5])
				3'b000: reg_sine_out = {temp_sine_out_reg[0][3],temp_sine_out_reg[0][2],temp_sine_out_reg[0][1],temp_sine_out_reg[0][0]};
				3'b001: reg_sine_out = {temp_sine_out_reg[1][3],temp_sine_out_reg[1][2],temp_sine_out_reg[1][1],temp_sine_out_reg[1][0]};
				3'b010: reg_sine_out = {temp_sine_out_reg[2][3],temp_sine_out_reg[2][2],temp_sine_out_reg[2][1],temp_sine_out_reg[2][0]};
		       	        3'b011: reg_sine_out = {temp_sine_out_reg[3][3],temp_sine_out_reg[3][2],temp_sine_out_reg[3][1],temp_sine_out_reg[3][0]};
		       	        3'b100: reg_sine_out = {temp_sine_out_reg[4][3],temp_sine_out_reg[4][2],temp_sine_out_reg[4][1],temp_sine_out_reg[4][0]};
		       	        3'b101: reg_sine_out = {temp_sine_out_reg[5][3],temp_sine_out_reg[5][2],temp_sine_out_reg[5][1],temp_sine_out_reg[5][0]};
		       	        3'b110: reg_sine_out = {temp_sine_out_reg[6][3],temp_sine_out_reg[6][2],temp_sine_out_reg[6][1],temp_sine_out_reg[6][0]};
		       	        default: reg_sine_out = {temp_sine_out_reg[7][3],temp_sine_out_reg[7][2],temp_sine_out_reg[7][1],temp_sine_out_reg[7][0]};
			endcase
		end
	end
`endif

	always @(posedge clk or posedge reset) begin
		if (reset)
			cout <= 0;
		else if (preload)
			cout <= pl_data;
		else if (enable)
			if (updn)
				cout <= cout + incr;
			else
				cout <= cout - incr;
	end
endmodule
