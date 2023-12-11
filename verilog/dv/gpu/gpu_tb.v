// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

`timescale 1 ns / 1 ps

module gpu_tb;
    reg wb_clk_i;
    reg wb_rst_i;
    reg wbs_stb_i;
    reg wbs_cyc_i;
    reg wbs_we_i;
    reg [3:0] wbs_sel_i;
    reg [31:0] wbs_dat_i;
    reg [31:2] wbs_adr_i;
    wire wbs_ack_o;
    wire [31:0] wbs_dat_o;

    reg next_wb_rst_i;
    reg next_wbs_stb_i;
    reg next_wbs_cyc_i;
    reg next_wbs_we_i;
    reg [3:0] next_wbs_sel_i;
    reg [31:0] next_wbs_dat_i;
    reg [31:2] next_wbs_adr_i;

    reg user_clock2;

	always #12.5 wb_clk_i <= (wb_clk_i === 1'b0);

	initial begin
		wb_clk_i = 1'b1;
	end

	initial begin
		$dumpfile("gpu.vcd");
		$dumpvars(0, gpu_tb);

		// Repeat cycles of 1000 clock edges as needed to complete testbench
		repeat (250) begin
			repeat (1000) @(posedge wb_clk_i);
			// $display("+1000 cycles");
		end
		$display("%c[1;31m",27);
		`ifdef GL
			$display ("Monitor: Timeout, Test GPU (GL) Failed");
		`else
			$display ("Monitor: Timeout, Test GPU (RTL) Failed");
		`endif
		$display("%c[0m",27);
		$finish;
	end

    initial begin
		$dumpfile("gpu.vcd");
		$dumpvars(0, gpu_tb);

		next_wbs_stb_i = 1'b0;
		next_wbs_cyc_i = 1'b0;
		
		#5;
		next_wb_rst_i = 1'b0;
		#25;
		next_wb_rst_i = 1'b1;
		#25;
		next_wb_rst_i = 1'b0;
		#50;

		next_wbs_sel_i = 4'b1111;

		// Test write
		next_wbs_cyc_i = 1'b1;
		next_wbs_adr_i = 30'b00;
		next_wbs_dat_i = 32'h1000_0000;
		next_wbs_we_i = 1'b1;
		next_wbs_stb_i = 1'b1;
		#25 while (!wbs_ack_o) #25;
		next_wbs_dat_i = 32'bx;
		next_wbs_stb_i = 1'b0;
		next_wbs_cyc_i = 1'b0;
		#25;
		#50;
		next_wbs_cyc_i = 1'b1;
		next_wbs_adr_i = 30'b01;
		next_wbs_dat_i = 32'h3000_2000;
		next_wbs_we_i = 1'b1;
		next_wbs_stb_i = 1'b1;
		#25 while (!wbs_ack_o) #25;
		next_wbs_dat_i = 32'bx;
		next_wbs_stb_i = 1'b0;
		next_wbs_cyc_i = 1'b0;
		#25;
		
		#50;

		// Test read
		next_wbs_cyc_i = 1'b1;
		next_wbs_adr_i = 30'b00;
		next_wbs_we_i = 1'b0;
		next_wbs_stb_i = 1'b1;
		#25 while (!wbs_ack_o) #25;
		next_wbs_stb_i = 1'b0;
		next_wbs_cyc_i = 1'b0;
		#25;
		#50;
		next_wbs_cyc_i = 1'b1;
		next_wbs_adr_i = 30'b01;
		next_wbs_we_i = 1'b0;
		next_wbs_stb_i = 1'b1;
		#25 while (!wbs_ack_o) #25;
		next_wbs_stb_i = 1'b0;
		next_wbs_cyc_i = 1'b0;
		#25;

		#50;

		// Test invald address
		next_wbs_cyc_i = 1'b1;
		next_wbs_adr_i = 30'b111100101010111100;
		next_wbs_we_i = 1'b0;
		next_wbs_stb_i = 1'b1;
		#25 while (!wbs_ack_o) #25;
		next_wbs_stb_i = 1'b0;
		next_wbs_cyc_i = 1'b0;
		#25;
		
		#50;

		// Fill matrix
		next_wbs_cyc_i = 1'b1;
		next_wbs_stb_i = 1'b1;
		next_wbs_we_i = 1'b1;
		//
		next_wbs_adr_i = 30'b00_00_0;
		next_wbs_dat_i = 32'h1000_0000;
		#25 while (!wbs_ack_o) #25;;
		next_wbs_adr_i = 30'b00_00_1;
		next_wbs_dat_i = 32'h3000_2000;
		#25 while (!wbs_ack_o) #25;
		//
		next_wbs_adr_i = 30'b00_01_0;
		next_wbs_dat_i = 32'h5000_4000;
		#25 while (!wbs_ack_o) #25;;
		next_wbs_adr_i = 30'b00_01_1;
		next_wbs_dat_i = 32'h7000_6000;
		#25 while (!wbs_ack_o) #25;
		//
		next_wbs_adr_i = 30'b00_10_0;
		next_wbs_dat_i = 32'h0100_0000;
		#25 while (!wbs_ack_o) #25;
		next_wbs_adr_i = 30'b00_10_1;
		next_wbs_dat_i = 32'h0300_0200;
		#25 while (!wbs_ack_o) #25;
		//
		next_wbs_adr_i = 30'b00_11_0;
		next_wbs_dat_i = 32'h0050_0040;
		#25 while (!wbs_ack_o) #25;;
		next_wbs_adr_i = 30'b00_11_1;
		next_wbs_dat_i = 32'h0070_0060;
		#25 while (!wbs_ack_o) #25;
		//
		next_wbs_dat_i = 32'bx;
		next_wbs_adr_i = 32'bx;
		next_wbs_we_i = 1'bx;
		next_wbs_stb_i = 1'b0;
		next_wbs_cyc_i = 1'b0;

		// Fill matrix
		next_wbs_cyc_i = 1'b1;
		next_wbs_stb_i = 1'b1;
		next_wbs_we_i = 1'b1;
		//
		next_wbs_adr_i = 30'b01_00_0;
		next_wbs_dat_i = 32'h0030_0040;
		#25 while (!wbs_ack_o) #25;;
		next_wbs_adr_i = 30'b01_00_1;
		next_wbs_dat_i = 32'h0010_0020;
		#25 while (!wbs_ack_o) #25;
		//
		next_wbs_dat_i = 32'bx;
		next_wbs_adr_i = 32'bx;
		next_wbs_we_i = 1'bx;
		next_wbs_stb_i = 1'b0;
		next_wbs_cyc_i = 1'b0;

		#50;

		// Test command
		next_wbs_cyc_i = 1'b1;
		next_wbs_adr_i = 30'b100000;
		next_wbs_dat_i = 32'b0010_10_00_01_00_00_00;
		next_wbs_we_i = 1'b1;
		next_wbs_stb_i = 1'b1;
		#25 while (!wbs_ack_o) #25;
		next_wbs_stb_i = 1'b0;
		next_wbs_cyc_i = 1'b0;
		#25;
		
		#50;

		// Read result
		next_wbs_cyc_i = 1'b1;
		next_wbs_adr_i = 30'b10_00_0;
		next_wbs_we_i = 1'b0;
		next_wbs_stb_i = 1'b1;
		#25 while (!wbs_ack_o) #25;
		next_wbs_stb_i = 1'b0;
		next_wbs_cyc_i = 1'b0;
		#25;
		#50;
		next_wbs_cyc_i = 1'b1;
		next_wbs_adr_i = 30'b10_00_1;
		next_wbs_we_i = 1'b0;
		next_wbs_stb_i = 1'b1;
		#25 while (!wbs_ack_o) #25;
		next_wbs_stb_i = 1'b0;
		next_wbs_cyc_i = 1'b0;
		#25;

		// #25;
		// stb = 1'b1;
		// #50;
		// stb = 1'b0;
		// #25;
		// command = 32'b0001_00_00_00_00_00_00;
		// data_in = 64'h3000_2000_1000_0000;
		// stb = 1'b1;
		// #50;
		// command = 32'b0001_00_01_00_00_00_00;
		// data_in = 64'h7000_6000_5000_4000;
		// stb = 1'b1;
		// #50;
		// command = 32'b0001_00_10_00_00_00_00;
		// data_in = 64'h0300_0200_0100_0000;
		// stb = 1'b1;
		// #50;
		// command = 32'b0001_00_11_00_00_00_00;
		// data_in = 64'h0070_0060_0050_0040;
		// stb = 1'b1;
		// #50;
		// command = 32'b0001_01_00_00_00_00_00;
		// data_in = 64'h0010_0020_0030_0040;
		// stb = 1'b1;
		// #50;
		// command = 32'b0010_10_00_01_00_00_00;
		// stb = 1'b1;
		// #50;
		// stb = 1'b0;
		// #200;
		// command = 32'b0000_00_00_10_00_00_00;
		// data_in = 64'hx;
		// stb = 1'b1;
		// #50;
		// stb = 1'b0;

		#20;
		$finish;
    end

	always @(posedge wb_clk_i) begin
		wb_rst_i 	<= next_wb_rst_i;
		wbs_stb_i 	<= next_wbs_stb_i;
		wbs_cyc_i 	<= next_wbs_cyc_i;
		wbs_we_i 	<= next_wbs_we_i;
		wbs_sel_i 	<= next_wbs_sel_i;
		wbs_dat_i 	<= next_wbs_dat_i;
		wbs_adr_i 	<= next_wbs_adr_i;
	end

	gpu uut (
		.wb_clk_i (wb_clk_i),
		.wb_rst_i (wb_rst_i),
		.wbs_stb_i (wbs_stb_i),
		.wbs_cyc_i (wbs_cyc_i),
		.wbs_we_i (wbs_we_i),
		.wbs_sel_i (wbs_sel_i),
		.wbs_dat_i (wbs_dat_i),
		.wbs_adr_i (wbs_adr_i),
		.wbs_ack_o (wbs_ack_o),
		.wbs_dat_o (wbs_dat_o),

		.user_clock2 (user_clock2)
	);

endmodule
`default_nettype wire
