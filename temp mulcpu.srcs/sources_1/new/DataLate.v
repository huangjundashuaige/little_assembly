`timescale 1ns / 1ps  
  
module DataLate(input [31:0] inData,  
                input clk,
                output reg [31:0] outData);  
                always @(negedge clk) begin   //���ź��ӳ�һ������
                 outData = inData;  
                 end  
  
endmodule  