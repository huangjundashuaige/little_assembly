`timescale 1ns / 1ps  
module PC(input clk, Reset, PCWre,  
          input [1:0] PCSrc,  
          input wire [31:0] immi, addr, fromRd,  //pc有三种来源 立即数，j指令取的地址，jal中31号寄存器的存储地址
          output reg [31:0] Address);  
               
     always @(PCWre or negedge Reset) begin  
        if (Reset == 0) begin  
            Address = 0;  
        end else if (PCWre) begin  
            if (PCSrc == 2'b00) begin  
                    Address = Address+4;  
                end else if (PCSrc == 2'b01) begin  
                    Address = immi*4+Address+4;  
                end else if (PCSrc == 2'b10) begin  
                    Address = fromRd;  
                end else if (PCSrc == 2'b11) begin  
                    Address = addr;  
                end  
        end  
    end  
  
endmodule  