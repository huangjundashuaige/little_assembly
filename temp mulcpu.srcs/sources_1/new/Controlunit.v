`timescale 1ns / 1ps  
  
  //100111 SLTI
  //110101 bne
  ///110110 bgtz
  ///
  
  //controlUnit control(ins[31:26], zero, clk, reset,sign,PCWre,InsMemRW, IRWre,
  // WrRegData, RegWre/*, ALUSrcA*/,ALUSrcB, ALUM2Reg, DataMemRW, ExtSel, RegOut, PCSrc, ALUOp, state_out);  
module controlUnit(input [5:0] opcode,   
                   input zero, clk, Reset,
                   input sign,  
                   output reg PCWre, InsMemRW, IRWre, WrRegData, RegWre, /*ALUSrcA,*/ALUSrcB, ALUM2Reg, DataMemRW,  
                   output reg [1:0] ExtSel, RegOut, PCSrc,  
                         output reg [2:0] ALUOp, state_out
                         );  
    parameter [2:0] sif = 3'b000,   // IF state  
                     sid = 3'b001,   // ID state  
                     exe3 = 3'b010,  // sw、lw  
                     smem = 3'b011,  // MEM state
                     wb2 = 3'b100,   // lw                                             
                     exe1 = 3'b110,  // add、sub、addi、or、and、ori、move、slt、sll、slti 
                     exe2 = 3'b101,  // beq、  
                     wb1 = 3'b111;   // add、sub、addl、or、and、ori、move、slt、sll、slti   
                            
     parameter [5:0] addi = 6'b000010,  
                    ori = 6'b010010,  
                    sll = 6'b011000,   
                    add = 6'b000000,  
                    sub = 6'b000001,  
                    move = 6'b100000,  
                    slt = 6'b100111, 
                    slti =6'b100110,
                    sw = 6'b110000,  
                    lw = 6'b110001,  
                    beq = 6'b110100,  
                    bne =6'b110101, 
                    bgtz=6'b110110,
                    j = 6'b111000,  
                    jr = 6'b111001,  
                    Or = 6'b010000,  
                    And = 6'b010001,  
                    jal = 6'b111010,  
                    halt = 6'b111111;  
                                   
     reg [2:0] state, next_state;  
      
    initial begin  
        PCWre = 1;  
        InsMemRW = 0;  
        IRWre = 0;  
        WrRegData = 0;  
        RegWre = 0;
        //ALUSrcA = 0;  
        ALUSrcB = 0;  
        ALUM2Reg = 0;  
        DataMemRW = 0;  
        ExtSel = 2'b11;  
        RegOut = 2'b11;  
        PCSrc = 2'b00;  
        ALUOp = 0;  
        state = sif;  
        state_out = state;  
    end  
      
    always @(posedge clk) begin  
         if (Reset == 0) begin  
              state <= sif;  
          end else begin  
              state <= next_state;  
          end  
          state_out = state;  
     end  
      
    always @(state or opcode) begin  
            if (opcode == lw) ALUM2Reg = 1;
            if (opcode == jal) RegOut = 2'b00;
            if (state == wb1 || state == wb2 || opcode == jal) RegWre = 1;  
    else if (opcode == addi || opcode == ori || opcode == lw||opcode == slti) RegOut = 2'b01;  
    else RegOut = 2'b10;
    //以下是状态改变的方式
    case(state)                
        sif: next_state = sid; //  if   id    
         sid: begin  
         
             case (opcode[5:3])  
                  3'b111: next_state = sif; // j, jal, jr, halt等指令  
               3'b110: begin  
                   if (opcode == 6'b110100) next_state = exe2; // beq指令 bne bgtz
                   else next_state = exe3; // sw, lw指令  
               end  
               default: next_state = exe1; // add, sub, slt, sll等指令  slti
           endcase  
         end  
       exe1: next_state = wb1;  
       exe2: next_state = sif;  
       exe3: next_state = smem;  
       smem: begin  
             if (opcode == 6'b110001) next_state = wb2; // lw指令  
                else next_state = sif; // sw指令  
       end  
       wb1: next_state = sif;  
       wb2: next_state = sif;  
       default: next_state = sif;  
    endcase  
    end  
           
    always @(state) begin       
        // 确定PCWre的值  
        if (state == sif && opcode != halt) PCWre = 1;  
        else PCWre = 0;              
        // 确定InsMemRW的值  
        InsMemRW = 1;       
            
        // 确定IRWre的值  
        if (state == sif) IRWre = 1;  //只有if状态可以读取指令
        else IRWre = 0;  
            
        // 确定WrRegData的值  
        if (state == wb1 || state == wb2) WrRegData = 1;  
        else WrRegData = 0;  
            
        // 确定RegWre的值  
        if (state == wb1 || state == wb2 || opcode == jal) RegWre = 1;  
        else RegWre = 0;  
         //if(opcode == sll) ALUSrcA = 1;
         //else ALUSrcA = 0;
          // 确定ALUSrcB的值  
        if (opcode == addi || opcode == ori || opcode == sll || opcode == sw || opcode == lw||opcode == slti) ALUSrcB = 1;  
        else ALUSrcB = 0;  
          
          // 确定DataMemRW的值  
        if (state == smem && opcode == sw) DataMemRW = 1;  
        else DataMemRW = 0;  
          
          // 确定ALUM2Reg的值  
        if (state == wb2) ALUM2Reg = 1;  //此时写寄存器的数据来源变为数据存储器
        else ALUM2Reg = 0;  
          
          // 确定ExtSel的值  
        if (opcode == ori) ExtSel = 2'b01;  
        else if (opcode == sll) ExtSel = 2'b00;  
        else ExtSel = 2'b10;      
          // 确定PCSrc的值  
        case(opcode)  
            j: PCSrc = 2'b11;  
            jal: PCSrc = 2'b11;  
            jr: PCSrc = 2'b10;  
            beq: begin  
                if (zero) PCSrc = 2'b01;  
                else PCSrc = 2'b00;  
            end  
            bne: begin  
                 if (zero) PCSrc = 2'b00;  
                 else PCSrc = 2'b01;  
           end  
              bgtz: begin  
                if (zero==0&&sign==0) PCSrc = 2'b01;  
                else PCSrc = 2'b00;  
          end  
            default: PCSrc = 2'b00;  
        endcase  
          
          // 确定ALUOp的值  
        case(opcode)  
            sub: ALUOp = 3'b001;  
            Or:  ALUOp = 3'b101;  
            And: ALUOp = 3'b110;  
            ori: ALUOp = 3'b101;  
            slt: ALUOp = 3'b010;  
            sll: ALUOp = 3'b100; 
            slti:ALUOp = 3'b010;
            beq: ALUOp = 3'b001;
            bne: ALUOp = 3'b001;   
            bgtz:ALUOp = 3'b001;
            default: ALUOp = 3'b000;  
        endcase           
          // 防止在IF阶段写数据  
        if (state == sif) begin  
            RegWre = 0;  
            DataMemRW = 0;  
        end  
    end  
      
       
endmodule  