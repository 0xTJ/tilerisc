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
/*
 *-------------------------------------------------------------
 *
 * tjrpu
 *
 *-------------------------------------------------------------
 */

// TODO: Handle as parameters?
localparam RAM_A_BITS = 8;
localparam RAM_D_BITS = 8;

module tjrpu (
`ifdef USE_POWER_PINS
    inout vdd,	// User area 1 5.0 V supply
    inout vss,	// User area 1 digital ground
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
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

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

    output wire                         line_a_buf_r_clk,
    output wire [(RAM_A_BITS - 1):0]    line_a_buf_r_a,
    output wire [(RAM_D_BITS - 1):0]    line_a_buf_r_d,
    input  wire [(RAM_D_BITS - 1):0]    line_a_buf_r_q,
    output wire                         line_a_buf_r_gwen,
    output wire                         line_a_buf_r_cen,
    output wire [(RAM_D_BITS - 1):0]    line_a_buf_r_wen,

    output wire                         line_a_buf_g_clk,
    output wire [(RAM_A_BITS - 1):0]    line_a_buf_g_a,
    output wire [(RAM_D_BITS - 1):0]    line_a_buf_g_d,
    input  wire [(RAM_D_BITS - 1):0]    line_a_buf_g_q,
    output wire                         line_a_buf_g_gwen,
    output wire                         line_a_buf_g_cen,
    output wire [(RAM_D_BITS - 1):0]    line_a_buf_g_wen,

    output wire                         line_a_buf_b_clk,
    output wire [(RAM_A_BITS - 1):0]    line_a_buf_b_a,
    output wire [(RAM_D_BITS - 1):0]    line_a_buf_b_d,
    input  wire [(RAM_D_BITS - 1):0]    line_a_buf_b_q,
    output wire                         line_a_buf_b_gwen,
    output wire                         line_a_buf_b_cen,
    output wire [(RAM_D_BITS - 1):0]    line_a_buf_b_wen,

    output wire                         line_a_buf_d_clk,
    output wire [(RAM_A_BITS - 1):0]    line_a_buf_d_a,
    output wire [(RAM_D_BITS - 1):0]    line_a_buf_d_d,
    input  wire [(RAM_D_BITS - 1):0]    line_a_buf_d_q,
    output wire                         line_a_buf_d_gwen,
    output wire                         line_a_buf_d_cen,
    output wire [(RAM_D_BITS - 1):0]    line_a_buf_d_wen,

    output wire                         line_b_buf_r_clk,
    output wire [(RAM_A_BITS - 1):0]    line_b_buf_r_a,
    output wire [(RAM_D_BITS - 1):0]    line_b_buf_r_d,
    input  wire [(RAM_D_BITS - 1):0]    line_b_buf_r_q,
    output wire                         line_b_buf_r_gwen,
    output wire                         line_b_buf_r_cen,
    output wire [(RAM_D_BITS - 1):0]    line_b_buf_r_wen,

    output wire                         line_b_buf_g_clk,
    output wire [(RAM_A_BITS - 1):0]    line_b_buf_g_a,
    output wire [(RAM_D_BITS - 1):0]    line_b_buf_g_d,
    input  wire [(RAM_D_BITS - 1):0]    line_b_buf_g_q,
    output wire                         line_b_buf_g_gwen,
    output wire                         line_b_buf_g_cen,
    output wire [(RAM_D_BITS - 1):0]    line_b_buf_g_wen,

    output wire                         line_b_buf_b_clk,
    output wire [(RAM_A_BITS - 1):0]    line_b_buf_b_a,
    output wire [(RAM_D_BITS - 1):0]    line_b_buf_b_d,
    input  wire [(RAM_D_BITS - 1):0]    line_b_buf_b_q,
    output wire                         line_b_buf_b_gwen,
    output wire                         line_b_buf_b_cen,
    output wire [(RAM_D_BITS - 1):0]    line_b_buf_b_wen,

    output wire                         line_b_buf_d_clk,
    output wire [(RAM_A_BITS - 1):0]    line_b_buf_d_a,
    output wire [(RAM_D_BITS - 1):0]    line_b_buf_d_d,
    input  wire [(RAM_D_BITS - 1):0]    line_b_buf_d_q,
    output wire                         line_b_buf_d_gwen,
    output wire                         line_b_buf_d_cen,
    output wire [(RAM_D_BITS - 1):0]    line_b_buf_d_wen
);

assign io_out = 16'b0;
assign io_oeb = 16'b0;
assign la_data_out = 64'b0;
assign wbs_ack_o = 1'b0;
assign wbs_dat_o = 32'b0;
assign irq = 3'b000;

gpu gpu (
`ifdef USE_POWER_PINS
    .vdd                (vdd),
    .vss                (vss),
`endif

    .wb_clk_i           (wb_clk_i),

    .line_a_buf_r_clk   (line_a_buf_r_clk),
    .line_a_buf_r_a     (line_a_buf_r_a),
    .line_a_buf_r_d     (line_a_buf_r_d),
    .line_a_buf_r_q     (line_a_buf_r_q),
    .line_a_buf_r_gwen  (line_a_buf_r_gwen),
    .line_a_buf_r_cen   (line_a_buf_r_cen),
    .line_a_buf_r_wen   (line_a_buf_r_wen),

    .line_a_buf_g_clk   (line_a_buf_g_clk),
    .line_a_buf_g_a     (line_a_buf_g_a),
    .line_a_buf_g_d     (line_a_buf_g_d),
    .line_a_buf_g_q     (line_a_buf_g_q),
    .line_a_buf_g_gwen  (line_a_buf_g_gwen),
    .line_a_buf_g_cen   (line_a_buf_g_cen),
    .line_a_buf_g_wen   (line_a_buf_g_wen),

    .line_a_buf_b_clk   (line_a_buf_b_clk),
    .line_a_buf_b_a     (line_a_buf_b_a),
    .line_a_buf_b_d     (line_a_buf_b_d),
    .line_a_buf_b_q     (line_a_buf_b_q),
    .line_a_buf_b_gwen  (line_a_buf_b_gwen),
    .line_a_buf_b_cen   (line_a_buf_b_cen),
    .line_a_buf_b_wen   (line_a_buf_b_wen),

    .line_a_buf_d_clk   (line_a_buf_d_clk),
    .line_a_buf_d_a     (line_a_buf_d_a),
    .line_a_buf_d_d     (line_a_buf_d_d),
    .line_a_buf_d_q     (line_a_buf_d_q),
    .line_a_buf_d_gwen  (line_a_buf_d_gwen),
    .line_a_buf_d_cen   (line_a_buf_d_cen),
    .line_a_buf_d_wen   (line_a_buf_d_wen),

    .line_b_buf_r_clk   (line_b_buf_r_clk),
    .line_b_buf_r_a     (line_b_buf_r_a),
    .line_b_buf_r_d     (line_b_buf_r_d),
    .line_b_buf_r_q     (line_b_buf_r_q),
    .line_b_buf_r_gwen  (line_b_buf_r_gwen),
    .line_b_buf_r_cen   (line_b_buf_r_cen),
    .line_b_buf_r_wen   (line_b_buf_r_wen),

    .line_b_buf_g_clk   (line_b_buf_g_clk),
    .line_b_buf_g_a     (line_b_buf_g_a),
    .line_b_buf_g_d     (line_b_buf_g_d),
    .line_b_buf_g_q     (line_b_buf_g_q),
    .line_b_buf_g_gwen  (line_b_buf_g_gwen),
    .line_b_buf_g_cen   (line_b_buf_g_cen),
    .line_b_buf_g_wen   (line_b_buf_g_wen),

    .line_b_buf_b_clk   (line_b_buf_b_clk),
    .line_b_buf_b_a     (line_b_buf_b_a),
    .line_b_buf_b_d     (line_b_buf_b_d),
    .line_b_buf_b_q     (line_b_buf_b_q),
    .line_b_buf_b_gwen  (line_b_buf_b_gwen),
    .line_b_buf_b_cen   (line_b_buf_b_cen),
    .line_b_buf_b_wen   (line_b_buf_b_wen),

    .line_b_buf_d_clk   (line_b_buf_d_clk),
    .line_b_buf_d_a     (line_b_buf_d_a),
    .line_b_buf_d_d     (line_b_buf_d_d),
    .line_b_buf_d_q     (line_b_buf_d_q),
    .line_b_buf_d_gwen  (line_b_buf_d_gwen),
    .line_b_buf_d_cen   (line_b_buf_d_cen),
    .line_b_buf_d_wen   (line_b_buf_d_wen)
);

endmodule

`default_nettype wire
