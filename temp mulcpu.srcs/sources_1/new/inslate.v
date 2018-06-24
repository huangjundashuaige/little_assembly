`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/11 13:30:55
// Design Name: 
// Module Name: inslate
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


module inslate(input [31:0] ins,            //Ö¸Áî¼Ä´æÆ÷
                input clk,  
                output reg [31:0] insLate);  

    always @(posedge clk) begin  
        insLate = ins;  
    end  
endmodule
