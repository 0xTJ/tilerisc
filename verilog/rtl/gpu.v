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

// Stores use a bit (where?) to decide whether to clear the rest of the matrix

// All values are 4.12 two's-complement fixed-point numbers

// Note that repeated use of a matrix in a command will select only one column of all used.

`define MAT_BITS ($clog2(MAT_COUNT))

`define GPU_CORE_STATE_IDLE             16'b0000000000000001
`define GPU_CORE_STATE_MUL_MAT_VEC_0    16'b0000000000000010
`define GPU_CORE_STATE_MUL_MAT_VEC_1    16'b0000000000000100
`define GPU_CORE_STATE_MUL_MAT_VEC_2    16'b0000000000001000
`define GPU_CORE_STATE_MUL_MAT_VEC_3    16'b0000000000010000
`define GPU_CORE_STATE_MUL_MAT_VEC_4    16'b0000000000100000
`define GPU_CORE_STATE_DATA_READ        16'b0000001000000000
`define GPU_CORE_STATE_DATA_WRITE       16'b0000010000000000

`define COMMAND_OP_DATA_READ    4'b0000
`define COMMAND_OP_DATA_WRITE   4'b0001
`define COMMAND_OP_MUL_MAT_VEC  4'b0010

module gpu (
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

    input wire user_clock2
);

gpu_core gpu_core (

);

endmodule

module gpu_core #(
    parameter                   MAT_COUNT = 4
) (
    input  wire                 clk,

    input  wire [31:0]          command,
    input  wire [63:0]          data_in,
    output reg  [63:0]          data_out,
    input  wire                 stb,
    output reg                  ack
);

reg [15:0] state;
reg [15:0] next_state;

reg         next_fmadd_reset_sum;
reg         next_fmadd_do_acc;
reg  [63:0] next_fmadd_in1;
reg  [15:0] next_fmadd_in2;

reg         fmadd_reset_sum;
reg         fmadd_do_acc;
reg  [63:0] fmadd_in1;
reg  [15:0] fmadd_in2;
wire [63:0] fmadd_out;

