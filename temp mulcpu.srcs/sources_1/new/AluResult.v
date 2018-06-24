`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/11 15:21:24
// Design Name: 
// Module Name: AluResult
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module AluResult(input [31:0] result,        //alu½á¹û¼Ä´æÆ÷
                input clk,
                output reg[31:0] aluResult);                 
    always @(posedge clk) begin  
        aluResult = result;  
    end  
endmodule
