module mac_row #(parameter bw = 4,
                 parameter psum_bw = 16,
                 parameter col = 8)(
                 
                 input clk, reset,
                 input [1:0] inst_w,
                 input [bw-1:0] in_w,
                 input [psum_bw*col-1:0] in_n,
                 output [col-1:0] valid,
                 output [psum_bw*col-1:0] out_s
                 );

  wire [(col+1)*bw-1:0] temp;
  wire [2*(col+1)-1:0] inst_temp;
  genvar i;

  assign temp[bw-1:0]   = in_w;
  assign inst_temp[1:0] = inst_w;
  
  for (i=1; i < col+1 ; i=i+1) begin : col_num
    mac_tile #(.bw(bw), .psum_bw(psum_bw)) mac_tile_instance (
      .clk(clk),
      .reset(reset),
      .in_w(temp[bw*i-1:bw*(i-1)]),
      .out_e(temp[bw*(i+1)-1:bw*i]),
      .inst_w(inst_temp[2*i-1:2*(i-1)]),
      .inst_e(inst_temp[2*(i+1)-1:2*i]),
      .in_n(in_n[psum_bw*i-1:psum_bw*(i-1)]),
      .out_s(out_s[psum_bw*i-1:psum_bw*(i-1)])
    );
    
    assign valid[i-1] = inst_temp[2*(i+1)-1];
  end

endmodule