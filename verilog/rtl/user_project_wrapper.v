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

    // Decoded Core Wishbone Slaves

    .tri_wbs_stb_i (tri_wbs_stb_i),
    .tri_wbs_ack_o (tri_wbs_ack_o),

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

    .gpu_clk (user_clock2),
    .y (y),
    .x_start (x_start),
    .x_end (x_end)
);

wire [63:0] tri_wbs_stb_i;
wire [63:0] tri_wbs_ack_o;

// wire [31:0] tri_wbs_dat_o [63:0];
wire [(64 * 8) - 1:0]  y;
wire [(64 * 8) - 1:0]  x_start;
wire [(64 * 8) - 1:0]  x_end;

genvar i;
generate
    for (i=0; i<64; i=i+1) begin
        interp_tri trip (
`ifdef USE_POWER_PINS
            .vdd (vdd),
            .vss (vss),
`endif

            .wb_clk_i (wb_clk_i),
            .wb_rst_i (wb_rst_i),
            .wbs_cyc_i (wbs_cyc_i),
            .wbs_stb_i (tri_wbs_stb_i[i]),
            .wbs_we_i (wbs_we_i),
            .wbs_sel_i (wbs_sel_i),
            .wbs_adr_i (wbs_adr_i[3:2]),
            .wbs_dat_i (wbs_dat_i),
            .wbs_ack_o (tri_wbs_ack_o[i]),

            .clk (user_clock2),
            .y (y[((i + 1) * 8) - 1:i * 8]),
            .x_start (x_start[((i + 1) * 8) - 1:i * 8]),
            .x_end (x_end[((i + 1) * 8) - 1:i * 8])
        );
    end 
endgenerate

endmodule

`default_nettype wire
