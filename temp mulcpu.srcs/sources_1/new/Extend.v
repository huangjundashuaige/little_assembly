`timescale 1ns / 1ps  
  
module Extend(input [15:0] inNum,  
              input [1:0] ExtSel,  
              output reg [31:0] out);  
                    
    always @(inNum or ExtSel) begin  
        case(ExtSel)  
            2'b00: out <= {{27{0}}, inNum[10:6]};                  // ���� sa  
            2'b01: out <= {{16{0}}, inNum[15:0]};                  // ����������
            2'b10: out <= {{16{inNum[15]}}, inNum[15:0]};         // ������������������addi��lw��sw��beqָ��  
            default: out <= {{16{inNum[15]}}, inNum[15:0]};       // Ĭ�Ϸ�����չ  
        endcase  
    end  
  
endmodule  