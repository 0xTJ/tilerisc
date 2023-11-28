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

// Each matrix has vectors addressable as:
// Row x4
// Col x4
// Diag x4
// Anti-diag x4

// Stores use a bit (where?) to decide whether to clear the rest of the matrix

// All values are 4.12 two's-complement fixed-point numbers

`define VECTOR_TYPE_COL         2'b00
`define VECTOR_TYPE_ROW         2'b01
`define VECTOR_TYPE_DIAG        2'b10
`define VECTOR_TYPE_ANTIDIAG    2'b11

module gpu_core #(
    parameter MAT_COUNT = 4
) (
    input  wire clk,

    // Data port
    input  wire [$clog2(MAT_COUNT)-1:0] dat_mat_idx,
    input  wire [1:0]                   dat_vector_type,
    input  wire [1:0]                   dat_vector_idx,
    input  wire [63:0]                  dat_in,
    output wire [63:0]                  dat_out,
    input  wire                         cyc,
    input  wire                         dat_we,
    // output wire                         ack,

    // Command port
    input  wire [15:0]                  command,
    input  wire                         com_we
    
    // output reg          busy
);

reg data_not_command;
reg  [63:0] reg_file_in;
wire [63:0] reg_file_out;

wire [$clog2(MAT_COUNT)-1:0] com_mul_mat_idx, com_mat_rd_idx, com_mat_wr_idx;
wire [1:0] com_col_idx;

assign com_col_idx     = command[0+:2];
assign com_mat_rd_idx  = command[2+:2];
assign com_mat_wr_idx  = command[4+:2];
assign com_mul_mat_idx = command[6+:2];

reg [$clog2(MAT_COUNT)-1:0] mat_rd_idx, mat_wr_idx;
reg [1:0] mat_row [3:0];
reg [1:0] mat_col [3:0];

wire [$clog2(MAT_COUNT)-1:0] mul_mat_idx;
wire [63:0] mul_in;
wire [63:0] mul_out;

assign mul_mat_idx = com_mul_mat_idx;
assign mul_in = reg_file_out;
assign dat_out = reg_file_out;

