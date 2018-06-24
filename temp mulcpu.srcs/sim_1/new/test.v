 module test;
             reg reset;
             reg clk;
             wire [2:0] state_out;
             wire [5:0] opcode;
             wire [4:0] rs, rt, rd;
                        // output ins[31:26], ins[25:21], ins[20:16], ins[15:11],  
             wire [31:0] ins, ReadData1, ReadData2, pc0, aluResult;
            
          
        MCPU uut(
            .clk(clk),
            .reset(reset),
            .state_out(state_out),
            .opcode(opcode),
            .rs(rs),
            .rt(rt),
            .rd(rd),
            .ins(ins),
            .ReadData1(ReadData1),
            .ReadData2(ReadData2),
            .pc0(pc0),
            .aluResult(aluResult)
        );
             //Wait 100 ns for global reset to finish
    always #50 clk = !clk;
             initial begin
                 clk = 0;
                 reset = 0;
                 #100 reset = 1;
                 end
 endmodule