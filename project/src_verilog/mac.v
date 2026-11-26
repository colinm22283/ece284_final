module mac #(parameter bw = 4,
             parameter psum_bw = 16)(
             
             input signed [bw-1:0] a, b,
             input signed [psum_bw-1:0] c,
             output signed [psum_bw-1:0] out
             );

  wire signed [2*bw:0] product;
  wire signed [psum_bw-1:0] psum;
  wire signed [bw:0]   a_pad;

  assign a_pad = {1'b0, a};
  assign product = a_pad * b;

  assign psum = product + c;
  assign out = psum;

endmodule