// Opcode bits 6:2
`define OPCODE_LOAD         5'b00000
`define OPCODE_LOAD_FP      5'b00001
`define OPCODE_CUSTOM_0     5'b00010
`define OPCODE_MISC_MEM     5'b00011
`define OPCODE_OP_IMM       5'b00100
`define OPCODE_AUIPC        5'b00101
`define OPCODE_OP_IMM_32    5'b00110
`define OPCODE_STORE        5'b01000
`define OPCODE_STORE_FP     5'b01001
`define OPCODE_CUSTOM_1     5'b01010
`define OPCODE_AMO          5'b01011
`define OPCODE_OP           5'b01100
`define OPCODE_LUI          5'b01101
`define OPCODE_OP_32        5'b01110
`define OPCODE_MADD         5'b10000
`define OPCODE_MSUB         5'b10001
`define OPCODE_NMSUB        5'b10010
`define OPCODE_NMADD        5'b10011
`define OPCODE_OP_FP        5'b10100
`define OPCODE_CUSTOM_2     5'b10110
`define OPCODE_BRANCH       5'b11000
`define OPCODE_JALR         5'b11001
`define OPCODE_JAL          5'b11011
`define OPCODE_SYSTEM       5'b11100
`define OPCODE_CUSTOM_3     5'b11110

`define INST_TYPE_R 6'b000001
`define INST_TYPE_I 6'b000010
`define INST_TYPE_S 6'b000100
`define INST_TYPE_B 6'b001000
`define INST_TYPE_U 6'b010000
`define INST_TYPE_J 6'b100000

`define ALU_FUNCT_ADD   4'b0000
`define ALU_FUNCT_SUB   4'b1000
`define ALU_FUNCT_SLL   4'b0001
`define ALU_FUNCT_EQ    4'b1010
`define ALU_FUNCT_SLT   4'b0010
`define ALU_FUNCT_SLTU  4'b0011
`define ALU_FUNCT_XOR   4'b0100
`define ALU_FUNCT_SRL   4'b0101
`define ALU_FUNCT_SRA   4'b1101
`define ALU_FUNCT_OR    4'b0110
`define ALU_FUNCT_AND   4'b0111

`define PC_MUX_PC_PLUS_4        2'b00
`define PC_MUX_PC_PLUS_IMM      2'b01
`define PC_MUX_ALU_OUT_MASKED   2'b10

`define ALU_IN1_MUX_RS1         1'b0
`define ALU_IN1_MUX_PC          1'b1

`define ALU_IN2_MUX_RS2         1'b0
`define ALU_IN2_MUX_IMM         1'b1

`define RD_MUX_ALU_OUT          2'b00
`define RD_MUX_IMM              2'b01
`define RD_MUX_PC_PLUS_4        2'b10
`define RD_MUX_MEM_LOAD_OUT         2'b11

module tinyrv (
`ifdef USE_POWER_PINS
    inout vdd,	// User area 1 5.0 V supply
    inout vss,	// User area 1 digital ground
`endif

    input clk,
    input wire [31:0] inst_in,
    input wire [31:0] mem_load_out,

    output wire [31:0] alu_out_out
);

assign alu_out_out = alu_out;
assign inst = inst_in;

reg  [31:0] pc; // TODO: Add reset
wire [31:0] inst;

wire [6:0] opcode;
wire [2:0] funct3;
wire [6:0] funct7;

wire [4:0] rd, rs1, rs2;
reg  [31:0] rd_dat;
wire [31:0] rs1_dat, rs2_dat;

wire [31:0] inst;
wire [5:0]  inst_type;
wire [31:0] imm;

wire [3:0] alu_funct;
wire alu_in1_mux, alu_in2_mux;
wire [1:0] rd_mux;
wire rd_we;
wire [1:0] pc_mux;

reg  [31:0] pc_next;
reg  [31:0] alu_in1, alu_in2;
wire [31:0] alu_out;

control control (
    .inst (inst),
    .alu_out_0 (alu_out[0]),
    .rd (rd),
    .rs1 (rs1),
    .rs2 (rs2),
    .inst_type (inst_type),
    .alu_funct (alu_funct),
    .alu_in1_mux (alu_in1_mux),
    .alu_in2_mux (alu_in2_mux),
    .rd_mux (rd_mux),
    .rd_we (rd_we),
    .pc_mux (pc_mux)
);

imm_decode imm_decode (
    .inst_type  (inst_type),
    .inst       (inst),
    .imm        (imm),
);

alu alu (
    .funct (alu_funct),

    .in1 (alu_in1),
    .in2 (alu_in2),
    .out (alu_out)
);

reg_file reg_file (
    .clk        (clk),

    .rs1        (rs1),
    .rs2        (rs2),
    .rd         (rd),

    .rd_we      (rd_we),

    .rs1_dat    (rs1_dat),
    .rs2_dat    (rs2_dat),
    .rd_dat     (rd_dat)
);

wire [31:0] pc_plus_4, pc_plus_imm, alu_out_masked;

assign pc_plus_4 = pc + 32'd4;
assign pc_plus_imm = pc + imm;
assign alu_out_masked = alu_out & ~32'b1;

always @(*) begin
    case (pc_mux)
        `PC_MUX_PC_PLUS_4:      pc_next = pc_plus_4;
        `PC_MUX_PC_PLUS_IMM:    pc_next = pc_plus_imm;
        `PC_MUX_ALU_OUT_MASKED: pc_next = alu_out_masked;
        default:                pc_next = 32'bx;
    endcase

    case (alu_in1_mux)
        `ALU_IN1_MUX_RS1:       alu_in1 = rs1_dat;
        `ALU_IN1_MUX_PC:        alu_in1 = pc;
    endcase

    case (alu_in2_mux)
        `ALU_IN2_MUX_RS2:       alu_in2 = rs2_dat;
        `ALU_IN2_MUX_IMM:       alu_in2 = imm;
    endcase

    case (rd_mux)
        `RD_MUX_ALU_OUT:        rd_dat = alu_out;
        `RD_MUX_IMM:            rd_dat = imm;
        `RD_MUX_PC_PLUS_4:      rd_dat = pc_plus_4;
        `RD_MUX_MEM_LOAD_OUT:   rd_dat = mem_load_out;
    endcase
