module sfu #(parameter col     = 8,
             parameter psum_bw = 16)(
             
             input clk, reset, acc,
             input  [psum_bw*col-1:0] in,
             output [psum_bw*col-1:0] out
             );

  reg signed [psum_bw-1:0] acc_q [0:col-1];
  genvar i;
  
  for (i=0; i<col; i=i+1) begin
    always @(posedge clk) begin
      if (reset)
        acc_q[i] <= 0;
      else if (acc)
        acc_q[i] <= acc_q[i] + $signed(in[psum_bw*(i+1)-1:psum_bw*i]);
    end
    
    assign out[psum_bw*(i+1)-1:psum_bw*i] = acc_q[i][psum_bw-1] ? 0 : acc_q[i];
  end
endmodule