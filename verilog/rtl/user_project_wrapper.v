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
 * user_project_wrapper
 *
 * This wrapper enumerates all of the pins available to the
 * user for the user project.
 *
 * An example user project is provided in this wrapper.  The
 * example should be removed and replaced with the actual
 * user project.
 *
 *-------------------------------------------------------------
 */

// TODO: Handle as parameters?
localparam RAM_A_BITS = 8;
localparam RAM_D_BITS = 8;

module user_project_wrapper #(
    parameter BITS = 32
) (
`ifdef USE_POWER_PINS
    inout vdd,		// User area 5.0V supply
    inout vss,		// User area ground
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
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // Independent clock (on independent integer divider)
    input   user_clock2,

    // User maskable interrupt signals
    output [2:0] user_irq
);

/*--------------------------------------*/
/* User project is instantiated  here   */
/*--------------------------------------*/

tjrpu mprj (
`ifdef USE_POWER_PINS
	.vdd(vdd),	// User area 1 5.0 V power
	.vss(vss),	// User area 1 digital ground
`endif

    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),

    // MGMT SoC Wishbone Slave

    .wbs_cyc_i(wbs_cyc_i),
    .wbs_stb_i(wbs_stb_i),
    .wbs_we_i(wbs_we_i),
    .wbs_sel_i(wbs_sel_i),
    .wbs_adr_i(wbs_adr_i),
    .wbs_dat_i(wbs_dat_i),
    .wbs_ack_o(wbs_ack_o),
    .wbs_dat_o(wbs_dat_o),

    // Logic Analyzer

    .la_data_in(la_data_in),
    .la_data_out(la_data_out),
    .la_oenb (la_oenb),

    // IO Pads

    .io_in ({io_in[37:30],io_in[7:0]}),
    .io_out({io_out[37:30],io_out[7:0]}),
    .io_oeb({io_oeb[37:30],io_oeb[7:0]}),

    // IRQ
    .irq(user_irq),

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

wire                        line_a_buf_r_clk;
wire [(RAM_A_BITS - 1):0]   line_a_buf_r_a;
wire [(RAM_D_BITS - 1):0]   line_a_buf_r_d;
wire [(RAM_D_BITS - 1):0]   line_a_buf_r_q;
wire                        line_a_buf_r_gwen;
wire                        line_a_buf_r_cen;
wire [(RAM_D_BITS - 1):0]   line_a_buf_r_wen;

wire                        line_a_buf_g_clk;
wire [(RAM_A_BITS - 1):0]   line_a_buf_g_a;
wire [(RAM_D_BITS - 1):0]   line_a_buf_g_d;
wire [(RAM_D_BITS - 1):0]   line_a_buf_g_q;
wire                        line_a_buf_g_gwen;
wire                        line_a_buf_g_cen;
wire [(RAM_D_BITS - 1):0]   line_a_buf_g_wen;

wire                        line_a_buf_b_clk;
wire [(RAM_A_BITS - 1):0]   line_a_buf_b_a;
wire [(RAM_D_BITS - 1):0]   line_a_buf_b_d;
wire [(RAM_D_BITS - 1):0]   line_a_buf_b_q;
wire                        line_a_buf_b_gwen;
wire                        line_a_buf_b_cen;
wire [(RAM_D_BITS - 1):0]   line_a_buf_b_wen;

wire                        line_a_buf_d_clk;
wire [(RAM_A_BITS - 1):0]   line_a_buf_d_a;
wire [(RAM_D_BITS - 1):0]   line_a_buf_d_d;
wire [(RAM_D_BITS - 1):0]   line_a_buf_d_q;
wire                        line_a_buf_d_gwen;
wire                        line_a_buf_d_cen;
wire [(RAM_D_BITS - 1):0]   line_a_buf_d_wen;

wire                        line_b_buf_r_clk;
wire [(RAM_A_BITS - 1):0]   line_b_buf_r_a;
wire [(RAM_D_BITS - 1):0]   line_b_buf_r_d;
wire [(RAM_D_BITS - 1):0]   line_b_buf_r_q;
wire                        line_b_buf_r_gwen;
wire                        line_b_buf_r_cen;
wire [(RAM_D_BITS - 1):0]   line_b_buf_r_wen;

wire                        line_b_buf_g_clk;
wire [(RAM_A_BITS - 1):0]   line_b_buf_g_a;
wire [(RAM_D_BITS - 1):0]   line_b_buf_g_d;
wire [(RAM_D_BITS - 1):0]   line_b_buf_g_q;
wire                        line_b_buf_g_gwen;
wire                        line_b_buf_g_cen;
wire [(RAM_D_BITS - 1):0]   line_b_buf_g_wen;

wire                        line_b_buf_b_clk;
wire [(RAM_A_BITS - 1):0]   line_b_buf_b_a;
wire [(RAM_D_BITS - 1):0]   line_b_buf_b_d;
wire [(RAM_D_BITS - 1):0]   line_b_buf_b_q;
wire                        line_b_buf_b_gwen;
wire                        line_b_buf_b_cen;
wire [(RAM_D_BITS - 1):0]   line_b_buf_b_wen;

wire                        line_b_buf_d_clk;
wire [(RAM_A_BITS - 1):0]   line_b_buf_d_a;
wire [(RAM_D_BITS - 1):0]   line_b_buf_d_d;
wire [(RAM_D_BITS - 1):0]   line_b_buf_d_q;
wire                        line_b_buf_d_gwen;
wire                        line_b_buf_d_cen;
wire [(RAM_D_BITS - 1):0]   line_b_buf_d_wen;

gf180_ram_256x8_wrapper line_a_buf_r (
`ifdef USE_POWER_PINS
    .VDD    (vdd),
    .VSS    (vss),
`endif
    .CLK    (line_a_buf_r_clk),
    .A      (line_a_buf_r_a),
    .D      (line_a_buf_r_d),
    .Q      (line_a_buf_r_q),
    .GWEN   (line_a_buf_r_gwen),
    .CEN    (line_a_buf_r_cen),
    .WEN    (line_a_buf_r_wen)
);

gf180_ram_256x8_wrapper line_a_buf_g (
`ifdef USE_POWER_PINS
    .VDD    (vdd),
    .VSS    (vss),
`endif
    .CLK    (line_a_buf_g_clk),
    .A      (line_a_buf_g_a),
    .D      (line_a_buf_g_d),
    .Q      (line_a_buf_g_q),
    .GWEN   (line_a_buf_g_gwen),
    .CEN    (line_a_buf_g_cen),
    .WEN    (line_a_buf_g_wen)
);

gf180_ram_256x8_wrapper line_a_buf_b (
`ifdef USE_POWER_PINS
    .VDD    (vdd),
    .VSS    (vss),
`endif
    .CLK    (line_a_buf_b_clk),
    .A      (line_a_buf_b_a),
    .D      (line_a_buf_b_d),
    .Q      (line_a_buf_b_q),
    .GWEN   (line_a_buf_b_gwen),
    .CEN    (line_a_buf_b_cen),
    .WEN    (line_a_buf_b_wen)
);

gf180_ram_256x8_wrapper line_a_buf_d (
`ifdef USE_POWER_PINS
    .VDD    (vdd),
    .VSS    (vss),
`endif
    .CLK    (line_a_buf_d_clk),
    .A      (line_a_buf_d_a),
    .D      (line_a_buf_d_d),
    .Q      (line_a_buf_d_q),
    .GWEN   (line_a_buf_d_gwen),
    .CEN    (line_a_buf_d_cen),
    .WEN    (line_a_buf_d_wen)
);

gf180_ram_256x8_wrapper line_b_buf_r (
`ifdef USE_POWER_PINS
    .VDD    (vdd),
    .VSS    (vss),
`endif
    .CLK    (line_b_buf_r_clk),
    .A      (line_b_buf_r_a),
    .D      (line_b_buf_r_d),
    .Q      (line_b_buf_r_q),
    .GWEN   (line_b_buf_r_gwen),
    .CEN    (line_b_buf_r_cen),
    .WEN    (line_b_buf_r_wen)
);

gf180_ram_256x8_wrapper line_b_buf_g (
`ifdef USE_POWER_PINS
    .VDD    (vdd),
    .VSS    (vss),
`endif
    .CLK    (line_b_buf_g_clk),
    .A      (line_b_buf_g_a),
    .D      (line_b_buf_g_d),
    .Q      (line_b_buf_g_q),
    .GWEN   (line_b_buf_g_gwen),
    .CEN    (line_b_buf_g_cen),
    .WEN    (line_b_buf_g_wen)
);

gf180_ram_256x8_wrapper line_b_buf_b (
`ifdef USE_POWER_PINS
    .VDD    (vdd),
    .VSS    (vss),
`endif
    .CLK    (line_b_buf_b_clk),
    .A      (line_b_buf_b_a),
    .D      (line_b_buf_b_d),
    .Q      (line_b_buf_b_q),
    .GWEN   (line_b_buf_b_gwen),
    .CEN    (line_b_buf_b_cen),
    .WEN    (line_b_buf_b_wen)
);

gf180_ram_256x8_wrapper line_b_buf_d (
`ifdef USE_POWER_PINS
    .VDD    (vdd),
    .VSS    (vss),
`endif
    .CLK    (line_b_buf_d_clk),
    .A      (line_b_buf_d_a),
    .D      (line_b_buf_d_d),
    .Q      (line_b_buf_d_q),
    .GWEN   (line_b_buf_d_gwen),
    .CEN    (line_b_buf_d_cen),
    .WEN    (line_b_buf_d_wen)
);

endmodule

`default_nettype wire
