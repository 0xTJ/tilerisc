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
    output reg  [63:0]                  dat_out,
    input  wire                         cyc,
    input  wire                         we,
    output wire                         ack,

    // Command port
    // input  wire [15:0]  command
    
    // output reg          busy
);

reg [1:0] mat_row [3:0];
reg [1:0] mat_col [3:0];

always @(*) begin
    case (vector_type)
        `VECTOR_TYPE_COL: begin
            mat_row[0] = 2'd0;
            mat_row[1] = 2'd1;
            mat_row[2] = 2'd2;
            mat_row[3] = 2'd3;
            mat_col[0] = vector_idx;
            mat_col[1] = vector_idx;
            mat_col[2] = vector_idx;
            mat_col[3] = vector_idx;
        end

        `VECTOR_TYPE_ROW: begin
            mat_row[0] = vector_idx;
            mat_row[1] = vector_idx;
            mat_row[2] = vector_idx;
            mat_row[3] = vector_idx;
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
            mat_col[0] = (2'd0 + vector_idx) % 4;
            mat_col[1] = (2'd1 + vector_idx) % 4;
            mat_col[2] = (2'd2 + vector_idx) % 4;
            mat_col[3] = (2'd3 + vector_idx) % 4;
        end

        `VECTOR_TYPE_ANTIDIAG: begin
            mat_row[0] = (2'd3 - vector_idx) % 4;
            mat_row[1] = (2'd2 - vector_idx) % 4;
            mat_row[2] = (2'd1 - vector_idx) % 4;
            mat_row[3] = (2'd0 - vector_idx) % 4;
            mat_col[0] = 2'd0;
            mat_col[1] = 2'd1;
            mat_col[2] = 2'd2;
            mat_col[3] = 2'd3;
        end
    endcase
end

mat_reg_file_mul mat_reg_file_mul (
    .clk (clk),

    .val_rd_mat_idx (),
    .val_rd_mat_rows ({mat_row[3], mat_row[2], mat_row[1], mat_row[0]}),
    .val_rd_mat_cols ({mat_col[3], mat_col[2], mat_col[1], mat_col[0]}),
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
    input  wire [$clog2(MAT_COUNT)-1:0]  mul_mat_idx,
    input  wire [63:0] mul_in,
    output reg  [63:0] mul_out,
);

//   bit             mat   row   col
reg [15:0] mat_regs [MAT_COUNT-1:0] [3:0] [3:0];

always @(*) begin
    val_rd_vals[ 0+:16] = mat_regs[val_rd_mat_idx][val_rd_mat_rows[0+:2]][val_rd_mat_cols[0+:2]];
    val_rd_vals[16+:16] = mat_regs[val_rd_mat_idx][val_rd_mat_rows[2+:2]][val_rd_mat_cols[2+:2]];
    val_rd_vals[32+:16] = mat_regs[val_rd_mat_idx][val_rd_mat_rows[4+:2]][val_rd_mat_cols[4+:2]];
    val_rd_vals[48+:16] = mat_regs[val_rd_mat_idx][val_rd_mat_rows[6+:2]][val_rd_mat_cols[6+:2]];

    mul_out[ 0+:16] =
        mat_regs[mul_mat_idx][0][0] * mul_in[ 0+:16] +
        mat_regs[mul_mat_idx][0][1] * mul_in[16+:16] +
        mat_regs[mul_mat_idx][0][2] * mul_in[32+:16] +
        mat_regs[mul_mat_idx][0][3] * mul_in[48+:16];
    mul_out[16+:16] =
        mat_regs[mul_mat_idx][1][0] * mul_in[ 0+:16] +
        mat_regs[mul_mat_idx][1][1] * mul_in[16+:16] +
        mat_regs[mul_mat_idx][1][2] * mul_in[32+:16] +
        mat_regs[mul_mat_idx][1][3] * mul_in[48+:16];
    mul_out[32+:16] =
        mat_regs[mul_mat_idx][2][0] * mul_in[ 0+:16] +
        mat_regs[mul_mat_idx][2][1] * mul_in[16+:16] +
        mat_regs[mul_mat_idx][2][2] * mul_in[32+:16] +
        mat_regs[mul_mat_idx][2][3] * mul_in[48+:16];
    mul_out[48+:16] =
        mat_regs[mul_mat_idx][3][0] * mul_in[ 0+:16] +
        mat_regs[mul_mat_idx][3][1] * mul_in[16+:16] +
        mat_regs[mul_mat_idx][3][2] * mul_in[32+:16] +
        mat_regs[mul_mat_idx][3][3] * mul_in[48+:16];
end

always @(posedge clk) begin
    if (we) begin
        mat_regs[val_wr_mat_idx][val_wr_mat_rows[0+:2]][val_wr_mat_cols[0+:2]] = val_wr_vals[ 0+:16];
        mat_regs[val_wr_mat_idx][val_wr_mat_rows[2+:2]][val_wr_mat_cols[2+:2]] = val_wr_vals[16+:16];
        mat_regs[val_wr_mat_idx][val_wr_mat_rows[4+:2]][val_wr_mat_cols[4+:2]] = val_wr_vals[32+:16];
        mat_regs[val_wr_mat_idx][val_wr_mat_rows[6+:2]][val_wr_mat_cols[6+:2]] = val_wr_vals[48+:16];
    end
end

endmodule
