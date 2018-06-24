`timescale 1ns / 1ps  
  
module PCAddr(input [25:0] fromAdd,  
              input [31:0] PC0,  
              output reg [31:0] addr);  
    wire [27:0] mid;  
     assign mid = fromAdd << 2;            //������λ
    always @(fromAdd) begin  
        addr <= {PC0[31:28], mid[27:0]};   //��pcƴ��
    end  
  
endmodule  