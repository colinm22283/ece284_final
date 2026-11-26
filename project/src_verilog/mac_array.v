module mac_array #(parameter bw = 4,
                   parameter psum_bw = 16,
                   parameter col = 8,
                   parameter row = 8)(
                   
                   input clk, reset,
                   input [1:0] inst_w,
                   input [row*bw-1:0] in_w,
                   input [psum_bw*col-1:0] in_n,
                   output [col-1:0] valid,
                   output [psum_bw*col-1:0] out_s
                   );

  reg    [2*row-1:0] inst_w_temp;
  wire   [psum_bw*col*(row+1)-1:0] temp;
  wire   [row*col-1:0] valid_temp;

  genvar i;
 
  assign out_s = temp[psum_bw*col*9-1:psum_bw*col*8];
  assign temp[psum_bw*col*1-1:psum_bw*col*0] = 0;
  assign valid = valid_temp[row*col-1:row*col-8];

  for (i=1; i < row+1 ; i=i+1) begin : row_num
    mac_row #(.bw(bw), .psum_bw(psum_bw)) mac_row_instance (
      .clk(clk),
      .reset(reset),
      .in_w(in_w[bw*i-1:bw*(i-1)]),
      .inst_w(inst_w_temp[2*i-1:2*(i-1)]),
      .in_n(temp[psum_bw*col*i-1:psum_bw*col*(i-1)]),
      .valid(valid_temp[col*i-1:col*(i-1)]),
      .out_s(temp[psum_bw*col*(i+1)-1:psum_bw*col*(i)])
    );
  end

  always @ (posedge clk) begin
    inst_w_temp[1:0]   <= inst_w; 
    inst_w_temp[3:2]   <= inst_w_temp[1:0]; 
    inst_w_temp[5:4]   <= inst_w_temp[3:2]; 
    inst_w_temp[7:6]   <= inst_w_temp[5:4]; 
    inst_w_temp[9:8]   <= inst_w_temp[7:6]; 
    inst_w_temp[11:10] <= inst_w_temp[9:8]; 
    inst_w_temp[13:12] <= inst_w_temp[11:10]; 
    inst_w_temp[15:14] <= inst_w_temp[13:12]; 
  end
endmodule