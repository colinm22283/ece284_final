module core #(parameter bw = 4,
              parameter psum_bw = 16,
              parameter row = 8,
              parameter col = 8)(
              
              input clk, reset,
              input [33:0] inst,
              input [row*bw-1:0] D_xmem,
              output ofifo_valid,
              output [psum_bw*col-1:0] sfp_out
              );
  
  wire [row*bw-1:0] xmem_q;
  wire [psum_bw*col-1:0] pmem_q;
  wire [psum_bw*col-1:0] ofifo_out;
  
  corelet #(.bw(bw), .psum_bw(psum_bw), .col(col), .row(row)) CORELET (
    .clk(clk),
    .reset(reset),
    .inst(inst),
    .xmem_q(xmem_q),
    .pmem_q(pmem_q),
    .ofifo_valid(ofifo_valid),
    .ofifo_out(ofifo_out),
    .sfp_out(sfp_out)
  );
  
  sram #(.bw(row*bw), .wrd(2048), .addr_bw(11)) XMEM (
    .CLK(clk),
    .WEN(inst[18]),
    .CEN(inst[19]),
    .D(D_xmem),
    .A(inst[17:7]),
    .Q(xmem_q)
  );
  
  sram #(.bw(psum_bw*col), .wrd(2048), .addr_bw(11)) PMEM (
    .CLK(clk),
    .WEN(inst[31]),
    .CEN(inst[32]),
    .D(ofifo_out),
    .A(inst[30:20]),
    .Q(pmem_q)
  );
  
endmodule