end

always @(posedge clk) begin
    pc <= pc_next;
end

endmodule

module reg_file (
    input  wire         clk,

    input  wire [4:0]   rs1,
    input  wire [4:0]   rs2,
    input  wire [4:0]   rd,

    input  wire         rd_we,

    output reg  [31:0]  rs1_dat,   
    output reg  [31:0]  rs2_dat,   
    input  wire [31:0]  rd_dat
);

reg [31:0] reg_storage [15:1];

always @(*) begin
    if (rs1 == 0) begin
        rs1_dat = 32'b0;
    end else if (rs1 < 16) begin
        rs1_dat = reg_storage[rs1];
    end else begin
        rs1_dat = 32'hx;
    end

    if (rs2 == 0) begin
        rs2_dat = 32'b0;
    end else if (rs2 < 16) begin
        rs2_dat = reg_storage[rs2];
    end else begin
        rs2_dat = 32'hx;
    end
end

always @(posedge clk) begin
    if (rd_we && rd != 0 && rd < 16) begin
        reg_storage[rd] <= rd_dat;
    end
end

endmodule

module control (
    input  wire [31:0]  inst,
    input  wire         alu_out_0,
    output reg  [4:0]   rd,
    output reg  [4:0]   rs1,
    output reg  [4:0]   rs2,
    output reg  [5:0]   inst_type,
    output reg  [3:0]   alu_funct,
    output reg          alu_in1_mux,
    output reg          alu_in2_mux,
    output reg  [1:0]   rd_mux,
    output reg          rd_we,
    output reg  [1:0]   pc_mux
);

reg [6:0] opcode;
reg [1:0] op;
reg [2:0] funct3;
reg [6:0] funct7;

