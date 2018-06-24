`timescale 1ns / 1ps  
  
module MCPU(input clk, reset,  
           output wire [2:0] state_out,                              //cpu当前状态
           output wire [5:0] opcode,  
           output wire [4:0] rs, rt, rd,    
           output wire [31:0] ins, ReadData1, ReadData2, pc0, aluResult,
           output wire[31:0]insLate);  

           assign opcode = insLate[31:26];  
           assign rs = insLate[25:21];  
           assign rt = insLate[20:16];  
           assign rd = insLate[15:11]; 

  
    // 数据通路  
    wire [31:0] j_addr, out1, out2, result1, i_IR, extendData, LateOut1, LateOut2, DataOut,result;
    wire zero;  
    wire sign;
    // 控制信号  
    wire [2:0] ALUOp;  
    wire [1:0] ExtSel, RegOut, PCSrc;  
    wire PCWre, IRWre, InsMemRW, WrRegData, RegWre/*, ALUSrcA*/,ALUSrcB, DataMemRW, ALUM2Reg;  
    

     PC PC(clk, reset, PCWre, PCSrc, extendData, j_addr, ReadData1, pc0);  

     InsMemory InsMemory(pc0, InsMemRW, IRWre, clk, ins);  
      
     PCAddr PcAddr(ins[25:0], pc0, j_addr);  
       
     RegFile RegFile(ins[25:21], ins[20:16], ins[15:11], clk, RegWre, WrRegData, RegOut, (pc0+4), LateOut2, ReadData1, ReadData2);  
      
     DataLate ADR(ReadData1, clk, out1);  
     DataLate BDR(ReadData2, clk, out2);  
      
     Extend extend(ins[15:0], ExtSel, extendData);  
       
     //ALU alu(out1, out2, extendData, insLate[11:7],ALUSrcA,ALUSrcB, ALUOp, zero, result,sign);  
     ALU alu(out1, out2, extendData,ALUSrcB, ALUOp, zero, result,sign);
     DataLate ALUout(result, clk, result1);  
       
     DataMemory datamemory(result1, out2, DataMemRW, DataOut);  
       
     DataSelect_2 dataselect_2(result, DataOut, ALUM2Reg, LateOut1);  //A(0) B(1)
      
     DataLate ALUM2DR(LateOut1, clk, LateOut2);  
       
    controlUnit control(ins[31:26], zero, clk, reset,sign,PCWre,InsMemRW, IRWre, WrRegData, RegWre/*, ALUSrcA*/,ALUSrcB, ALUM2Reg, DataMemRW, ExtSel, RegOut, PCSrc, ALUOp, state_out);  
    inslate IR(ins[31:0], clk, insLate);
    AluResult aluOut(result, clk, aluResult);  
endmodule  