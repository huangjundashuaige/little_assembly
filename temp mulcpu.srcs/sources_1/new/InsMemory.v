`timescale 1ns / 1ps  
  
module InsMemory(input [31:0] addr,  
                 input InsMemRW, IRWre, clk,  
                 output reg [31:0] ins);  
                        
    reg [31:0] ins_out;  
    reg [7:0] mem [0:127];    
     initial begin  
         $readmemb("D:\ins.txt", mem);    
     end  
    always @( addr or InsMemRW) begin  
        if (InsMemRW) begin  
          ins_out[31:24] = mem[addr];  
          ins_out[23:16] = mem[addr+1];  //÷ª”√º”1
          ins_out[15:8] = mem[addr+2];  
          ins_out[7:0] = mem[addr+3];  
        end  
     end  
       
     always @(posedge clk) begin  
         if (IRWre) ins <= ins_out;  
     end  
  
endmodule  