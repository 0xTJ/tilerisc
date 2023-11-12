module gpu (
    inout vdd,		// User area 5.0V supply
    inout vss,		// User area ground

    input wire clk,
    output wire [7:0] Q
);

endmodule


module interp_tri (
    input wire [9:0] y,

    input wire [9:0] A_x,
    input wire [9:0] A_y,
    input wire [9:0] B_x,
    input wire [9:0] B_y,
    input wire [9:0] C_x,
    input wire [9:0] C_y,
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
