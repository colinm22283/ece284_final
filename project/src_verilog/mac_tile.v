module mac_tile #(parameter bw = 4,
                  parameter psum_bw = 16)(
                  
                  input clk, reset,
                  input [1:0] inst_w,
                  input [bw-1:0] in_w,
                  input [psum_bw-1:0] in_n,
                  output [1:0] inst_e,
                  output [bw-1:0] out_e,
                  output [psum_bw-1:0] out_s
                  );

  wire [psum_bw-1:0] mac_out;
  reg load_ready_q;
  reg [1:0] inst_q;
  reg [bw-1:0] a_q, b_q;
  reg [psum_bw-1:0] c_q;

  mac #(.bw(bw), .psum_bw(psum_bw)) mac_instance (
    .a(a_q), 
    .b(b_q),
    .c(c_q),
    .out(mac_out)
  ); 

  assign out_e  = a_q;
  assign inst_e = inst_q;
  assign out_s  = mac_out;
  
  always @(posedge clk) begin
    if (reset) begin
      inst_q       <= 0;
      load_ready_q <= 1;
    end else begin
      inst_q[1] <= inst_w[1];
      
      if (inst_w[0] || inst_w[1])
        a_q <= in_w;
      if (inst_w[0] && load_ready_q) begin
        b_q          <= in_w;
        load_ready_q <= 0;
      end 
      if (!load_ready_q)
        inst_q[0] <= inst_w[0];
        
      c_q <= in_n;
    end
  end
endmodule