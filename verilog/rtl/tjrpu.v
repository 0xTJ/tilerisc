// SPDX-FileCopyrightText: 2023 Thomas Jager
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
/*
 *-------------------------------------------------------------
 *
 * tjrpu
 *
 *-------------------------------------------------------------
 */

`define MYRANMGE 63:0

module tjrpu (
`ifdef USE_POWER_PINS
    inout vdd,	// User area 5.0 V supply
    inout vss,	// User area digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output reg wbs_ack_o,
    output wire [31:0] wbs_dat_o,

    output reg  [`MYRANMGE] tri_wbs_stb_i,
    input  wire [`MYRANMGE] tri_wbs_ack_o,

    // Logic Analyzer Signals
    input  [63:0] la_data_in,
    output [63:0] la_data_out,
    input  [63:0] la_oenb,

    // IOs
    input  [15:0] io_in,
    output [15:0] io_out,
    output [15:0] io_oeb,

    // IRQ
    output [2:0] irq,

    input  wire gpu_clk,
    input  wire [(64 * 8) - 1:0]  y,
    input  wire [(64 * 8) - 1:0]  x_start,
    input  wire [(64 * 8) - 1:0]  x_end
);

assign wbs_dat_o = 32'h00000000;
assign io_out = 16'b0;
assign io_oeb = 16'b0;
assign la_data_out = 64'b0;
assign irq = 3'b000;

always @(*) begin
    tri_wbs_stb_i = {63'b0, wbs_stb_i} << wbs_adr_i[9:4];
    wbs_ack_o = tri_wbs_ack_o[wbs_adr_i[9:4]];
end

endmodule

`default_nettype wire