wire [3:0]              command_op;
wire [1:0]              command_mat_a_col_idx;
wire [`MAT_BITS-1:0]    command_mat_a_idx;
wire [1:0]              command_mat_b_col_idx;
wire [`MAT_BITS-1:0]    command_mat_b_idx;
wire [1:0]              command_mat_c_col_idx;
wire [`MAT_BITS-1:0]    command_mat_c_idx;

reg next_ack;

reg  [MAT_COUNT-1:0]    mat_we;
reg  [1:0]              mat_col_idx [MAT_COUNT-1:0];
reg  [63:0]             mat_col_in;
wire [63:0]             mat_col_out [MAT_COUNT-1:0];

assign command_op               = command[((`MAT_BITS+2)*3)+:4];
assign command_mat_a_col_idx    = command[(`MAT_BITS*0+0)+:2];
assign command_mat_a_idx        = command[(`MAT_BITS*0+2)+:`MAT_BITS];
assign command_mat_b_col_idx    = command[(`MAT_BITS*1+2)+:2];
assign command_mat_b_idx        = command[(`MAT_BITS*1+4)+:`MAT_BITS];
assign command_mat_c_col_idx    = command[(`MAT_BITS*2+4)+:2];
assign command_mat_c_idx        = command[(`MAT_BITS*2+6)+:`MAT_BITS];

reg [1:0]               next_mat_a_col_idx;
reg [`MAT_BITS-1:0]     next_mat_a_idx;
reg [1:0]               next_mat_b_col_idx;
reg [`MAT_BITS-1:0]     next_mat_b_idx;
reg [1:0]               next_mat_c_col_idx;
reg [`MAT_BITS-1:0]     next_mat_c_idx;

reg [1:0]               mat_a_col_idx;
reg [`MAT_BITS-1:0]     mat_a_idx;
reg [1:0]               mat_b_col_idx;
reg [`MAT_BITS-1:0]     mat_b_idx;
reg [1:0]               mat_c_col_idx;
reg [`MAT_BITS-1:0]     mat_c_idx;

always @(*) begin
    mat_col_idx[0] = 2'bx;
    mat_col_idx[1] = 2'bx;
    mat_col_idx[2] = 2'bx;
    mat_col_idx[3] = 2'bx;
    mat_col_idx[mat_a_idx] = mat_a_col_idx;
    mat_col_idx[mat_b_idx] = mat_b_col_idx;
    mat_col_idx[mat_c_idx] = mat_c_col_idx;
end

always @(*) begin
    mat_we = 4'b0;
    mat_col_in = 64'bx;

    next_fmadd_in1 = 64'bx;
    next_fmadd_in2 = 16'bx;
    next_fmadd_reset_sum = 1'b0;
    next_fmadd_do_acc = 1'b0;

    data_out = 64'bx;

    case (state)
        `GPU_CORE_STATE_MUL_MAT_VEC_0: begin
            next_fmadd_reset_sum = 1'b1;
            next_fmadd_do_acc = 1'b1;
            next_fmadd_in1 = mat_col_out[mat_a_idx];
            next_fmadd_in2 = mat_col_out[mat_b_idx][ 0+:16];
        end

        `GPU_CORE_STATE_MUL_MAT_VEC_1: begin
            next_fmadd_reset_sum = 1'b0;
            next_fmadd_do_acc = 1'b1;
            next_fmadd_in1 = mat_col_out[mat_a_idx];
            next_fmadd_in2 = mat_col_out[mat_b_idx][16+:16];
        end

        `GPU_CORE_STATE_MUL_MAT_VEC_2: begin
            next_fmadd_reset_sum = 1'b0;
            next_fmadd_do_acc = 1'b1;
            next_fmadd_in1 = mat_col_out[mat_a_idx];
            next_fmadd_in2 = mat_col_out[mat_b_idx][32+:16];
        end

        `GPU_CORE_STATE_MUL_MAT_VEC_3: begin
            next_fmadd_reset_sum = 1'b0;
            next_fmadd_do_acc = 1'b1;
            next_fmadd_in1 = mat_col_out[mat_a_idx];
            next_fmadd_in2 = mat_col_out[mat_b_idx][48+:16];
        end

        `GPU_CORE_STATE_MUL_MAT_VEC_4: begin
            mat_col_in = fmadd_out;
            mat_we[mat_c_idx] = 1'b1;
        end

        `GPU_CORE_STATE_DATA_READ: begin
            data_out = mat_col_out[mat_b_idx];
        end

        `GPU_CORE_STATE_DATA_WRITE: begin
            mat_col_in = data_in;
            mat_we[mat_c_idx] = 1'b1;
        end
    endcase
end

always @(*) begin
    next_mat_a_col_idx  = 2'bx;
    next_mat_a_idx      = {`MAT_BITS{1'bx}};
    next_mat_b_col_idx  = 2'bx;
    next_mat_b_idx      = {`MAT_BITS{1'bx}};
    next_mat_c_col_idx  = 2'bx;
    next_mat_c_idx      = {`MAT_BITS{1'bx}};
    next_ack = 1'b0;

    case (state)
        `GPU_CORE_STATE_IDLE: begin
            if (stb) begin
                case (command_op)
                    `COMMAND_OP_DATA_READ: begin
                        next_state = `GPU_CORE_STATE_DATA_READ;
                        next_mat_b_col_idx = command_mat_b_col_idx;
                        next_mat_b_idx = command_mat_b_idx;
                        next_ack = 1'b1;
                    end
    
                    `COMMAND_OP_DATA_WRITE: begin
                        next_state = `GPU_CORE_STATE_DATA_WRITE;
                        next_mat_c_col_idx = command_mat_c_col_idx;
                        next_mat_c_idx = command_mat_c_idx;
                        next_ack = 1'b1;
                    end

                    `COMMAND_OP_MUL_MAT_VEC: begin
                        next_state = `GPU_CORE_STATE_MUL_MAT_VEC_0;
                        next_mat_a_col_idx  = 2'd0;
                        next_mat_a_idx      = command_mat_a_idx;
                        next_mat_b_col_idx  = command_mat_b_col_idx;
                        next_mat_b_idx      = command_mat_b_idx;
                        next_mat_c_col_idx  = command_mat_c_col_idx;
                        next_mat_c_idx      = command_mat_c_idx;
                        next_ack = 1'b1;
                    end

                    default: begin
                        // Invalid command, ignore it
                        next_state = `GPU_CORE_STATE_IDLE;
                        next_ack = 1'b1;
                    end
                endcase
            end else begin
                next_state = `GPU_CORE_STATE_IDLE;
            end
        end

        `GPU_CORE_STATE_MUL_MAT_VEC_0: begin
            next_state = `GPU_CORE_STATE_MUL_MAT_VEC_1;
            next_mat_a_col_idx  = 2'd1;
            next_mat_a_idx      = mat_a_idx;
            next_mat_b_col_idx  = mat_b_col_idx;
            next_mat_b_idx      = mat_b_idx;
            next_mat_c_col_idx  = mat_c_col_idx;
            next_mat_c_idx      = mat_c_idx;
        end
        
        `GPU_CORE_STATE_MUL_MAT_VEC_1: begin
            next_state = `GPU_CORE_STATE_MUL_MAT_VEC_2;
            next_mat_a_col_idx  = 2'd2;
            next_mat_a_idx      = mat_a_idx;
            next_mat_b_col_idx  = mat_b_col_idx;
            next_mat_b_idx      = mat_b_idx;
            next_mat_c_col_idx  = mat_c_col_idx;
            next_mat_c_idx      = mat_c_idx;
        end
        
        `GPU_CORE_STATE_MUL_MAT_VEC_2: begin
            next_state = `GPU_CORE_STATE_MUL_MAT_VEC_3;
            next_mat_a_col_idx  = 2'd3;
            next_mat_a_idx      = mat_a_idx;
            next_mat_b_col_idx  = mat_b_col_idx;
            next_mat_b_idx      = mat_b_idx;
            next_mat_c_col_idx  = mat_c_col_idx;
            next_mat_c_idx      = mat_c_idx;
        end
        
        `GPU_CORE_STATE_MUL_MAT_VEC_3: begin
            next_state = `GPU_CORE_STATE_MUL_MAT_VEC_4;
            next_mat_c_col_idx  = mat_c_col_idx;
            next_mat_c_idx      = mat_c_idx;
        end
        
        `GPU_CORE_STATE_MUL_MAT_VEC_4: begin
            next_state = `GPU_CORE_STATE_IDLE;
        end
        
        `GPU_CORE_STATE_DATA_READ: begin
            next_state = `GPU_CORE_STATE_IDLE;
        end
        
        `GPU_CORE_STATE_DATA_WRITE: begin
            next_state = `GPU_CORE_STATE_IDLE;
        end
        
        default: begin
            next_state = `GPU_CORE_STATE_IDLE;
        end
    endcase
end

always @(posedge clk) begin
    mat_a_col_idx  <= next_mat_a_col_idx;
    mat_a_idx      <= next_mat_a_idx;
    mat_b_col_idx  <= next_mat_b_col_idx;
    mat_b_idx      <= next_mat_b_idx;
    mat_c_col_idx  <= next_mat_c_col_idx;
    mat_c_idx      <= next_mat_c_idx;

    fmadd_reset_sum <= next_fmadd_reset_sum;
    fmadd_do_acc    <= next_fmadd_do_acc;
    fmadd_in1       <= next_fmadd_in1;
    fmadd_in2       <= next_fmadd_in2;

    ack <= next_ack;
    state <= next_state;
end

mat_reg mat0 (
    .clk (clk),
    .we (mat_we[0]),
    .col_idx (mat_col_idx[0]),
    .col_in (mat_col_in),
    .col_out (mat_col_out[0])
);

mat_reg mat1 (
    .clk (clk),
    .we (mat_we[1]),
    .col_idx (mat_col_idx[1]),
    .col_in (mat_col_in),
    .col_out (mat_col_out[1])
);

mat_reg mat2 (
    .clk (clk),
    .we (mat_we[2]),
    .col_idx (mat_col_idx[2]),
    .col_in (mat_col_in),
    .col_out (mat_col_out[2])
);

mat_reg mat3 (
    .clk (clk),
    .we (mat_we[3]),
    .col_idx (mat_col_idx[3]),
    .col_in (mat_col_in),
    .col_out (mat_col_out[3])
);

fmadd_4p12x4 fmadd (
    .clk (clk),
    .reset_sum (fmadd_reset_sum),
    .do_acc (fmadd_do_acc),
    .in1 (fmadd_in1),
    .in2 (fmadd_in2),
    .out (fmadd_out)
);

endmodule

module fmadd_4p12x4 (
    input  wire         clk,
    input  wire         reset_sum,
    input  wire         do_acc,
    input  wire [63:0]  in1,    // 4x two's complement 4.12
    input  wire [15:0]  in2,    // 1x two's complement 4.12
    output wire [63:0]  out     // 4x two's complement 4.12
);

fmadd_4p12 fmadd0 (
    .clk (clk),
    .reset_sum (reset_sum),
    .do_acc (do_acc),
    .in1 (in1[ 0+:16]),
    .in2 (in2),
    .out (out[ 0+:16])
);

fmadd_4p12 fmadd1 (
    .clk (clk),
    .reset_sum (reset_sum),
    .do_acc (do_acc),
    .in1 (in1[16+:16]),
    .in2 (in2),
    .out (out[16+:16])
);

fmadd_4p12 fmadd2 (
    .clk (clk),
    .reset_sum (reset_sum),
    .do_acc (do_acc),
    .in1 (in1[32+:16]),
    .in2 (in2),
    .out (out[32+:16])
);

fmadd_4p12 fmadd3 (
    .clk (clk),
    .reset_sum (reset_sum),
    .do_acc (do_acc),
    .in1 (in1[48+:16]),
    .in2 (in2),
    .out (out[48+:16])
);

endmodule

module fmadd_4p12 (
    input  wire         clk,
    input  wire         reset_sum,
    input  wire         do_acc,
    input  wire [15:0]  in1,    // Two's complement 4.12
    input  wire [15:0]  in2,    // Two's complement 4.12
    output reg  [15:0]  out     // Two's complement 4.12
);

// Two's complement 20.12
wire signed [31:0] in1_ext, in2_ext;

// Two's complement 8.24
reg  signed [31:0] sum_in, sum, acc;

assign in1_ext = {{16{in1[15]}}, in1};
assign in2_ext = {{16{in2[15]}}, in2};

always @(*) begin
    if (reset_sum) begin
        sum_in = 32'b0;
    end else begin
        sum_in = acc;
    end

    sum = sum_in + in1_ext * in2_ext;
    out = sum[27:12];
end

always @(posedge clk) begin
    if (do_acc) begin
        acc <= sum;
    end
end

endmodule

module mat_reg (
    input  wire         clk,
    input  wire         we,
    input  wire [1:0]   col_idx,
    input  wire [63:0]  col_in,
    output reg  [63:0]  col_out
);

//   bit             row   col
reg [15:0]  mat_reg [3:0] [3:0];

always @(*) begin
    col_out[ 0+:16] = mat_reg[0][col_idx];
    col_out[16+:16] = mat_reg[1][col_idx];
    col_out[32+:16] = mat_reg[2][col_idx];
    col_out[48+:16] = mat_reg[3][col_idx];

    // row_out[ 0+:16] = mat_reg[0][row_idx];
    // row_out[16+:16] = mat_reg[1][row_idx];
    // row_out[32+:16] = mat_reg[2][row_idx];
    // row_out[48+:16] = mat_reg[3][row_idx];
end

always @(posedge clk) begin
    if (we) begin
        mat_reg[0][col_idx] <= col_in[ 0+:16];
        mat_reg[1][col_idx] <= col_in[16+:16];
        mat_reg[2][col_idx] <= col_in[32+:16];
        mat_reg[3][col_idx] <= col_in[48+:16];
    end
end

endmodule
