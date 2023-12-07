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
	reg 		clk;
    reg  [31:0] command;
	reg  [63:0] data_in;
	wire [63:0] data_out;
	reg 		stb;
	wire 		ack;

	always #12.5 clk <= (clk === 1'b0);

	initial begin
		clk = 1'b1;
	end

	initial begin
		$dumpfile("gpu_core.vcd");
		$dumpvars(0, gpu_tb);

		// Repeat cycles of 1000 clock edges as needed to complete testbench
		repeat (250) begin
			repeat (1000) @(posedge clk);
			// $display("+1000 cycles");
		end
		$display("%c[1;31m",27);
		`ifdef GL
			$display ("Monitor: Timeout, Test LA (GL) Failed");
		`else
			$display ("Monitor: Timeout, Test LA (RTL) Failed");
		`endif
		$display("%c[0m",27);
		$finish;
	end

    initial begin
		command = 32'b0;
		data_in = 64'b0;
		stb = 1'b0;

		#25;
		stb = 1'b1;
		#50;
		stb = 1'b0;
		#25;
		command = 32'b0001_00_00_00_00_00_00;
		data_in = 64'h3000_2000_1000_0000;
		stb = 1'b1;
		#50;
		command = 32'b0001_00_01_00_00_00_00;
		data_in = 64'h7000_6000_5000_4000;
		stb = 1'b1;
		#50;
		command = 32'b0001_00_10_00_00_00_00;
		data_in = 64'h0300_0200_0100_0000;
		stb = 1'b1;
		#50;
		command = 32'b0001_00_11_00_00_00_00;
		data_in = 64'h0070_0060_0050_0040;
		stb = 1'b1;
		#50;
		command = 32'b0001_01_00_00_00_00_00;
		data_in = 64'h0010_0020_0030_0040;
		stb = 1'b1;
		#50;
		command = 32'b0010_10_00_01_00_00_00;
		stb = 1'b1;
		#50;
		stb = 1'b0;
		#200;
		command = 32'b0000_00_00_10_00_00_00;
		data_in = 64'hx;
		stb = 1'b1;
		#50;
		stb = 1'b0;
    end

	gpu_core uut (
        .clk (clk),
        .command (command),
        .data_in (data_in),
        .data_out (data_out),
        .stb (stb),
        .ack (ack)
	);

endmodule
`default_nettype wire
