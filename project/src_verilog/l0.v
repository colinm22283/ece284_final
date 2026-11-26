module l0 #(parameter row = 8,
            parameter bw  = 4)(
            
            input clk, reset, wr, rd,
            input [row*bw-1:0] in,
            output o_full, o_ready,
            output [row*bw-1:0] out
            );
  
  wire [row-1:0] empty;
  wire [row-1:0] full;
  reg [row-1:0] rd_en;
  
  genvar i;

  assign o_ready = full ? 0 : 1;
  assign o_full  = full ? 1 : 0;

  for (i=0; i<row ; i=i+1) begin : row_num
    fifo_depth64 #(.bw(bw)) fifo_instance (
      .rd_clk(clk),
      .wr_clk(clk),
      .rd(rd_en[i]),
      .wr(wr),
      .o_empty(empty[i]),
      .o_full(full[i]),
      .in(in[bw*(i+1)-1:bw*i]),
      .out(out[bw*(i+1)-1:bw*i]),
      .reset(reset)
    );
  end


  always @ (posedge clk) begin
   if (reset) begin
      rd_en <= 8'b00000000;
   end
   else
      /////////////// version1: read all row at a time ////////////////
      //if (rd)
      //  rd_en <= 8'b11111111;
      //else
      //  rd_en <= 8'b00000000;
      ///////////////////////////////////////////////////////

      //////////////// version2: read 1 row at a time /////////////////
      rd_en <= {rd_en[row-2:0], rd};
      ///////////////////////////////////////////////////////
    end

endmodule