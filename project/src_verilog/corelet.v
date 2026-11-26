module corelet #(parameter bw = 4,
                 parameter psum_bw = 16,
                 parameter col = 8,
                 parameter row = 8)(
                 
                 input clk, reset,
                 input [33:0] inst,
                 input [row*bw-1:0] xmem_q,
                 input [psum_bw*col-1:0] pmem_q,
                 output ofifo_valid,
                 output [psum_bw*col-1:0] ofifo_out,
                 output [psum_bw*col-1:0] sfp_out
                 );
  
  wire [row*bw-1:0] l0_out;
  wire [col-1:0] array_valid;
  wire [psum_bw*col-1:0] array_out;
  
  mac_array #(.bw(bw), .psum_bw(psum_bw), .col(col), .row(row)) MAC_ARRAY (
    .clk(clk),
    .reset(reset),
    .inst_w(inst[1:0]),
    .in_w(l0_out),
    .in_n({psum_bw*col{1'b0}}),
    .valid(array_valid),
    .out_s(array_out)
  );
  
  l0 #(.row(row), .bw(bw)) L0 (
    .clk(clk),
    .reset(reset),
    .wr(inst[2]), .rd(inst[3]),
    .in(xmem_q),
    .o_full(),
    .o_ready(),
    .out(l0_out)
  );
  
  ofifo #(.col(col), .bw(psum_bw)) OFIFO (
    .clk(clk),
    .reset(reset), .rd(inst[6]),
    .wr(array_valid),
    .in(array_out),
    .out(ofifo_out),
    .o_valid(ofifo_valid),
    .o_full(),
    .o_ready()
  );
  
  sfu #(.col(col), .psum_bw(psum_bw)) SFP (
    .clk(clk),
    .reset(reset),
    .acc(inst[33]),
    .in(pmem_q),
    .out(sfp_out)
  );
  
endmodule