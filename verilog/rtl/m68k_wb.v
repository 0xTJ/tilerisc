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
 * m68k_wb
 *
 *-------------------------------------------------------------
 */

`define STATE_IDLE 4'b0001;
`define STATE_DATA 4'b0010;

module m68k_wb (
    input wire clk,
    input wire en_b,
    input wire r_nw,
    output reg ack_b,
    input wire [31:0] dat_i,
    output wire [31:0] dat_o,
    output wire [31:0] dat_oe,

    output wbs_stb_i,
    output wbs_cyc_i,
    output wbs_we_i,
    output wire [3:0]   wbs_sel_i,
    output reg  [31:0]  wbs_dat_i,
    output reg  [31:0]  wbs_adr_i,
    input  wire         wbs_ack_o,
    input  wire [31:0]  wbs_dat_o
);

assign wbs_sel_i = 4'hF;
assign wbs_we_i = r_nw;

reg [3:0] state;
reg [3:0] next_state;
reg get_addr;

always @(*) begin
    get_addr = 1'b0;

    case (state)
        `STATE_IDLE: begin
            if (en_b == 1'b0) begin
                get_addr = 1'b1;
                next_state = `STATE_DATA;
            end else begin
                next_state = `STATE_IDLE
            end
        end

        `STATE_DATA: begin
        end
    endcase
end

always @(posedge clk) begin
    if (get_addr)
        wbs_adr_i <= dat_i;
end

endmodule