always @(*) begin
    data_not_command = cyc;

    if (data_not_command) begin
        mat_rd_idx = dat_mat_idx;
        mat_wr_idx = dat_mat_idx;
        reg_file_in = dat_in;

        case (dat_vector_type)
            `VECTOR_TYPE_COL: begin
                mat_row[0] = 2'd0;
                mat_row[1] = 2'd1;
                mat_row[2] = 2'd2;
                mat_row[3] = 2'd3;
                mat_col[0] = dat_vector_idx;
                mat_col[1] = dat_vector_idx;
                mat_col[2] = dat_vector_idx;
                mat_col[3] = dat_vector_idx;
            end

            `VECTOR_TYPE_ROW: begin
                mat_row[0] = dat_vector_idx;
                mat_row[1] = dat_vector_idx;
                mat_row[2] = dat_vector_idx;
                mat_row[3] = dat_vector_idx;
                mat_col[0] = 2'd0;
                mat_col[1] = 2'd1;
                mat_col[2] = 2'd2;
                mat_col[3] = 2'd3;
            end

            `VECTOR_TYPE_DIAG: begin
                mat_row[0] = 2'd0;
                mat_row[1] = 2'd1;
                mat_row[2] = 2'd2;
                mat_row[3] = 2'd3;
                mat_col[0] = (2'd0 + dat_vector_idx) & 2'd3;
                mat_col[1] = (2'd1 + dat_vector_idx) & 2'd3;
                mat_col[2] = (2'd2 + dat_vector_idx) & 2'd3;
                mat_col[3] = (2'd3 + dat_vector_idx) & 2'd3;
            end

            `VECTOR_TYPE_ANTIDIAG: begin
                mat_row[0] = (2'd3 - dat_vector_idx) & 2'd3;
                mat_row[1] = (2'd2 - dat_vector_idx) & 2'd3;
                mat_row[2] = (2'd1 - dat_vector_idx) & 2'd3;
                mat_row[3] = (2'd0 - dat_vector_idx) & 2'd3;
                mat_col[0] = 2'd0;
                mat_col[1] = 2'd1;
                mat_col[2] = 2'd2;
                mat_col[3] = 2'd3;
            end
        endcase
    end else begin
        mat_rd_idx = com_mat_rd_idx;
        mat_wr_idx = com_mat_wr_idx;
        reg_file_in = mul_out;

        mat_row[0] = 2'd0;
        mat_row[1] = 2'd1;
        mat_row[2] = 2'd2;
        mat_row[3] = 2'd3;
        mat_col[0] = com_col_idx;
        mat_col[1] = com_col_idx;
        mat_col[2] = com_col_idx;
        mat_col[3] = com_col_idx;
    end
end

mat_reg_file_mul mat_reg_file_mul (
    .clk (clk),
    .we  (data_not_command ? dat_we : com_we),

    .val_rd_mat_idx (mat_rd_idx),
    .val_rd_mat_rows ({mat_row[3], mat_row[2], mat_row[1], mat_row[0]}),
    .val_rd_mat_cols ({mat_col[3], mat_col[2], mat_col[1], mat_col[0]}),
    .val_rd_vals (reg_file_out),

    .val_wr_mat_idx (mat_wr_idx),
    .val_wr_mat_rows ({mat_row[3], mat_row[2], mat_row[1], mat_row[0]}),
    .val_wr_mat_cols ({mat_col[3], mat_col[2], mat_col[1], mat_col[0]}),
    .val_wr_vals (reg_file_in),

    .mul_mat_idx (mul_mat_idx),
    .mul_in (mul_in),
    .mul_out (mul_out)
);

endmodule

module mat_reg_file_mul #(
    parameter MAT_COUNT = 4
) (
    // Value control
    input  wire clk,
    input  wire we,

    input  wire [$clog2(MAT_COUNT)-1:0] val_rd_mat_idx,
    input  wire [7:0] val_rd_mat_rows,
    input  wire [7:0] val_rd_mat_cols,
    output wire [63:0] val_rd_vals,
    
    input  wire [$clog2(MAT_COUNT)-1:0] val_wr_mat_idx,
    input  wire [7:0] val_wr_mat_rows,
    input  wire [7:0] val_wr_mat_cols,
    input  reg  [63:0] val_wr_vals,

    // Multiplier control
    input  wire [$clog2(MAT_COUNT)-1:0] mul_mat_idx,
    input  wire [63:0] mul_in,
    output wire [63:0] mul_out
);

//   bit             mat   row   col
reg [15:0] mat_regs [MAT_COUNT-1:0] [3:0] [3:0];

always @(*) begin
    val_rd_vals[ 0+:16] = mat_regs[val_rd_mat_idx][val_rd_mat_rows[0+:2]][val_rd_mat_cols[0+:2]];
    val_rd_vals[16+:16] = mat_regs[val_rd_mat_idx][val_rd_mat_rows[2+:2]][val_rd_mat_cols[2+:2]];
    val_rd_vals[32+:16] = mat_regs[val_rd_mat_idx][val_rd_mat_rows[4+:2]][val_rd_mat_cols[4+:2]];
    val_rd_vals[48+:16] = mat_regs[val_rd_mat_idx][val_rd_mat_rows[6+:2]][val_rd_mat_cols[6+:2]];
end

dot_4p12 mul0 (
    {mat_regs[mul_mat_idx][0][3], mat_regs[mul_mat_idx][0][2], mat_regs[mul_mat_idx][0][1], mat_regs[mul_mat_idx][0][0]},
    mul_in,
    mul_out[ 0+:16]
);

dot_4p12 mul1 (
    {mat_regs[mul_mat_idx][1][3], mat_regs[mul_mat_idx][1][2], mat_regs[mul_mat_idx][1][1], mat_regs[mul_mat_idx][1][0]},
    mul_in,
    mul_out[16+:16]
);

dot_4p12 mul2 (
    {mat_regs[mul_mat_idx][2][3], mat_regs[mul_mat_idx][2][2], mat_regs[mul_mat_idx][2][1], mat_regs[mul_mat_idx][2][0]},
    mul_in,
    mul_out[32+:16]
);

dot_4p12 mul3 (
    {mat_regs[mul_mat_idx][3][3], mat_regs[mul_mat_idx][3][2], mat_regs[mul_mat_idx][3][1], mat_regs[mul_mat_idx][3][0]},
    mul_in,
    mul_out[48+:16]
);

always @(posedge clk) begin
    if (we) begin
        mat_regs[val_wr_mat_idx][val_wr_mat_rows[0+:2]][val_wr_mat_cols[0+:2]] <= val_wr_vals[ 0+:16];
        mat_regs[val_wr_mat_idx][val_wr_mat_rows[2+:2]][val_wr_mat_cols[2+:2]] <= val_wr_vals[16+:16];
        mat_regs[val_wr_mat_idx][val_wr_mat_rows[4+:2]][val_wr_mat_cols[4+:2]] <= val_wr_vals[32+:16];
        mat_regs[val_wr_mat_idx][val_wr_mat_rows[6+:2]][val_wr_mat_cols[6+:2]] <= val_wr_vals[48+:16];
    end
end

endmodule

module dot_4p12 (
    input  wire [63:0] in1, // 4x two's complement 4.12
    input  wire [63:0] in2, // 4x two's complement 4.12
    output wire [15:0] out  // 1x two's complement 4.12
);

// Two's complement 8.24
wire signed [31:0] in1_ext [3:0], in2_ext [3:0];
wire signed [31:0] mul [3:0];

// Two's complement 10.24
wire signed [33:0] mul_ext [3:0];
wire signed [33:0] sum_ext, sum_round_ext;

// Two's complement 4.12
reg  signed [15:0] sum;

assign in1_ext[0] = {16'b0, in1[ 0+:16]};
assign in1_ext[1] = {16'b0, in1[16+:16]};
assign in1_ext[2] = {16'b0, in1[32+:16]};
assign in1_ext[3] = {16'b0, in1[48+:16]};
assign in2_ext[0] = {16'b0, in2[ 0+:16]};
assign in2_ext[1] = {16'b0, in2[16+:16]};
assign in2_ext[2] = {16'b0, in2[32+:16]};
assign in2_ext[3] = {16'b0, in2[48+:16]};

assign mul[0] = in1_ext[0] * in2_ext[0];
assign mul[1] = in1_ext[1] * in2_ext[1];
assign mul[2] = in1_ext[2] * in2_ext[2];
assign mul[3] = in1_ext[3] * in2_ext[3];

assign mul_ext[0] = {2'b0, mul[0]};
assign mul_ext[1] = {2'b0, mul[1]};
assign mul_ext[2] = {2'b0, mul[2]};
assign mul_ext[3] = {2'b0, mul[3]};

assign sum_ext = mul_ext[3] + mul_ext[2] + mul_ext[1] + mul_ext[0];
assign sum_round_ext = (sum_ext + 34'h800) & ~34'hFFF;

always @(*) begin
    // Saturate if needed
    if (sum_round_ext >= $signed({{6{1'b0}}, 16'h8_000, 12'b0})) begin
        sum = 16'h7_FFF;
    end else if (sum_round_ext < $signed({{6{1'b1}}, 16'h8_000, 12'b0})) begin
        sum = 16'h8_000;
    end else begin
        sum = sum_round_ext[27:12];
    end
end

assign out = sum;

endmodule
