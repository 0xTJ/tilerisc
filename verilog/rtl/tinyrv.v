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

module tinyrv (

);



endmodule

module inst_decode (
    input  wire [31:0] inst,
    output wire [6:0]  opcode,
    output reg  [4:0]  rd,
    output reg  [4:0]  rs1,
    output reg  [4:0]  rs2,
    output reg  [2:0]  funct3,
    output reg  [6:0]  funct7,
    output wire [31:0] imm
);

reg is_compressed;
reg is_long;
reg is_illegal;
reg [5:0] inst_type;

always @(*) begin
    if (opcode[1:0] != 2'b11) begin
        is_compressed = 1'b1;
    end else begin
        is_compressed = 1'b0;
    end

    if (!is_compressed && opcode[4:2] == 3'b111) begin
        is_long = 1'b1;
    end else begin
        is_long = 1'b0;
    end

    is_illegal = is_compressed || is_long;

    case (opcode[6:2])
        `OPCODE_LOAD: inst_type = INST_TYPE_I;
        `OPCODE_LOAD_FP: inst_type = INST_TYPE_I;
        default: begin
            inst_type = 6'bxxxxxx;
            is_illegal = 1'b1;
        end
    endcase
end

assign opcode = inst[6:0];

always @(*) begin
    unique case (1'b1)
        |(inst_type & (`INST_TYPE_R | `INST_TYPE_I | `INST_TYPE_U | `INST_TYPE_J)):
            rd = inst[11:7];
        default:
            rd = 5'bxxxxx;
    endcase

    unique case (1'b1)
        |(inst_type & (`INST_TYPE_R | `INST_TYPE_I | `INST_TYPE_S | `INST_TYPE_B)):
            rs1 = inst[19:15];
        default:
            rs1 = 5'bxxxxx;
    endcase

    unique case (1'b1)
        |(inst_type & (`INST_TYPE_R | `INST_TYPE_S | `INST_TYPE_B)):
            rs2 = inst[24:20];
        default:
            rs2 = 5'bxxxxx;
    endcase

    unique case (1'b1)
        |(inst_type & (`INST_TYPE_R | `INST_TYPE_I | `INST_TYPE_S | `INST_TYPE_B)):
            funct3 = inst[14:12];
        default:
            funct3 = 3'bxxx;
    endcase

    unique case (1'b1)
        |(inst_type & (`INST_TYPE_R)):
            funct7 = inst[31:25];
        default:
            funct7 = 7'bxxxxxxx;
    endcase
end

imm_decode imm_decode (
    .inst_type  (inst_type),
    .inst       (inst),
    .imm        (imm),
);

endmodule

// TODO: Do 2 stages, first RISU, then BJ
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
            imm[4:1] = 4'b0000;
        default:
            imm[4:1] = 4'bxxxx;
    endcase

    unique case (1'b1)
        |(inst_type & (`INST_TYPE_I | `INST_TYPE_S | `INST_TYPE_B | `INST_TYPE_J)):
            imm[10:5] = inst[30:25];
        |(inst_type & (`INST_TYPE_U)):
            imm[10:5] = 6'b000000;
        default:
            imm[10:5] = 6'bxxxxxx;
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
            imm[19:12] = 8'bxxxxxxxx;
    endcase

    unique case (1'b1)
        |(inst_type & (`INST_TYPE_I | `INST_TYPE_S | `INST_TYPE_B | `INST_TYPE_J)):
            imm[30:20] = {11{inst[31]}};
        |(inst_type & (`INST_TYPE_U)):
            imm[30:20] = inst[30:20];
        default:
            imm[30:20] = 11'bxxxxxxxxxxx;
    endcase

    unique case (1'b1)
        |(inst_type & (`INST_TYPE_I | `INST_TYPE_S | `INST_TYPE_B | `INST_TYPE_U | `INST_TYPE_J)):
            imm[31] = {1{inst[31]}};
        default:
            imm[31] = 1'bx;
    endcase
end

endmodule
