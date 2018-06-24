`timescale 1ns / 1ps  
// ALU alu(out1, out2, extendData,ALUSrcB, ALUOp, zero, result,sign);
module ALU(input [31:0] ReadData1, ReadData2, inExt,
            //input[4:0]sa,  
           //input ALUSrcA,
           input ALUSrcB,  
           input [2:0] ALUOp,  
           output wire zero,  
           output reg [31:0] result,
           output sign);  
       
     initial begin  
        result = 0;  
    end  
  
    wire [31:0] B;  
    //wire [4:0] A;
    //assign A = sa;
     assign B = ALUSrcB? inExt : ReadData2;  
     assign zero = (result? 0 : 1);  
     assign sign = (result[31]==1)?1:0;//是否为负数
       
     always @(ReadData1 or ReadData2 or B  or ALUOp) begin  
         case(ALUOp)  
            3'b000: result = ReadData1 + B;  // A + B  
            3'b001: result = ReadData1 - B;  // A - B  
            3'b010:  begin // 带符号比较与不带符号比较
                       if (ReadData1<B &&(( ReadData1[31] == 0 && B[31]==0) ||
                       (ReadData1[31] == 1 && B[31]==1))) result = 1;
                       else if (ReadData1[31] == 0 && B[31]==1) result = 0;
                       else if ( ReadData1[31] == 1 && B[31]==0) result = 1;
                       else result = 0;
                       end
            3'b011: result = B >> ReadData1; // A右移B位  
            3'b100: result = B << ReadData1; // A左移B位  
            3'b101: result = ReadData1 | B; // 或  
            3'b110: result = ReadData1 & B; // 与  
            3'b111: result = (~ReadData1 & B) | (ReadData1 & ~B); // 异或  
        default: result = 0;  
    endcase  
  end  
       
endmodule  