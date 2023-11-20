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

module gpu (
    input wire wb_clk_i
);

endmodule

module gpu_core (
);

endmodule

module interp_tri (
`ifdef USE_POWER_PINS
    inout vdd,	// User area 1 5.0 V supply
    inout vss,	// User area 1 digital ground
`endif

    input  wire wb_clk_i,
    input  wire wb_rst_i,
    input  wire wbs_stb_i,
    input  wire wbs_cyc_i,
    input  wire wbs_we_i,
    input  wire [3:0] wbs_sel_i,
    input  wire [31:0] wbs_dat_i,
    input  wire [3:2] wbs_adr_i,
    output reg  wbs_ack_o,
    // output reg  [31:0] wbs_dat_o,

    input wire clk,
    input wire [7:0] y,
    output wire [7:0] x_start,
    output wire [7:0] x_end
);

reg         [7:0]   a [1:0];
reg         [7:0]   b [1:0];
reg         [7:0]   c [1:0];
reg signed  [9:0]   delta_t;
reg                 bflip;

reg  [31:0] wbs_dat_o;

always @(*) begin
    wbs_ack_o = wbs_cyc_i && wbs_stb_i;
    if (wbs_cyc_i && wbs_stb_i) begin
        case (wbs_adr_i[3:2])
            2'b00: wbs_dat_o = {8'h00, a[1], 8'h00, a[0]};
            2'b01: wbs_dat_o = {8'h00, b[1], 8'h00, b[0]};
            2'b10: wbs_dat_o = {8'h00, c[1], 8'h00, c[0]};
            2'b11: wbs_dat_o = {15'h0000, bflip, 6'h0, delta_t};
        endcase
    end else begin
        wbs_dat_o = 32'hxxxxxxxx;
    end
end

always @(posedge wb_clk_i) begin
    if (wb_rst_i) begin
        a[0]    <= 8'h00;
        a[1]    <= 8'h00;
        b[0]    <= 8'h00;
        b[1]    <= 8'h00;
        c[0]    <= 8'h00;
        c[1]    <= 8'h00;
        delta_t <= 10'h00;
        bflip   <= 1'b0;
    end else if (wbs_cyc_i && wbs_stb_i && wbs_we_i) begin
        case (wbs_adr_i[3:2])
            2'b00: begin
                if (wbs_sel_i[0]) a[0][7:0]     <= wbs_dat_i[7:0];
                if (wbs_sel_i[2]) a[1][7:0]     <= wbs_dat_i[23:16];
            end
            2'b01: begin
                if (wbs_sel_i[0]) b[0][7:0]     <= wbs_dat_i[7:0];
                if (wbs_sel_i[2]) b[1][7:0]     <= wbs_dat_i[23:16];
            end
            2'b10: begin
                if (wbs_sel_i[0]) c[0][7:0]     <= wbs_dat_i[7:0];
                if (wbs_sel_i[2]) c[1][7:0]     <= wbs_dat_i[23:16];
            end
            2'b11: begin
                if (wbs_sel_i[0]) delta_t[7:0]  <= wbs_dat_i[7:0];
                if (wbs_sel_i[1]) delta_t[9:8]  <= wbs_dat_i[9:8];
                if (wbs_sel_i[2]) bflip         <= wbs_dat_i[16];
            end
        endcase
    end
end

// All t values are signed 2.8 fixed-point value

// Determine if this is the start and/or end of this triangle
reg is_first_line, is_last_line;
always @(*) begin
    if (bflip == 1'b0) begin
        is_first_line   = (y == a[1]);
        is_last_line    = (y == b[1]);
    end else begin
        is_first_line   = (y == b[1]);
        is_last_line    = (y == a[1]);
    end
end

reg active_reg;
reg signed [9:0] t_reg;

// On the first line, reset to start the triangle
reg active_in_actual;
reg [9:0] t_in_actual;
always @(*) begin
    if (is_first_line) begin
        active_in_actual = 1'b1;
        t_in_actual = {1'h0, bflip, 8'h00};
    end else begin
        active_in_actual = active_reg;
        t_in_actual = t_reg;
    end
end

// Half-step in t
wire signed [9:0] t;
assign t = t_in_actual + (delta_t >>> 1);

// TODO: This truncates everywhere

// Signed 10.4 fixed-point values
wire signed [13:0] t_ext;
reg  signed [13:0] t_mul_a_x, t_mul_b_x, t_mul_c_x;
reg signed [13:0] x_start_adj_fxp, x_end_adj_fxp;
assign t_ext = {{8{t[9]}}, t[9:4]};

reg signed [7:0] x_start_adj, x_end_adj;

always @(*) begin
    t_mul_a_x = t_ext * {6'b0, a[0]};
    t_mul_b_x = t_ext * {6'b0, b[0]};
    t_mul_c_x = t_ext * {6'b0, c[0]};

    x_start_adj_fxp = t_mul_c_x - t_mul_a_x;
    x_end_adj_fxp   = t_mul_b_x - t_mul_a_x;

    // TODO: Add checks
    x_start_adj = x_start_adj_fxp[11:4];
    x_end_adj   = x_end_adj_fxp[11:4];
end

always @(posedge clk) begin
    x_start <= a[0] + x_start_adj;
    x_end   <= a[0] + x_end_adj;

    // Update out values to be used on the next line
    active_reg  <= active_in_actual && !is_last_line;
    t_reg       <= t_in_actual + delta_t;
end

endmodule
