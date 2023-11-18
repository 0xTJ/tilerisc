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
    input wire wb_clk_i,

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


wire sel_render_b_not_a;

wire [7:0] line_a_addr;
reg [7:0] line_b_addr;
wire [7:0] render_pixel;
wire [7:0] display_pixel;

reg [7:0] gpu_pixel_in_d;
wire [7:0] gpu_pixel_out_r;
wire [7:0] gpu_pixel_out_g;
wire [7:0] gpu_pixel_out_b;
wire [7:0] gpu_pixel_out_d;

reg [7:0] display_pixel_out_r;
reg [7:0] display_pixel_out_g;
reg [7:0] display_pixel_out_b;

assign line_a_buf_r_clk     = wb_clk_i;
assign line_a_buf_r_a       = line_a_addr;
assign line_a_buf_r_d       = gpu_pixel_out_r;
assign line_a_buf_r_gwen    = 1'bx;
assign line_a_buf_r_cen     = 1'bx;
assign line_a_buf_r_wen     = 8'h00;

assign line_a_buf_g_clk     = wb_clk_i;
assign line_a_buf_g_a       = line_a_addr;
assign line_a_buf_g_d       = gpu_pixel_out_g;
assign line_a_buf_g_gwen    = 1'bx;
assign line_a_buf_g_cen     = 1'bx;
assign line_a_buf_g_wen     = 8'h00;

assign line_a_buf_b_clk     = wb_clk_i;
assign line_a_buf_b_a       = line_a_addr;
assign line_a_buf_b_d       = gpu_pixel_out_b;
assign line_a_buf_b_gwen    = 1'bx;
assign line_a_buf_b_cen     = 1'bx;
assign line_a_buf_b_wen     = 8'h00;

assign line_a_buf_d_clk     = wb_clk_i;
assign line_a_buf_d_a       = line_a_addr;
assign line_a_buf_d_d       = gpu_pixel_out_d;
assign line_a_buf_d_gwen    = 1'bx;
assign line_a_buf_d_cen     = 1'bx;
assign line_a_buf_d_wen     = 8'h00;

assign line_b_buf_r_clk     = wb_clk_i;
assign line_b_buf_r_a       = line_b_addr;
assign line_b_buf_r_d       = gpu_pixel_out_r;
assign line_b_buf_r_gwen    = 1'bx;
assign line_b_buf_r_cen     = 1'bx;
assign line_b_buf_r_wen     = 8'h00;

assign line_b_buf_g_clk     = wb_clk_i;
assign line_b_buf_g_a       = line_b_addr;
assign line_b_buf_g_d       = gpu_pixel_out_g;
assign line_b_buf_g_gwen    = 1'bx;
assign line_b_buf_g_cen     = 1'bx;
assign line_b_buf_g_wen     = 8'h00;

assign line_b_buf_b_clk     = wb_clk_i;
assign line_b_buf_b_a       = line_b_addr;
assign line_b_buf_b_d       = gpu_pixel_out_b;
assign line_b_buf_b_gwen    = 1'bx;
assign line_b_buf_b_cen     = 1'bx;
assign line_b_buf_b_wen     = 8'h00;

assign line_b_buf_d_clk     = wb_clk_i;
assign line_b_buf_d_a       = line_b_addr;
assign line_b_buf_d_d       = gpu_pixel_out_d;
assign line_b_buf_d_gwen    = 1'bx;
assign line_b_buf_d_cen     = 1'bx;
assign line_b_buf_d_wen     = 8'h00;

assign sel_render_b_not_a   = 1'bx;
assign render_pixel         = 8'hxx;
assign display_pixel        = 8'hxx;
assign gpu_pixel_out_r      = 8'hxx;
assign gpu_pixel_out_g      = 8'hxx;
assign gpu_pixel_out_b      = 8'hxx;
assign gpu_pixel_out_d      = 8'hxx;

always @(*) begin
    case (sel_render_b_not_a)
        1'b0: begin
            line_a_addr         = render_pixel;
            line_b_addr         = display_pixel;
            display_pixel_out_r = line_b_buf_r_q;
            display_pixel_out_g = line_b_buf_g_q;
            display_pixel_out_b = line_b_buf_b_q;
            gpu_pixel_in_d      = line_a_buf_d_q;
        end
        1'b1: begin
            line_a_addr         = display_pixel;
            line_b_addr         = render_pixel;
            display_pixel_out_r = line_a_buf_r_q;
            display_pixel_out_g = line_a_buf_g_q;
            display_pixel_out_b = line_a_buf_b_q;
            gpu_pixel_in_d      = line_b_buf_d_q;
        end
    endcase
end

endmodule

module gpu_core (
    input wire clk
);

endmodule

module interp_tri (
    input wire [9:0] y,

    input wire [9:0] A_x,
    input wire [9:0] A_y,
    input wire [9:0] A_z,
    input wire [9:0] B_x,
    input wire [9:0] B_y,
    input wire [9:0] B_z,
    input wire [9:0] C_x,
    input wire [9:0] C_y,
    input wire [9:0] C_z,
    input wire bflip,
    input wire signed [14:0] delta_t,

    output wire [9:0] x_start,
    output wire [9:0] x_end,

    input wire active_in,
    input wire [14:0] t_in,

    output wire active_out,
    output wire [14:0] t_out
);

