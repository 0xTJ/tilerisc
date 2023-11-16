// This is the unpowered netlist.
module user_project_wrapper (user_clock2,
    wb_clk_i,
    wb_rst_i,
    wbs_ack_o,
    wbs_cyc_i,
    wbs_stb_i,
    wbs_we_i,
    io_in,
    io_oeb,
    io_out,
    la_data_in,
    la_data_out,
    la_oenb,
    user_irq,
    wbs_adr_i,
    wbs_dat_i,
    wbs_dat_o,
    wbs_sel_i);
 input user_clock2;
 input wb_clk_i;
 input wb_rst_i;
 output wbs_ack_o;
 input wbs_cyc_i;
 input wbs_stb_i;
 input wbs_we_i;
 input [37:0] io_in;
 output [37:0] io_oeb;
 output [37:0] io_out;
 input [63:0] la_data_in;
 output [63:0] la_data_out;
 input [63:0] la_oenb;
 output [2:0] user_irq;
 input [31:0] wbs_adr_i;
 input [31:0] wbs_dat_i;
 output [31:0] wbs_dat_o;
 input [3:0] wbs_sel_i;

 wire \line_a_buf_b_a[0] ;
 wire \line_a_buf_b_a[1] ;
 wire \line_a_buf_b_a[2] ;
 wire \line_a_buf_b_a[3] ;
 wire \line_a_buf_b_a[4] ;
 wire \line_a_buf_b_a[5] ;
 wire \line_a_buf_b_a[6] ;
 wire \line_a_buf_b_a[7] ;
 wire line_a_buf_b_cen;
 wire line_a_buf_b_clk;
 wire \line_a_buf_b_d[0] ;
 wire \line_a_buf_b_d[1] ;
 wire \line_a_buf_b_d[2] ;
 wire \line_a_buf_b_d[3] ;
 wire \line_a_buf_b_d[4] ;
 wire \line_a_buf_b_d[5] ;
 wire \line_a_buf_b_d[6] ;
 wire \line_a_buf_b_d[7] ;
 wire line_a_buf_b_gwen;
 wire \line_a_buf_b_q[0] ;
 wire \line_a_buf_b_q[1] ;
 wire \line_a_buf_b_q[2] ;
 wire \line_a_buf_b_q[3] ;
 wire \line_a_buf_b_q[4] ;
 wire \line_a_buf_b_q[5] ;
 wire \line_a_buf_b_q[6] ;
 wire \line_a_buf_b_q[7] ;
 wire \line_a_buf_b_wen[0] ;
 wire \line_a_buf_b_wen[1] ;
 wire \line_a_buf_b_wen[2] ;
 wire \line_a_buf_b_wen[3] ;
 wire \line_a_buf_b_wen[4] ;
 wire \line_a_buf_b_wen[5] ;
 wire \line_a_buf_b_wen[6] ;
 wire \line_a_buf_b_wen[7] ;
 wire \line_a_buf_d_a[0] ;
 wire \line_a_buf_d_a[1] ;
 wire \line_a_buf_d_a[2] ;
 wire \line_a_buf_d_a[3] ;
 wire \line_a_buf_d_a[4] ;
 wire \line_a_buf_d_a[5] ;
 wire \line_a_buf_d_a[6] ;
 wire \line_a_buf_d_a[7] ;
 wire line_a_buf_d_cen;
 wire line_a_buf_d_clk;
 wire \line_a_buf_d_d[0] ;
 wire \line_a_buf_d_d[1] ;
 wire \line_a_buf_d_d[2] ;
 wire \line_a_buf_d_d[3] ;
 wire \line_a_buf_d_d[4] ;
 wire \line_a_buf_d_d[5] ;
 wire \line_a_buf_d_d[6] ;
 wire \line_a_buf_d_d[7] ;
 wire line_a_buf_d_gwen;
 wire \line_a_buf_d_q[0] ;
 wire \line_a_buf_d_q[1] ;
 wire \line_a_buf_d_q[2] ;
 wire \line_a_buf_d_q[3] ;
 wire \line_a_buf_d_q[4] ;
 wire \line_a_buf_d_q[5] ;
 wire \line_a_buf_d_q[6] ;
 wire \line_a_buf_d_q[7] ;
 wire \line_a_buf_d_wen[0] ;
 wire \line_a_buf_d_wen[1] ;
 wire \line_a_buf_d_wen[2] ;
 wire \line_a_buf_d_wen[3] ;
 wire \line_a_buf_d_wen[4] ;
 wire \line_a_buf_d_wen[5] ;
 wire \line_a_buf_d_wen[6] ;
 wire \line_a_buf_d_wen[7] ;
 wire \line_a_buf_g_a[0] ;
 wire \line_a_buf_g_a[1] ;
 wire \line_a_buf_g_a[2] ;
 wire \line_a_buf_g_a[3] ;
 wire \line_a_buf_g_a[4] ;
 wire \line_a_buf_g_a[5] ;
 wire \line_a_buf_g_a[6] ;
 wire \line_a_buf_g_a[7] ;
 wire line_a_buf_g_cen;
 wire line_a_buf_g_clk;
 wire \line_a_buf_g_d[0] ;
 wire \line_a_buf_g_d[1] ;
 wire \line_a_buf_g_d[2] ;
 wire \line_a_buf_g_d[3] ;
 wire \line_a_buf_g_d[4] ;
 wire \line_a_buf_g_d[5] ;
 wire \line_a_buf_g_d[6] ;
 wire \line_a_buf_g_d[7] ;
 wire line_a_buf_g_gwen;
 wire \line_a_buf_g_q[0] ;
 wire \line_a_buf_g_q[1] ;
 wire \line_a_buf_g_q[2] ;
 wire \line_a_buf_g_q[3] ;
 wire \line_a_buf_g_q[4] ;
 wire \line_a_buf_g_q[5] ;
 wire \line_a_buf_g_q[6] ;
 wire \line_a_buf_g_q[7] ;
 wire \line_a_buf_g_wen[0] ;
 wire \line_a_buf_g_wen[1] ;
 wire \line_a_buf_g_wen[2] ;
 wire \line_a_buf_g_wen[3] ;
 wire \line_a_buf_g_wen[4] ;
 wire \line_a_buf_g_wen[5] ;
 wire \line_a_buf_g_wen[6] ;
 wire \line_a_buf_g_wen[7] ;
 wire \line_a_buf_r_a[0] ;
 wire \line_a_buf_r_a[1] ;
 wire \line_a_buf_r_a[2] ;
 wire \line_a_buf_r_a[3] ;
 wire \line_a_buf_r_a[4] ;
 wire \line_a_buf_r_a[5] ;
 wire \line_a_buf_r_a[6] ;
 wire \line_a_buf_r_a[7] ;
 wire line_a_buf_r_cen;
 wire line_a_buf_r_clk;
 wire \line_a_buf_r_d[0] ;
 wire \line_a_buf_r_d[1] ;
 wire \line_a_buf_r_d[2] ;
 wire \line_a_buf_r_d[3] ;
 wire \line_a_buf_r_d[4] ;
 wire \line_a_buf_r_d[5] ;
 wire \line_a_buf_r_d[6] ;
 wire \line_a_buf_r_d[7] ;
 wire line_a_buf_r_gwen;
 wire \line_a_buf_r_q[0] ;
 wire \line_a_buf_r_q[1] ;
 wire \line_a_buf_r_q[2] ;
 wire \line_a_buf_r_q[3] ;
 wire \line_a_buf_r_q[4] ;
 wire \line_a_buf_r_q[5] ;
 wire \line_a_buf_r_q[6] ;
 wire \line_a_buf_r_q[7] ;
 wire \line_a_buf_r_wen[0] ;
 wire \line_a_buf_r_wen[1] ;
 wire \line_a_buf_r_wen[2] ;
 wire \line_a_buf_r_wen[3] ;
 wire \line_a_buf_r_wen[4] ;
 wire \line_a_buf_r_wen[5] ;
 wire \line_a_buf_r_wen[6] ;
 wire \line_a_buf_r_wen[7] ;
 wire \line_b_buf_b_a[0] ;
 wire \line_b_buf_b_a[1] ;
 wire \line_b_buf_b_a[2] ;
 wire \line_b_buf_b_a[3] ;
 wire \line_b_buf_b_a[4] ;
 wire \line_b_buf_b_a[5] ;
 wire \line_b_buf_b_a[6] ;
 wire \line_b_buf_b_a[7] ;
 wire line_b_buf_b_cen;
 wire line_b_buf_b_clk;
 wire \line_b_buf_b_d[0] ;
 wire \line_b_buf_b_d[1] ;
 wire \line_b_buf_b_d[2] ;
 wire \line_b_buf_b_d[3] ;
 wire \line_b_buf_b_d[4] ;
 wire \line_b_buf_b_d[5] ;
 wire \line_b_buf_b_d[6] ;
 wire \line_b_buf_b_d[7] ;
 wire line_b_buf_b_gwen;
 wire \line_b_buf_b_q[0] ;
 wire \line_b_buf_b_q[1] ;
 wire \line_b_buf_b_q[2] ;
 wire \line_b_buf_b_q[3] ;
 wire \line_b_buf_b_q[4] ;
 wire \line_b_buf_b_q[5] ;
 wire \line_b_buf_b_q[6] ;
 wire \line_b_buf_b_q[7] ;
 wire \line_b_buf_b_wen[0] ;
 wire \line_b_buf_b_wen[1] ;
 wire \line_b_buf_b_wen[2] ;
 wire \line_b_buf_b_wen[3] ;
 wire \line_b_buf_b_wen[4] ;
 wire \line_b_buf_b_wen[5] ;
 wire \line_b_buf_b_wen[6] ;
 wire \line_b_buf_b_wen[7] ;
 wire \line_b_buf_d_a[0] ;
 wire \line_b_buf_d_a[1] ;
 wire \line_b_buf_d_a[2] ;
 wire \line_b_buf_d_a[3] ;
 wire \line_b_buf_d_a[4] ;
 wire \line_b_buf_d_a[5] ;
 wire \line_b_buf_d_a[6] ;
 wire \line_b_buf_d_a[7] ;
 wire line_b_buf_d_cen;
 wire line_b_buf_d_clk;
 wire \line_b_buf_d_d[0] ;
 wire \line_b_buf_d_d[1] ;
 wire \line_b_buf_d_d[2] ;
 wire \line_b_buf_d_d[3] ;
 wire \line_b_buf_d_d[4] ;
 wire \line_b_buf_d_d[5] ;
 wire \line_b_buf_d_d[6] ;
 wire \line_b_buf_d_d[7] ;
 wire line_b_buf_d_gwen;
 wire \line_b_buf_d_q[0] ;
 wire \line_b_buf_d_q[1] ;
 wire \line_b_buf_d_q[2] ;
 wire \line_b_buf_d_q[3] ;
 wire \line_b_buf_d_q[4] ;
 wire \line_b_buf_d_q[5] ;
 wire \line_b_buf_d_q[6] ;
 wire \line_b_buf_d_q[7] ;
 wire \line_b_buf_d_wen[0] ;
 wire \line_b_buf_d_wen[1] ;
 wire \line_b_buf_d_wen[2] ;
 wire \line_b_buf_d_wen[3] ;
 wire \line_b_buf_d_wen[4] ;
 wire \line_b_buf_d_wen[5] ;
 wire \line_b_buf_d_wen[6] ;
 wire \line_b_buf_d_wen[7] ;
 wire \line_b_buf_g_a[0] ;
 wire \line_b_buf_g_a[1] ;
 wire \line_b_buf_g_a[2] ;
 wire \line_b_buf_g_a[3] ;
 wire \line_b_buf_g_a[4] ;
 wire \line_b_buf_g_a[5] ;
 wire \line_b_buf_g_a[6] ;
 wire \line_b_buf_g_a[7] ;
 wire line_b_buf_g_cen;
 wire line_b_buf_g_clk;
 wire \line_b_buf_g_d[0] ;
 wire \line_b_buf_g_d[1] ;
 wire \line_b_buf_g_d[2] ;
 wire \line_b_buf_g_d[3] ;
 wire \line_b_buf_g_d[4] ;
 wire \line_b_buf_g_d[5] ;
 wire \line_b_buf_g_d[6] ;
 wire \line_b_buf_g_d[7] ;
 wire line_b_buf_g_gwen;
 wire \line_b_buf_g_q[0] ;
 wire \line_b_buf_g_q[1] ;
 wire \line_b_buf_g_q[2] ;
 wire \line_b_buf_g_q[3] ;
 wire \line_b_buf_g_q[4] ;
 wire \line_b_buf_g_q[5] ;
 wire \line_b_buf_g_q[6] ;
 wire \line_b_buf_g_q[7] ;
 wire \line_b_buf_g_wen[0] ;
 wire \line_b_buf_g_wen[1] ;
 wire \line_b_buf_g_wen[2] ;
 wire \line_b_buf_g_wen[3] ;
 wire \line_b_buf_g_wen[4] ;
 wire \line_b_buf_g_wen[5] ;
 wire \line_b_buf_g_wen[6] ;
 wire \line_b_buf_g_wen[7] ;
 wire \line_b_buf_r_a[0] ;
 wire \line_b_buf_r_a[1] ;
 wire \line_b_buf_r_a[2] ;
 wire \line_b_buf_r_a[3] ;
 wire \line_b_buf_r_a[4] ;
 wire \line_b_buf_r_a[5] ;
 wire \line_b_buf_r_a[6] ;
 wire \line_b_buf_r_a[7] ;
 wire line_b_buf_r_cen;
 wire line_b_buf_r_clk;
 wire \line_b_buf_r_d[0] ;
 wire \line_b_buf_r_d[1] ;
 wire \line_b_buf_r_d[2] ;
 wire \line_b_buf_r_d[3] ;
 wire \line_b_buf_r_d[4] ;
 wire \line_b_buf_r_d[5] ;
 wire \line_b_buf_r_d[6] ;
 wire \line_b_buf_r_d[7] ;
 wire line_b_buf_r_gwen;
 wire \line_b_buf_r_q[0] ;
 wire \line_b_buf_r_q[1] ;
 wire \line_b_buf_r_q[2] ;
 wire \line_b_buf_r_q[3] ;
 wire \line_b_buf_r_q[4] ;
 wire \line_b_buf_r_q[5] ;
 wire \line_b_buf_r_q[6] ;
 wire \line_b_buf_r_q[7] ;
 wire \line_b_buf_r_wen[0] ;
 wire \line_b_buf_r_wen[1] ;
 wire \line_b_buf_r_wen[2] ;
 wire \line_b_buf_r_wen[3] ;
 wire \line_b_buf_r_wen[4] ;
 wire \line_b_buf_r_wen[5] ;
 wire \line_b_buf_r_wen[6] ;
 wire \line_b_buf_r_wen[7] ;

 gf180_ram_256x8_wrapper line_a_buf_b (.CEN(line_a_buf_b_cen),
    .CLK(line_a_buf_b_clk),
    .GWEN(line_a_buf_b_gwen),
    .A({\line_a_buf_b_a[7] ,
    \line_a_buf_b_a[6] ,
    \line_a_buf_b_a[5] ,
    \line_a_buf_b_a[4] ,
    \line_a_buf_b_a[3] ,
    \line_a_buf_b_a[2] ,
    \line_a_buf_b_a[1] ,
    \line_a_buf_b_a[0] }),
    .D({\line_a_buf_b_d[7] ,
    \line_a_buf_b_d[6] ,
    \line_a_buf_b_d[5] ,
    \line_a_buf_b_d[4] ,
    \line_a_buf_b_d[3] ,
    \line_a_buf_b_d[2] ,
    \line_a_buf_b_d[1] ,
    \line_a_buf_b_d[0] }),
    .Q({\line_a_buf_b_q[7] ,
    \line_a_buf_b_q[6] ,
    \line_a_buf_b_q[5] ,
    \line_a_buf_b_q[4] ,
    \line_a_buf_b_q[3] ,
    \line_a_buf_b_q[2] ,
    \line_a_buf_b_q[1] ,
    \line_a_buf_b_q[0] }),
    .WEN({\line_a_buf_b_wen[7] ,
    \line_a_buf_b_wen[6] ,
    \line_a_buf_b_wen[5] ,
    \line_a_buf_b_wen[4] ,
    \line_a_buf_b_wen[3] ,
    \line_a_buf_b_wen[2] ,
    \line_a_buf_b_wen[1] ,
    \line_a_buf_b_wen[0] }));
 gf180_ram_256x8_wrapper line_a_buf_d (.CEN(line_a_buf_d_cen),
    .CLK(line_a_buf_d_clk),
    .GWEN(line_a_buf_d_gwen),
    .A({\line_a_buf_d_a[7] ,
    \line_a_buf_d_a[6] ,
    \line_a_buf_d_a[5] ,
    \line_a_buf_d_a[4] ,
    \line_a_buf_d_a[3] ,
    \line_a_buf_d_a[2] ,
    \line_a_buf_d_a[1] ,
    \line_a_buf_d_a[0] }),
    .D({\line_a_buf_d_d[7] ,
    \line_a_buf_d_d[6] ,
    \line_a_buf_d_d[5] ,
    \line_a_buf_d_d[4] ,
    \line_a_buf_d_d[3] ,
    \line_a_buf_d_d[2] ,
    \line_a_buf_d_d[1] ,
    \line_a_buf_d_d[0] }),
    .Q({\line_a_buf_d_q[7] ,
    \line_a_buf_d_q[6] ,
    \line_a_buf_d_q[5] ,
    \line_a_buf_d_q[4] ,
    \line_a_buf_d_q[3] ,
    \line_a_buf_d_q[2] ,
    \line_a_buf_d_q[1] ,
    \line_a_buf_d_q[0] }),
    .WEN({\line_a_buf_d_wen[7] ,
    \line_a_buf_d_wen[6] ,
    \line_a_buf_d_wen[5] ,
    \line_a_buf_d_wen[4] ,
    \line_a_buf_d_wen[3] ,
    \line_a_buf_d_wen[2] ,
    \line_a_buf_d_wen[1] ,
    \line_a_buf_d_wen[0] }));
 gf180_ram_256x8_wrapper line_a_buf_g (.CEN(line_a_buf_g_cen),
    .CLK(line_a_buf_g_clk),
    .GWEN(line_a_buf_g_gwen),
    .A({\line_a_buf_g_a[7] ,
    \line_a_buf_g_a[6] ,
    \line_a_buf_g_a[5] ,
    \line_a_buf_g_a[4] ,
    \line_a_buf_g_a[3] ,
    \line_a_buf_g_a[2] ,
    \line_a_buf_g_a[1] ,
    \line_a_buf_g_a[0] }),
    .D({\line_a_buf_g_d[7] ,
    \line_a_buf_g_d[6] ,
    \line_a_buf_g_d[5] ,
    \line_a_buf_g_d[4] ,
    \line_a_buf_g_d[3] ,
    \line_a_buf_g_d[2] ,
    \line_a_buf_g_d[1] ,
    \line_a_buf_g_d[0] }),
    .Q({\line_a_buf_g_q[7] ,
    \line_a_buf_g_q[6] ,
    \line_a_buf_g_q[5] ,
    \line_a_buf_g_q[4] ,
    \line_a_buf_g_q[3] ,
    \line_a_buf_g_q[2] ,
    \line_a_buf_g_q[1] ,
    \line_a_buf_g_q[0] }),
    .WEN({\line_a_buf_g_wen[7] ,
    \line_a_buf_g_wen[6] ,
    \line_a_buf_g_wen[5] ,
    \line_a_buf_g_wen[4] ,
    \line_a_buf_g_wen[3] ,
    \line_a_buf_g_wen[2] ,
    \line_a_buf_g_wen[1] ,
    \line_a_buf_g_wen[0] }));
 gf180_ram_256x8_wrapper line_a_buf_r (.CEN(line_a_buf_r_cen),
    .CLK(line_a_buf_r_clk),
    .GWEN(line_a_buf_r_gwen),
    .A({\line_a_buf_r_a[7] ,
    \line_a_buf_r_a[6] ,
    \line_a_buf_r_a[5] ,
    \line_a_buf_r_a[4] ,
    \line_a_buf_r_a[3] ,
    \line_a_buf_r_a[2] ,
    \line_a_buf_r_a[1] ,
    \line_a_buf_r_a[0] }),
    .D({\line_a_buf_r_d[7] ,
    \line_a_buf_r_d[6] ,
    \line_a_buf_r_d[5] ,
    \line_a_buf_r_d[4] ,
    \line_a_buf_r_d[3] ,
    \line_a_buf_r_d[2] ,
    \line_a_buf_r_d[1] ,
    \line_a_buf_r_d[0] }),
    .Q({\line_a_buf_r_q[7] ,
    \line_a_buf_r_q[6] ,
    \line_a_buf_r_q[5] ,
    \line_a_buf_r_q[4] ,
    \line_a_buf_r_q[3] ,
    \line_a_buf_r_q[2] ,
    \line_a_buf_r_q[1] ,
    \line_a_buf_r_q[0] }),
    .WEN({\line_a_buf_r_wen[7] ,
    \line_a_buf_r_wen[6] ,
    \line_a_buf_r_wen[5] ,
    \line_a_buf_r_wen[4] ,
    \line_a_buf_r_wen[3] ,
    \line_a_buf_r_wen[2] ,
    \line_a_buf_r_wen[1] ,
    \line_a_buf_r_wen[0] }));
 gf180_ram_256x8_wrapper line_b_buf_b (.CEN(line_b_buf_b_cen),
    .CLK(line_b_buf_b_clk),
    .GWEN(line_b_buf_b_gwen),
    .A({\line_b_buf_b_a[7] ,
    \line_b_buf_b_a[6] ,
    \line_b_buf_b_a[5] ,
    \line_b_buf_b_a[4] ,
    \line_b_buf_b_a[3] ,
    \line_b_buf_b_a[2] ,
    \line_b_buf_b_a[1] ,
    \line_b_buf_b_a[0] }),
    .D({\line_b_buf_b_d[7] ,
    \line_b_buf_b_d[6] ,
    \line_b_buf_b_d[5] ,
    \line_b_buf_b_d[4] ,
    \line_b_buf_b_d[3] ,
    \line_b_buf_b_d[2] ,
    \line_b_buf_b_d[1] ,
    \line_b_buf_b_d[0] }),
    .Q({\line_b_buf_b_q[7] ,
    \line_b_buf_b_q[6] ,
    \line_b_buf_b_q[5] ,
    \line_b_buf_b_q[4] ,
    \line_b_buf_b_q[3] ,
    \line_b_buf_b_q[2] ,
    \line_b_buf_b_q[1] ,
    \line_b_buf_b_q[0] }),
    .WEN({\line_b_buf_b_wen[7] ,
    \line_b_buf_b_wen[6] ,
    \line_b_buf_b_wen[5] ,
    \line_b_buf_b_wen[4] ,
    \line_b_buf_b_wen[3] ,
    \line_b_buf_b_wen[2] ,
    \line_b_buf_b_wen[1] ,
    \line_b_buf_b_wen[0] }));
 gf180_ram_256x8_wrapper line_b_buf_d (.CEN(line_b_buf_d_cen),
    .CLK(line_b_buf_d_clk),
    .GWEN(line_b_buf_d_gwen),
    .A({\line_b_buf_d_a[7] ,
    \line_b_buf_d_a[6] ,
    \line_b_buf_d_a[5] ,
    \line_b_buf_d_a[4] ,
    \line_b_buf_d_a[3] ,
    \line_b_buf_d_a[2] ,
    \line_b_buf_d_a[1] ,
    \line_b_buf_d_a[0] }),
    .D({\line_b_buf_d_d[7] ,
    \line_b_buf_d_d[6] ,
    \line_b_buf_d_d[5] ,
    \line_b_buf_d_d[4] ,
    \line_b_buf_d_d[3] ,
    \line_b_buf_d_d[2] ,
    \line_b_buf_d_d[1] ,
    \line_b_buf_d_d[0] }),
    .Q({\line_b_buf_d_q[7] ,
    \line_b_buf_d_q[6] ,
    \line_b_buf_d_q[5] ,
    \line_b_buf_d_q[4] ,
    \line_b_buf_d_q[3] ,
    \line_b_buf_d_q[2] ,
    \line_b_buf_d_q[1] ,
    \line_b_buf_d_q[0] }),
    .WEN({\line_b_buf_d_wen[7] ,
    \line_b_buf_d_wen[6] ,
    \line_b_buf_d_wen[5] ,
    \line_b_buf_d_wen[4] ,
    \line_b_buf_d_wen[3] ,
    \line_b_buf_d_wen[2] ,
    \line_b_buf_d_wen[1] ,
    \line_b_buf_d_wen[0] }));
 gf180_ram_256x8_wrapper line_b_buf_g (.CEN(line_b_buf_g_cen),
    .CLK(line_b_buf_g_clk),
    .GWEN(line_b_buf_g_gwen),
    .A({\line_b_buf_g_a[7] ,
    \line_b_buf_g_a[6] ,
    \line_b_buf_g_a[5] ,
    \line_b_buf_g_a[4] ,
    \line_b_buf_g_a[3] ,
    \line_b_buf_g_a[2] ,
    \line_b_buf_g_a[1] ,
    \line_b_buf_g_a[0] }),
    .D({\line_b_buf_g_d[7] ,
    \line_b_buf_g_d[6] ,
    \line_b_buf_g_d[5] ,
    \line_b_buf_g_d[4] ,
    \line_b_buf_g_d[3] ,
    \line_b_buf_g_d[2] ,
    \line_b_buf_g_d[1] ,
    \line_b_buf_g_d[0] }),
    .Q({\line_b_buf_g_q[7] ,
    \line_b_buf_g_q[6] ,
    \line_b_buf_g_q[5] ,
    \line_b_buf_g_q[4] ,
    \line_b_buf_g_q[3] ,
    \line_b_buf_g_q[2] ,
    \line_b_buf_g_q[1] ,
    \line_b_buf_g_q[0] }),
    .WEN({\line_b_buf_g_wen[7] ,
    \line_b_buf_g_wen[6] ,
    \line_b_buf_g_wen[5] ,
    \line_b_buf_g_wen[4] ,
    \line_b_buf_g_wen[3] ,
    \line_b_buf_g_wen[2] ,
    \line_b_buf_g_wen[1] ,
    \line_b_buf_g_wen[0] }));
 gf180_ram_256x8_wrapper line_b_buf_r (.CEN(line_b_buf_r_cen),
    .CLK(line_b_buf_r_clk),
    .GWEN(line_b_buf_r_gwen),
    .A({\line_b_buf_r_a[7] ,
    \line_b_buf_r_a[6] ,
    \line_b_buf_r_a[5] ,
    \line_b_buf_r_a[4] ,
    \line_b_buf_r_a[3] ,
    \line_b_buf_r_a[2] ,
    \line_b_buf_r_a[1] ,
    \line_b_buf_r_a[0] }),
    .D({\line_b_buf_r_d[7] ,
    \line_b_buf_r_d[6] ,
    \line_b_buf_r_d[5] ,
    \line_b_buf_r_d[4] ,
    \line_b_buf_r_d[3] ,
    \line_b_buf_r_d[2] ,
    \line_b_buf_r_d[1] ,
    \line_b_buf_r_d[0] }),
    .Q({\line_b_buf_r_q[7] ,
    \line_b_buf_r_q[6] ,
    \line_b_buf_r_q[5] ,
    \line_b_buf_r_q[4] ,
    \line_b_buf_r_q[3] ,
    \line_b_buf_r_q[2] ,
    \line_b_buf_r_q[1] ,
    \line_b_buf_r_q[0] }),
    .WEN({\line_b_buf_r_wen[7] ,
    \line_b_buf_r_wen[6] ,
    \line_b_buf_r_wen[5] ,
    \line_b_buf_r_wen[4] ,
    \line_b_buf_r_wen[3] ,
    \line_b_buf_r_wen[2] ,
    \line_b_buf_r_wen[1] ,
    \line_b_buf_r_wen[0] }));
 tjrpu mprj (.line_a_buf_b_cen(line_a_buf_b_cen),
    .line_a_buf_b_clk(line_a_buf_b_clk),
    .line_a_buf_b_gwen(line_a_buf_b_gwen),
    .line_a_buf_d_cen(line_a_buf_d_cen),
    .line_a_buf_d_clk(line_a_buf_d_clk),
    .line_a_buf_d_gwen(line_a_buf_d_gwen),
    .line_a_buf_g_cen(line_a_buf_g_cen),
    .line_a_buf_g_clk(line_a_buf_g_clk),
    .line_a_buf_g_gwen(line_a_buf_g_gwen),
    .line_a_buf_r_cen(line_a_buf_r_cen),
    .line_a_buf_r_clk(line_a_buf_r_clk),
    .line_a_buf_r_gwen(line_a_buf_r_gwen),
    .line_b_buf_b_cen(line_b_buf_b_cen),
    .line_b_buf_b_clk(line_b_buf_b_clk),
    .line_b_buf_b_gwen(line_b_buf_b_gwen),
    .line_b_buf_d_cen(line_b_buf_d_cen),
    .line_b_buf_d_clk(line_b_buf_d_clk),
    .line_b_buf_d_gwen(line_b_buf_d_gwen),
    .line_b_buf_g_cen(line_b_buf_g_cen),
    .line_b_buf_g_clk(line_b_buf_g_clk),
    .line_b_buf_g_gwen(line_b_buf_g_gwen),
    .line_b_buf_r_cen(line_b_buf_r_cen),
    .line_b_buf_r_clk(line_b_buf_r_clk),
    .line_b_buf_r_gwen(line_b_buf_r_gwen),
    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wbs_ack_o(wbs_ack_o),
    .wbs_cyc_i(wbs_cyc_i),
    .wbs_stb_i(wbs_stb_i),
    .wbs_we_i(wbs_we_i),
    .io_in({io_in[37],
    io_in[36],
    io_in[35],
    io_in[34],
    io_in[33],
    io_in[32],
    io_in[31],
    io_in[30],
    io_in[7],
    io_in[6],
    io_in[5],
    io_in[4],
    io_in[3],
    io_in[2],
    io_in[1],
    io_in[0]}),
    .io_oeb({io_oeb[37],
    io_oeb[36],
    io_oeb[35],
    io_oeb[34],
    io_oeb[33],
    io_oeb[32],
    io_oeb[31],
    io_oeb[30],
    io_oeb[7],
    io_oeb[6],
    io_oeb[5],
    io_oeb[4],
    io_oeb[3],
    io_oeb[2],
    io_oeb[1],
    io_oeb[0]}),
    .io_out({io_out[37],
    io_out[36],
    io_out[35],
    io_out[34],
    io_out[33],
    io_out[32],
    io_out[31],
    io_out[30],
    io_out[7],
    io_out[6],
    io_out[5],
    io_out[4],
    io_out[3],
    io_out[2],
    io_out[1],
    io_out[0]}),
    .irq({user_irq[2],
    user_irq[1],
    user_irq[0]}),
    .la_data_in({la_data_in[63],
    la_data_in[62],
    la_data_in[61],
    la_data_in[60],
    la_data_in[59],
    la_data_in[58],
    la_data_in[57],
    la_data_in[56],
    la_data_in[55],
    la_data_in[54],
    la_data_in[53],
    la_data_in[52],
    la_data_in[51],
    la_data_in[50],
    la_data_in[49],
    la_data_in[48],
    la_data_in[47],
    la_data_in[46],
    la_data_in[45],
    la_data_in[44],
    la_data_in[43],
    la_data_in[42],
    la_data_in[41],
    la_data_in[40],
    la_data_in[39],
    la_data_in[38],
    la_data_in[37],
    la_data_in[36],
    la_data_in[35],
    la_data_in[34],
    la_data_in[33],
    la_data_in[32],
    la_data_in[31],
    la_data_in[30],
    la_data_in[29],
    la_data_in[28],
    la_data_in[27],
    la_data_in[26],
    la_data_in[25],
    la_data_in[24],
    la_data_in[23],
    la_data_in[22],
    la_data_in[21],
    la_data_in[20],
    la_data_in[19],
    la_data_in[18],
    la_data_in[17],
    la_data_in[16],
    la_data_in[15],
    la_data_in[14],
    la_data_in[13],
    la_data_in[12],
    la_data_in[11],
    la_data_in[10],
    la_data_in[9],
    la_data_in[8],
    la_data_in[7],
    la_data_in[6],
    la_data_in[5],
    la_data_in[4],
    la_data_in[3],
    la_data_in[2],
    la_data_in[1],
    la_data_in[0]}),
    .la_data_out({la_data_out[63],
    la_data_out[62],
    la_data_out[61],
    la_data_out[60],
    la_data_out[59],
    la_data_out[58],
    la_data_out[57],
    la_data_out[56],
    la_data_out[55],
    la_data_out[54],
    la_data_out[53],
    la_data_out[52],
    la_data_out[51],
    la_data_out[50],
    la_data_out[49],
    la_data_out[48],
    la_data_out[47],
    la_data_out[46],
    la_data_out[45],
    la_data_out[44],
    la_data_out[43],
    la_data_out[42],
    la_data_out[41],
    la_data_out[40],
    la_data_out[39],
    la_data_out[38],
    la_data_out[37],
    la_data_out[36],
    la_data_out[35],
    la_data_out[34],
    la_data_out[33],
    la_data_out[32],
    la_data_out[31],
    la_data_out[30],
    la_data_out[29],
    la_data_out[28],
    la_data_out[27],
    la_data_out[26],
    la_data_out[25],
    la_data_out[24],
    la_data_out[23],
    la_data_out[22],
    la_data_out[21],
    la_data_out[20],
    la_data_out[19],
    la_data_out[18],
    la_data_out[17],
    la_data_out[16],
    la_data_out[15],
    la_data_out[14],
    la_data_out[13],
    la_data_out[12],
    la_data_out[11],
    la_data_out[10],
    la_data_out[9],
    la_data_out[8],
    la_data_out[7],
    la_data_out[6],
    la_data_out[5],
    la_data_out[4],
    la_data_out[3],
    la_data_out[2],
    la_data_out[1],
    la_data_out[0]}),
    .la_oenb({la_oenb[63],
    la_oenb[62],
    la_oenb[61],
    la_oenb[60],
    la_oenb[59],
    la_oenb[58],
    la_oenb[57],
    la_oenb[56],
    la_oenb[55],
    la_oenb[54],
    la_oenb[53],
    la_oenb[52],
    la_oenb[51],
    la_oenb[50],
    la_oenb[49],
    la_oenb[48],
    la_oenb[47],
    la_oenb[46],
    la_oenb[45],
    la_oenb[44],
    la_oenb[43],
    la_oenb[42],
    la_oenb[41],
    la_oenb[40],
    la_oenb[39],
    la_oenb[38],
    la_oenb[37],
    la_oenb[36],
    la_oenb[35],
    la_oenb[34],
    la_oenb[33],
    la_oenb[32],
    la_oenb[31],
    la_oenb[30],
    la_oenb[29],
    la_oenb[28],
    la_oenb[27],
    la_oenb[26],
    la_oenb[25],
    la_oenb[24],
    la_oenb[23],
    la_oenb[22],
    la_oenb[21],
    la_oenb[20],
    la_oenb[19],
    la_oenb[18],
    la_oenb[17],
    la_oenb[16],
    la_oenb[15],
    la_oenb[14],
    la_oenb[13],
    la_oenb[12],
    la_oenb[11],
    la_oenb[10],
    la_oenb[9],
    la_oenb[8],
    la_oenb[7],
    la_oenb[6],
    la_oenb[5],
    la_oenb[4],
    la_oenb[3],
    la_oenb[2],
    la_oenb[1],
    la_oenb[0]}),
    .line_a_buf_b_a({\line_a_buf_b_a[7] ,
    \line_a_buf_b_a[6] ,
    \line_a_buf_b_a[5] ,
    \line_a_buf_b_a[4] ,
    \line_a_buf_b_a[3] ,
    \line_a_buf_b_a[2] ,
    \line_a_buf_b_a[1] ,
    \line_a_buf_b_a[0] }),
    .line_a_buf_b_d({\line_a_buf_b_d[7] ,
    \line_a_buf_b_d[6] ,
    \line_a_buf_b_d[5] ,
    \line_a_buf_b_d[4] ,
    \line_a_buf_b_d[3] ,
    \line_a_buf_b_d[2] ,
    \line_a_buf_b_d[1] ,
    \line_a_buf_b_d[0] }),
    .line_a_buf_b_q({\line_a_buf_b_q[7] ,
    \line_a_buf_b_q[6] ,
    \line_a_buf_b_q[5] ,
    \line_a_buf_b_q[4] ,
    \line_a_buf_b_q[3] ,
    \line_a_buf_b_q[2] ,
    \line_a_buf_b_q[1] ,
    \line_a_buf_b_q[0] }),
    .line_a_buf_b_wen({\line_a_buf_b_wen[7] ,
    \line_a_buf_b_wen[6] ,
    \line_a_buf_b_wen[5] ,
    \line_a_buf_b_wen[4] ,
    \line_a_buf_b_wen[3] ,
    \line_a_buf_b_wen[2] ,
    \line_a_buf_b_wen[1] ,
    \line_a_buf_b_wen[0] }),
    .line_a_buf_d_a({\line_a_buf_d_a[7] ,
    \line_a_buf_d_a[6] ,
    \line_a_buf_d_a[5] ,
    \line_a_buf_d_a[4] ,
    \line_a_buf_d_a[3] ,
    \line_a_buf_d_a[2] ,
    \line_a_buf_d_a[1] ,
    \line_a_buf_d_a[0] }),
    .line_a_buf_d_d({\line_a_buf_d_d[7] ,
    \line_a_buf_d_d[6] ,
    \line_a_buf_d_d[5] ,
    \line_a_buf_d_d[4] ,
    \line_a_buf_d_d[3] ,
    \line_a_buf_d_d[2] ,
    \line_a_buf_d_d[1] ,
    \line_a_buf_d_d[0] }),
    .line_a_buf_d_q({\line_a_buf_d_q[7] ,
    \line_a_buf_d_q[6] ,
    \line_a_buf_d_q[5] ,
    \line_a_buf_d_q[4] ,
    \line_a_buf_d_q[3] ,
    \line_a_buf_d_q[2] ,
    \line_a_buf_d_q[1] ,
    \line_a_buf_d_q[0] }),
    .line_a_buf_d_wen({\line_a_buf_d_wen[7] ,
    \line_a_buf_d_wen[6] ,
    \line_a_buf_d_wen[5] ,
    \line_a_buf_d_wen[4] ,
    \line_a_buf_d_wen[3] ,
    \line_a_buf_d_wen[2] ,
    \line_a_buf_d_wen[1] ,
    \line_a_buf_d_wen[0] }),
    .line_a_buf_g_a({\line_a_buf_g_a[7] ,
    \line_a_buf_g_a[6] ,
    \line_a_buf_g_a[5] ,
    \line_a_buf_g_a[4] ,
    \line_a_buf_g_a[3] ,
    \line_a_buf_g_a[2] ,
    \line_a_buf_g_a[1] ,
    \line_a_buf_g_a[0] }),
    .line_a_buf_g_d({\line_a_buf_g_d[7] ,
    \line_a_buf_g_d[6] ,
    \line_a_buf_g_d[5] ,
    \line_a_buf_g_d[4] ,
    \line_a_buf_g_d[3] ,
    \line_a_buf_g_d[2] ,
    \line_a_buf_g_d[1] ,
    \line_a_buf_g_d[0] }),
    .line_a_buf_g_q({\line_a_buf_g_q[7] ,
    \line_a_buf_g_q[6] ,
    \line_a_buf_g_q[5] ,
    \line_a_buf_g_q[4] ,
    \line_a_buf_g_q[3] ,
    \line_a_buf_g_q[2] ,
    \line_a_buf_g_q[1] ,
    \line_a_buf_g_q[0] }),
    .line_a_buf_g_wen({\line_a_buf_g_wen[7] ,
    \line_a_buf_g_wen[6] ,
    \line_a_buf_g_wen[5] ,
    \line_a_buf_g_wen[4] ,
    \line_a_buf_g_wen[3] ,
    \line_a_buf_g_wen[2] ,
    \line_a_buf_g_wen[1] ,
    \line_a_buf_g_wen[0] }),
    .line_a_buf_r_a({\line_a_buf_r_a[7] ,
    \line_a_buf_r_a[6] ,
    \line_a_buf_r_a[5] ,
    \line_a_buf_r_a[4] ,
    \line_a_buf_r_a[3] ,
    \line_a_buf_r_a[2] ,
    \line_a_buf_r_a[1] ,
    \line_a_buf_r_a[0] }),
    .line_a_buf_r_d({\line_a_buf_r_d[7] ,
    \line_a_buf_r_d[6] ,
    \line_a_buf_r_d[5] ,
    \line_a_buf_r_d[4] ,
    \line_a_buf_r_d[3] ,
    \line_a_buf_r_d[2] ,
    \line_a_buf_r_d[1] ,
    \line_a_buf_r_d[0] }),
    .line_a_buf_r_q({\line_a_buf_r_q[7] ,
    \line_a_buf_r_q[6] ,
    \line_a_buf_r_q[5] ,
    \line_a_buf_r_q[4] ,
    \line_a_buf_r_q[3] ,
    \line_a_buf_r_q[2] ,
    \line_a_buf_r_q[1] ,
    \line_a_buf_r_q[0] }),
    .line_a_buf_r_wen({\line_a_buf_r_wen[7] ,
    \line_a_buf_r_wen[6] ,
    \line_a_buf_r_wen[5] ,
    \line_a_buf_r_wen[4] ,
    \line_a_buf_r_wen[3] ,
    \line_a_buf_r_wen[2] ,
    \line_a_buf_r_wen[1] ,
    \line_a_buf_r_wen[0] }),
    .line_b_buf_b_a({\line_b_buf_b_a[7] ,
    \line_b_buf_b_a[6] ,
    \line_b_buf_b_a[5] ,
    \line_b_buf_b_a[4] ,
    \line_b_buf_b_a[3] ,
    \line_b_buf_b_a[2] ,
    \line_b_buf_b_a[1] ,
    \line_b_buf_b_a[0] }),
    .line_b_buf_b_d({\line_b_buf_b_d[7] ,
    \line_b_buf_b_d[6] ,
    \line_b_buf_b_d[5] ,
    \line_b_buf_b_d[4] ,
    \line_b_buf_b_d[3] ,
    \line_b_buf_b_d[2] ,
    \line_b_buf_b_d[1] ,
    \line_b_buf_b_d[0] }),
    .line_b_buf_b_q({\line_b_buf_b_q[7] ,
    \line_b_buf_b_q[6] ,
    \line_b_buf_b_q[5] ,
    \line_b_buf_b_q[4] ,
    \line_b_buf_b_q[3] ,
    \line_b_buf_b_q[2] ,
    \line_b_buf_b_q[1] ,
    \line_b_buf_b_q[0] }),
    .line_b_buf_b_wen({\line_b_buf_b_wen[7] ,
    \line_b_buf_b_wen[6] ,
    \line_b_buf_b_wen[5] ,
    \line_b_buf_b_wen[4] ,
    \line_b_buf_b_wen[3] ,
    \line_b_buf_b_wen[2] ,
    \line_b_buf_b_wen[1] ,
    \line_b_buf_b_wen[0] }),
    .line_b_buf_d_a({\line_b_buf_d_a[7] ,
    \line_b_buf_d_a[6] ,
    \line_b_buf_d_a[5] ,
    \line_b_buf_d_a[4] ,
    \line_b_buf_d_a[3] ,
    \line_b_buf_d_a[2] ,
    \line_b_buf_d_a[1] ,
    \line_b_buf_d_a[0] }),
    .line_b_buf_d_d({\line_b_buf_d_d[7] ,
    \line_b_buf_d_d[6] ,
    \line_b_buf_d_d[5] ,
    \line_b_buf_d_d[4] ,
    \line_b_buf_d_d[3] ,
    \line_b_buf_d_d[2] ,
    \line_b_buf_d_d[1] ,
    \line_b_buf_d_d[0] }),
    .line_b_buf_d_q({\line_b_buf_d_q[7] ,
    \line_b_buf_d_q[6] ,
    \line_b_buf_d_q[5] ,
    \line_b_buf_d_q[4] ,
    \line_b_buf_d_q[3] ,
    \line_b_buf_d_q[2] ,
    \line_b_buf_d_q[1] ,
    \line_b_buf_d_q[0] }),
    .line_b_buf_d_wen({\line_b_buf_d_wen[7] ,
    \line_b_buf_d_wen[6] ,
    \line_b_buf_d_wen[5] ,
    \line_b_buf_d_wen[4] ,
    \line_b_buf_d_wen[3] ,
    \line_b_buf_d_wen[2] ,
    \line_b_buf_d_wen[1] ,
    \line_b_buf_d_wen[0] }),
    .line_b_buf_g_a({\line_b_buf_g_a[7] ,
    \line_b_buf_g_a[6] ,
    \line_b_buf_g_a[5] ,
    \line_b_buf_g_a[4] ,
    \line_b_buf_g_a[3] ,
    \line_b_buf_g_a[2] ,
    \line_b_buf_g_a[1] ,
    \line_b_buf_g_a[0] }),
    .line_b_buf_g_d({\line_b_buf_g_d[7] ,
    \line_b_buf_g_d[6] ,
    \line_b_buf_g_d[5] ,
    \line_b_buf_g_d[4] ,
    \line_b_buf_g_d[3] ,
    \line_b_buf_g_d[2] ,
    \line_b_buf_g_d[1] ,
    \line_b_buf_g_d[0] }),
    .line_b_buf_g_q({\line_b_buf_g_q[7] ,
    \line_b_buf_g_q[6] ,
    \line_b_buf_g_q[5] ,
    \line_b_buf_g_q[4] ,
    \line_b_buf_g_q[3] ,
    \line_b_buf_g_q[2] ,
    \line_b_buf_g_q[1] ,
    \line_b_buf_g_q[0] }),
    .line_b_buf_g_wen({\line_b_buf_g_wen[7] ,
    \line_b_buf_g_wen[6] ,
    \line_b_buf_g_wen[5] ,
    \line_b_buf_g_wen[4] ,
    \line_b_buf_g_wen[3] ,
    \line_b_buf_g_wen[2] ,
    \line_b_buf_g_wen[1] ,
    \line_b_buf_g_wen[0] }),
    .line_b_buf_r_a({\line_b_buf_r_a[7] ,
    \line_b_buf_r_a[6] ,
    \line_b_buf_r_a[5] ,
    \line_b_buf_r_a[4] ,
    \line_b_buf_r_a[3] ,
    \line_b_buf_r_a[2] ,
    \line_b_buf_r_a[1] ,
    \line_b_buf_r_a[0] }),
    .line_b_buf_r_d({\line_b_buf_r_d[7] ,
    \line_b_buf_r_d[6] ,
    \line_b_buf_r_d[5] ,
    \line_b_buf_r_d[4] ,
    \line_b_buf_r_d[3] ,
    \line_b_buf_r_d[2] ,
    \line_b_buf_r_d[1] ,
    \line_b_buf_r_d[0] }),
    .line_b_buf_r_q({\line_b_buf_r_q[7] ,
    \line_b_buf_r_q[6] ,
    \line_b_buf_r_q[5] ,
    \line_b_buf_r_q[4] ,
    \line_b_buf_r_q[3] ,
    \line_b_buf_r_q[2] ,
    \line_b_buf_r_q[1] ,
    \line_b_buf_r_q[0] }),
    .line_b_buf_r_wen({\line_b_buf_r_wen[7] ,
    \line_b_buf_r_wen[6] ,
    \line_b_buf_r_wen[5] ,
    \line_b_buf_r_wen[4] ,
    \line_b_buf_r_wen[3] ,
    \line_b_buf_r_wen[2] ,
    \line_b_buf_r_wen[1] ,
    \line_b_buf_r_wen[0] }),
    .wbs_adr_i({wbs_adr_i[31],
    wbs_adr_i[30],
    wbs_adr_i[29],
    wbs_adr_i[28],
    wbs_adr_i[27],
    wbs_adr_i[26],
    wbs_adr_i[25],
    wbs_adr_i[24],
    wbs_adr_i[23],
    wbs_adr_i[22],
    wbs_adr_i[21],
    wbs_adr_i[20],
    wbs_adr_i[19],
    wbs_adr_i[18],
    wbs_adr_i[17],
    wbs_adr_i[16],
    wbs_adr_i[15],
    wbs_adr_i[14],
    wbs_adr_i[13],
    wbs_adr_i[12],
    wbs_adr_i[11],
    wbs_adr_i[10],
    wbs_adr_i[9],
    wbs_adr_i[8],
    wbs_adr_i[7],
    wbs_adr_i[6],
    wbs_adr_i[5],
    wbs_adr_i[4],
    wbs_adr_i[3],
    wbs_adr_i[2],
    wbs_adr_i[1],
    wbs_adr_i[0]}),
    .wbs_dat_i({wbs_dat_i[31],
    wbs_dat_i[30],
    wbs_dat_i[29],
    wbs_dat_i[28],
    wbs_dat_i[27],
    wbs_dat_i[26],
    wbs_dat_i[25],
    wbs_dat_i[24],
    wbs_dat_i[23],
    wbs_dat_i[22],
    wbs_dat_i[21],
    wbs_dat_i[20],
    wbs_dat_i[19],
    wbs_dat_i[18],
    wbs_dat_i[17],
    wbs_dat_i[16],
    wbs_dat_i[15],
    wbs_dat_i[14],
    wbs_dat_i[13],
    wbs_dat_i[12],
    wbs_dat_i[11],
    wbs_dat_i[10],
    wbs_dat_i[9],
    wbs_dat_i[8],
    wbs_dat_i[7],
    wbs_dat_i[6],
    wbs_dat_i[5],
    wbs_dat_i[4],
    wbs_dat_i[3],
    wbs_dat_i[2],
    wbs_dat_i[1],
    wbs_dat_i[0]}),
    .wbs_dat_o({wbs_dat_o[31],
    wbs_dat_o[30],
    wbs_dat_o[29],
    wbs_dat_o[28],
    wbs_dat_o[27],
    wbs_dat_o[26],
    wbs_dat_o[25],
    wbs_dat_o[24],
    wbs_dat_o[23],
    wbs_dat_o[22],
    wbs_dat_o[21],
    wbs_dat_o[20],
    wbs_dat_o[19],
    wbs_dat_o[18],
    wbs_dat_o[17],
    wbs_dat_o[16],
    wbs_dat_o[15],
    wbs_dat_o[14],
    wbs_dat_o[13],
    wbs_dat_o[12],
    wbs_dat_o[11],
    wbs_dat_o[10],
    wbs_dat_o[9],
    wbs_dat_o[8],
    wbs_dat_o[7],
    wbs_dat_o[6],
    wbs_dat_o[5],
    wbs_dat_o[4],
    wbs_dat_o[3],
    wbs_dat_o[2],
    wbs_dat_o[1],
    wbs_dat_o[0]}),
    .wbs_sel_i({wbs_sel_i[3],
    wbs_sel_i[2],
    wbs_sel_i[1],
    wbs_sel_i[0]}));
endmodule

