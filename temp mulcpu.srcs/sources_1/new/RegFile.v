`timescale 1ns / 1ps  
  
module RegFile(input [4:0] rs, rt, rd,  
               input clk, RegWre, WrRegData,  
               input [1:0] RegOut,  
               input [31:0] PC4, memData,  
               output reg [31:0] data1, data2);  
  
    reg [31:0] i_data;       
    reg [4:0] selectReg;     
    reg [31:0] register [0:31];  
    integer i;  
    initial begin  
        for (i = 0 ; i < 32; i = i+1)   
              register[i] = 0;  
    end  
    always @(posedge clk) begin 
         case(RegOut)  
             2'b00: selectReg = 5'b11111;  //jalָ���е�31�żĴ���
             2'b01: selectReg = rt;         
             2'b10: selectReg = rd;  
             default selectReg = 0;  
        endcase  
        assign i_data = WrRegData? memData : PC4;  //�����������ݴ洢������PC
        assign data1 = register[rs];               
        assign data2 = register[rt];  
        if ((selectReg != 0) && (RegWre == 1)) begin // selectReg != 0 ȷ��0�żĴ������ɸı� 
            register[selectReg] <= i_data;  
        end  
    end  
  
endmodule  