// Decode parts of the instruction
always @(*) begin
    opcode = 7'bx;
    op = 2'bx;
    rd = 5'bx;
    rs1 = 5'bx;
    rs2 = 5'bx;
    funct3 = 3'bx;
    funct7 = 7'bx;
    inst_type = 6'bx;

    if (inst[1:0] != 2'b11) begin
        // Is a 16b instruction
        op = inst[1:0];
        // TODO: Handle this
    end else begin
        opcode = inst[6:0];
        
        if (opcode[4:2] == 3'b111) begin
            // Is a >32b instruction
            // TODO: Handle this
        end else case (opcode[6:2])
            `OPCODE_OP_IMM:     inst_type = `INST_TYPE_I;
            `OPCODE_AUIPC:      inst_type = `INST_TYPE_U;
            `OPCODE_LUI:        inst_type = `INST_TYPE_U;
            `OPCODE_OP:         inst_type = `INST_TYPE_R;
            `OPCODE_JAL:        inst_type = `INST_TYPE_J;
            `OPCODE_JALR:       inst_type = `INST_TYPE_I;
            `OPCODE_BRANCH:     inst_type = `INST_TYPE_B;
            `OPCODE_LOAD:       inst_type = `INST_TYPE_I;
            `OPCODE_STORE:      inst_type = `INST_TYPE_R;
            `OPCODE_MISC_MEM:   inst_type = `INST_TYPE_I;
            `OPCODE_SYSTEM:     inst_type = `INST_TYPE_I;
            // TODO: Handle default
        endcase

        if (inst_type & (`INST_TYPE_R | `INST_TYPE_I | `INST_TYPE_U | `INST_TYPE_J)) begin
            rd = inst[11:7];
        end else begin
            rd = 5'bx;
        end

        if (inst_type & (`INST_TYPE_R | `INST_TYPE_I | `INST_TYPE_S | `INST_TYPE_B)) begin
            rs1 = inst[19:15];
        end else begin
            rs1 = 5'bx;
        end

        if (inst_type & (`INST_TYPE_R | `INST_TYPE_S | `INST_TYPE_B)) begin
            rs2 = inst[24:20];
        end else begin
            rs2 = 5'bx;
        end

        if (inst_type & (`INST_TYPE_R | `INST_TYPE_I | `INST_TYPE_S | `INST_TYPE_B)) begin
            funct3 = inst[14:12];
        end else begin
            funct3 = 3'bx;
        end

        if (inst_type & (`INST_TYPE_R)) begin
            funct7 = inst[31:25];
        end else begin
            funct7 = 7'bx;
        end
    end
end

// Take actions accoring to decoded instruction
always @(*) begin
    alu_funct = 4'bx;
    alu_in1_mux = 1'bx;
    alu_in2_mux = 1'bx;
    rd_mux = 2'bx;
    rd_we = 1'b0;
    pc_mux = `PC_MUX_PC_PLUS_4;

    if (inst[1:0] != 2'b11) begin
        // Is a 16b instruction
        // TODO: Handle this
    end else begin
        if (opcode[4:2] == 3'b111) begin
            // Is a >32b instruction
            // TODO: Handle this
        end else case (opcode[6:2])
            `OPCODE_OP_IMM: begin
                alu_funct = {inst[30], funct3};
                alu_in1_mux = `ALU_IN1_MUX_RS1;
                alu_in2_mux = `ALU_IN2_MUX_IMM;
                rd_mux = `RD_MUX_ALU_OUT;
                rd_we = 1'b1;
            end

            `OPCODE_AUIPC: begin
                alu_funct = `ALU_FUNCT_ADD;
                alu_in1_mux = `ALU_IN1_MUX_PC;
                alu_in2_mux = `ALU_IN2_MUX_IMM;
                rd_mux = `RD_MUX_ALU_OUT;
                rd_we = 1'b1;
            end

            `OPCODE_LUI: begin
                rd_mux = `RD_MUX_IMM;
                rd_we = 1'b1;
            end

            `OPCODE_OP: begin
                alu_funct = {inst[30], funct3};
                alu_in1_mux = `ALU_IN1_MUX_RS1;
                alu_in2_mux = `ALU_IN2_MUX_RS2;
                rd_mux = `RD_MUX_ALU_OUT;
                rd_we = 1'b1;
            end

            `OPCODE_JAL: begin
                rd_mux = `RD_MUX_PC_PLUS_4;
                rd_we = 1'b1;
                pc_mux = `PC_MUX_PC_PLUS_IMM;
            end

            `OPCODE_JALR: begin
                alu_funct = `ALU_FUNCT_ADD;
                alu_in1_mux = `ALU_IN1_MUX_RS1;
                alu_in2_mux = `ALU_IN2_MUX_IMM;
                rd_mux = `RD_MUX_PC_PLUS_4;
                rd_we = 1'b1;
                pc_mux = `PC_MUX_ALU_OUT_MASKED;
            end

            `OPCODE_BRANCH: begin
                case (funct3[2:1])
                    2'b00:
                        // BEQ/BNE
                        alu_funct = `ALU_FUNCT_EQ;
                    2'b10:
                        // BLT/BGE
                        alu_funct = `ALU_FUNCT_SLT;
                    2'b11:
                        // BLTU/BGEU
                        alu_funct = `ALU_FUNCT_SLTU;
                    // TODO: Handle default
                endcase
                alu_in1_mux = `ALU_IN1_MUX_RS1;
                alu_in2_mux = `ALU_IN2_MUX_RS2;
                // funct3[0] is 0 for true condition, 1 for false condition
                if (alu_out_0 != funct3[0]) begin
                    pc_mux = `PC_MUX_PC_PLUS_IMM;
                end
            end

            `OPCODE_LOAD: begin
                alu_funct = `ALU_FUNCT_ADD;
                alu_in1_mux = `ALU_IN1_MUX_RS1;
                alu_in2_mux = `ALU_IN2_MUX_IMM;
                rd_mux = `RD_MUX_MEM_LOAD_OUT;
                rd_we = 1'b1;
            end

            `OPCODE_STORE: begin
                alu_funct = `ALU_FUNCT_ADD;
                alu_in1_mux = `ALU_IN1_MUX_RS1;
                alu_in2_mux = `ALU_IN2_MUX_IMM;
            end

            `OPCODE_MISC_MEM: begin
                // TODO
            end

            `OPCODE_SYSTEM: begin
                // TODO
            end

            default: begin
                // TODO
            end
        endcase
    end
end

endmodule

module alu (
    input  wire [3:0] funct,

    input  wire [31:0] in1,
    input  wire [31:0] in2,
    output reg  [31:0] out
);

wire signed [31:0] in1_s, in2_s;
assign in1_s = in1;
assign in2_s = in2;

always @(*) begin
    unique case (funct)
        `ALU_FUNCT_ADD:     out = in1 + in2;
        `ALU_FUNCT_SUB:     out = in1 - in2;
        `ALU_FUNCT_EQ:      out = (in1   == in2  ) ? 32'b1 : 32'b0;
        `ALU_FUNCT_SLT:     out = (in1_s <  in2_s) ? 32'b1 : 32'b0;
        `ALU_FUNCT_SLTU:    out = (in1   <  in2  ) ? 32'b1 : 32'b0;
        `ALU_FUNCT_XOR:     out = in1 ^ in2;
        `ALU_FUNCT_OR:      out = in1 | in2;
        `ALU_FUNCT_AND:     out = in1 & in2;
        `ALU_FUNCT_SLL:     out = in1 <<  in2[4:0];
        `ALU_FUNCT_SRL:     out = in1 >>  in2[4:0];
        `ALU_FUNCT_SRA:     out = in1 >>> in2[4:0];
        default:            out = 32'bx;
    endcase
end

endmodule

module imm_decode (
    input  wire [5:0]  inst_type,
    input  wire [31:0] inst,
    output reg  [31:0] imm
);

always @(*) begin
    unique case (1'b1)
        |(inst_type & (`INST_TYPE_I)):
            imm[0] = inst[20];
        |(inst_type & (`INST_TYPE_S)):
            imm[0] = inst[7];
        |(inst_type & (`INST_TYPE_B | `INST_TYPE_U | `INST_TYPE_J)):
            imm[0] = 1'b0;
        default:
            imm[0] = 1'bx;
    endcase

    unique case (1'b1)
        |(inst_type & (`INST_TYPE_I | `INST_TYPE_J)):
            imm[4:1] = inst[24:21];
        |(inst_type & (`INST_TYPE_S | `INST_TYPE_B)):
            imm[4:1] = inst[11:8];
        |(inst_type & (`INST_TYPE_U)):
            imm[4:1] = 4'b0;
        default:
            imm[4:1] = 4'bx;
    endcase

    unique case (1'b1)
        |(inst_type & (`INST_TYPE_I | `INST_TYPE_S | `INST_TYPE_B | `INST_TYPE_J)):
            imm[10:5] = inst[30:25];
        |(inst_type & (`INST_TYPE_U)):
            imm[10:5] = 6'b0;
        default:
            imm[10:5] = 6'bx;
    endcase

    unique case (1'b1)
        |(inst_type & (`INST_TYPE_I | `INST_TYPE_S)):
            imm[11] = inst[31];
        |(inst_type & (`INST_TYPE_B)):
            imm[11] = inst[7];
        |(inst_type & (`INST_TYPE_U)):
            imm[11] = 1'b0;
        |(inst_type & (`INST_TYPE_J)):
            imm[11] = inst[20];
        default:
            imm[11] = 1'bx;
    endcase

    unique case (1'b1)
        |(inst_type & (`INST_TYPE_I | `INST_TYPE_S | `INST_TYPE_B)):
            imm[19:12] = {8{inst[31]}};
        |(inst_type & (`INST_TYPE_U | `INST_TYPE_J)):
            imm[19:12] = inst[19:12];
        default:
            imm[19:12] = 8'bx;
    endcase

    unique case (1'b1)
        |(inst_type & (`INST_TYPE_I | `INST_TYPE_S | `INST_TYPE_B | `INST_TYPE_J)):
            imm[30:20] = {11{inst[31]}};
        |(inst_type & (`INST_TYPE_U)):
            imm[30:20] = inst[30:20];
        default:
            imm[30:20] = 11'bx;
    endcase

    unique case (1'b1)
        |(inst_type & (`INST_TYPE_I | `INST_TYPE_S | `INST_TYPE_B | `INST_TYPE_U | `INST_TYPE_J)):
            imm[31] = {1{inst[31]}};
        default:
            imm[31] = 1'bx;
    endcase
end

endmodule