// All t values are a 1.14 fixed-point value
// Use delta_t as signed 1.14 fixed-point, where +1 and -1 have the same effect

// Determine if this is the start and/or end of this triangle
reg is_first_line, is_last_line;
always @(*) begin
    if (bflip == 1'b0) begin
        is_first_line   = (y == A_y);
        is_last_line    = (y == B_y);
    end else begin
        is_first_line   = (y == B_y);
        is_last_line    = (y == A_y);
    end
end

// On the first line, reset to start the triangle
reg active_in_actual;
reg [14:0] t_in_actual;
always @(*) begin
    if (is_first_line) begin
        active_in_actual = 1'b1;
        t_in_actual = {bflip, {14{1'b0}}};
    end else begin
        active_in_actual = active_in;
        t_in_actual = t_in;
    end
end

// Half-step in t
wire [14:0] t;
assign t = t_in_actual + delta_t >>> 1;

wire [14:0] t_mul_A_x, t_mul_B_x, t_mul_C_x;
assign t_mul_A_x = ((t >> 10) * A_x) >> 5;
assign t_mul_B_x = ((t >> 10) * B_x) >> 5;
assign t_mul_C_x = ((t >> 10) * C_x) >> 5;
assign x_start  = A_x - t_mul_A_x + t_mul_C_x;
assign x_end    = A_x - t_mul_A_x + t_mul_B_x;

// Pass out values to be used on the next line
assign active_out = active_in_actual && !is_last_line;
assign t_out = t_in_actual + delta_t;

endmodule

`define FIXED_BITS 16
`define FIXED_BITS_START 0
`define FIXED_BITS_END (`FIXED_BITS_START + `FIXED_BITS - 1)
`define FIXED_BITS_RANGE `FIXED_BITS_END:`FIXED_BITS_START
`define FIXED_FRAC 14

`define V3_BITS 48
`define V3_BITS_START 0
`define V3_BITS_END 47
`define V3_BITS_RANGE 47:0
`define V3_BITS_X_START 0
`define V3_BITS_X_END 15
`define V3_BITS_X_RANGE 15:0
`define V3_BITS_Y_START 16
`define V3_BITS_Y_END 31
`define V3_BITS_Y_RANGE 31:16
`define V3_BITS_Z_START 32
`define V3_BITS_Z_END 47
`define V3_BITS_Z_RANGE 47:32

module add (
    input  wire signed [`FIXED_BITS_RANGE] a,
    input  wire signed [`FIXED_BITS_RANGE] b,
    output reg  signed [`FIXED_BITS_RANGE] y
);

wire signed [16:0] a_ext, b_ext;
reg  signed [16:0] y_ext;

assign a_ext = {1'b0, a};
assign b_ext = {1'b0, b};

always @(a_ext or b_ext) begin
    y_ext = a_ext + b_ext;
    // TODO: This assumes no overflow
    y = y_ext[15:0];
end

endmodule

module mul (
    input  wire signed [`FIXED_BITS_RANGE] a,
    input  wire signed [`FIXED_BITS_RANGE] b,
    output reg  signed [`FIXED_BITS_RANGE] y
);

wire signed [31:0] a_ext, b_ext;
reg  signed [31:0] y_ext;

assign a_ext = {16'h0000, a};
assign b_ext = {16'h0000, b};

always @(a_ext or b_ext) begin
    y_ext = (a_ext * b_ext) >> `FIXED_FRAC;
    // TODO: This assumes no overflow
    y = y_ext[15:0];
end

endmodule

module dot (
    input  wire signed [`V3_BITS_RANGE] a,
    input  wire signed [`V3_BITS_RANGE] b,
    output reg  signed [`FIXED_BITS_RANGE] y
);

wire signed [`FIXED_BITS_RANGE] a_x, a_y, a_z;
wire signed [`FIXED_BITS_RANGE] b_x, b_y, b_z;
wire signed [`FIXED_BITS_RANGE] tmp_x, tmp_y, tmp_z, tmp_x_y;

assign a_x = a[`V3_BITS_X_RANGE];
assign a_y = a[`V3_BITS_Y_RANGE];
assign a_z = a[`V3_BITS_Z_RANGE];
assign b_x = b[`V3_BITS_X_RANGE];
assign b_y = b[`V3_BITS_Y_RANGE];
assign b_z = b[`V3_BITS_Z_RANGE];

mul mul_x (.a (a_x), .b (b_x), .y (tmp_x));
mul mul_y (.a (a_y), .b (b_y), .y (tmp_y));
mul mul_z (.a (a_z), .b (b_z), .y (tmp_z));

add add_x_y (.a (tmp_x), .b (tmp_y), .y (tmp_x_y));
add add_x_y_z (.a (tmp_x_y), .b (tmp_z), .y (y));

endmodule
