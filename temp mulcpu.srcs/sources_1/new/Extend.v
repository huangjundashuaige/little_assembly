`timescale 1ns / 1ps  
  
module Extend(input [15:0] inNum,  
              input [1:0] ExtSel,  
              output reg [31:0] out);  
                    
    always @(inNum or ExtSel) begin  
        case(ExtSel)  
            2'b00: out <= {{27{0}}, inNum[10:6]};                  // À©³ä sa  
            2'b01: out <= {{16{0}}, inNum[15:0]};                  // À©³äÁ¢¼´Êý
            2'b10: out <= {{16{inNum[15]}}, inNum[15:0]};         // ·ûºÅÀ©³äÁ¢¼´Êý£¬Èçaddi¡¢lw¡¢sw¡¢beqÖ¸Áî  
            default: out <= {{16{inNum[15]}}, inNum[15:0]};       // Ä¬ÈÏ·ûºÅÀ©Õ¹  
        endcase  
    end  
  
endmodule  