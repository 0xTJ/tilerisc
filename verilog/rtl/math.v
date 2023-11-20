
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

module sub (
    input  wire signed [`FIXED_BITS_RANGE] a,
    input  wire signed [`FIXED_BITS_RANGE] b,
    output reg  signed [`FIXED_BITS_RANGE] y
);

wire signed [16:0] a_ext, b_ext;
reg  signed [16:0] y_ext;

assign a_ext = {1'b0, a};
assign b_ext = {1'b0, b};

always @(a_ext or b_ext) begin
    y_ext = a_ext - b_ext;
    // TODO: This assumes no overflow/underflow
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
    input  wire clk,
    input  wire signed [`V3_BITS_RANGE] a,
    input  wire signed [`V3_BITS_RANGE] b,
    output wire signed [`FIXED_BITS_RANGE] y
);

reg  signed [`FIXED_BITS_RANGE] a_x, a_y, a_z;
reg  signed [`FIXED_BITS_RANGE] b_x, b_y, b_z;
wire signed [`FIXED_BITS_RANGE] tmp_x, tmp_y, tmp_z, tmp_xy;
reg  signed [`FIXED_BITS_RANGE] tmpr_x, tmpr_y, tmpr_z;

always @(posedge clk) begin
    tmpr_x = tmp_x;
    tmpr_y = tmp_y;
    tmpr_z = tmp_z;

    a_x = a[`V3_BITS_X_RANGE];
    a_y = a[`V3_BITS_Y_RANGE];
    a_z = a[`V3_BITS_Z_RANGE];
    b_x = b[`V3_BITS_X_RANGE];
    b_y = b[`V3_BITS_Y_RANGE];
    b_z = b[`V3_BITS_Z_RANGE];
end

mul mul_x (.a (a_x), .b (b_x), .y (tmp_x));
mul mul_y (.a (a_y), .b (b_y), .y (tmp_y));
mul mul_z (.a (a_z), .b (b_z), .y (tmp_z));

add add_xy (.a (tmpr_x), .b (tmpr_y), .y (tmp_xy));
add add_xyz (.a (tmp_xy), .b (tmpr_z), .y (y));

endmodule

module cross (
    input  wire clk,
    input  wire signed [`V3_BITS_RANGE] a,
    input  wire signed [`V3_BITS_RANGE] b,
    output wire signed [`V3_BITS_RANGE] y
);

reg  signed [`FIXED_BITS_RANGE] a_x, a_y, a_z;
reg  signed [`FIXED_BITS_RANGE] b_x, b_y, b_z;
wire signed [`FIXED_BITS_RANGE] y_x, y_y, y_z;
wire signed [`FIXED_BITS_RANGE] tmp_yz, tmp_zy, tmp_zx, tmp_xz, tmp_xy, tmp_yx;
reg  signed [`FIXED_BITS_RANGE] tmpr_yz, tmpr_zy, tmpr_zx, tmpr_xz, tmpr_xy, tmpr_yx;

always @(posedge clk) begin
    tmpr_yz = tmp_yz;
    tmpr_zy = tmp_zy;
    tmpr_zx = tmp_zx;
    tmpr_xz = tmp_xz;
    tmpr_xy = tmp_xy;
    tmpr_yx = tmp_yx;

    a_x = a[`V3_BITS_X_RANGE];
    a_y = a[`V3_BITS_Y_RANGE];
    a_z = a[`V3_BITS_Z_RANGE];
    b_x = b[`V3_BITS_X_RANGE];
    b_y = b[`V3_BITS_Y_RANGE];
    b_z = b[`V3_BITS_Z_RANGE];
end

mul mul_yz (.a (a_y), .b (b_z), .y (tmp_yz));
mul mul_zy (.a (a_z), .b (b_y), .y (tmp_zy));
mul mul_zx (.a (a_z), .b (b_x), .y (tmp_zx));
mul mul_xz (.a (a_x), .b (b_z), .y (tmp_xz));
mul mul_xy (.a (a_x), .b (b_y), .y (tmp_xy));
mul mul_yx (.a (a_y), .b (b_x), .y (tmp_yx));

sub sub_yz (.a (tmpr_yz), .b (tmpr_zy), .y (y_x));
sub sub_zx (.a (tmpr_zx), .b (tmpr_xz), .y (y_y));
sub sub_xy (.a (tmpr_xy), .b (tmpr_yx), .y (y_z));

assign y[`V3_BITS_X_RANGE] = y_x;
assign y[`V3_BITS_Y_RANGE] = y_y;
assign y[`V3_BITS_Z_RANGE] = y_z;

endmodule
