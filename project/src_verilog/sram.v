module sram #(parameter bw      = 128,
              parameter wrd     = 2048,
              parameter addr_bw = 11)(
              
              input CLK, WEN, CEN,
              input [bw-1:0] D,
              input [addr_bw-1:0] A,
              output [bw-1:0] Q
              );

  reg [bw-1:0] memory [wrd-1:0];
  reg [addr_bw-1:0] addr_q;
  
  assign Q = memory[addr_q];
  
  always @(posedge CLK) begin
    if (!CEN && WEN)
      addr_q <= A;
    if (!CEN && !WEN)
      memory[A] <= D;
  end
endmodule