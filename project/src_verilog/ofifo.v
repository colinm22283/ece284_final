module ofifo #(parameter col = 8,
               parameter bw  = 4)(
               
               input clk, reset, rd,
               input [col-1:0] wr,
               input [col*bw-1:0] in,
               output o_full, o_ready, o_valid,
               output [col*bw-1:0] out
               );

  wire [col-1:0] empty;
  wire [col-1:0] full;
  reg  rd_en;
  
  genvar i;

  assign o_ready = full ? 0 : 1;
  assign o_full  = full ? 1 : 0;
  assign o_valid = empty ? 0 : 1;

  for (i=0; i<col ; i=i+1) begin : col_num
    fifo_depth64 #(.bw(bw)) fifo_instance (
      .rd_clk(clk),
      .wr_clk(clk),
      .rd(rd_en),
      .wr(wr[i]),
      .o_empty(empty[i]),
      .o_full(full[i]),
      .in(in[bw*(i+1)-1:bw*i]),
      .out(out[bw*(i+1)-1:bw*i]),
      .reset(reset)
    );
  end


  always @ (posedge clk) begin
    if (reset) begin
      rd_en <= 0;
    end
    else
      rd_en <= rd;
  end
endmodule