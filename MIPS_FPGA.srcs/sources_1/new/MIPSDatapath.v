`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/09 10:31:52
// Design Name: 
// Module Name: MIPSDatapath
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


module MIPSDatapath(
input [1:0] ALUSrcB
    );
wire [31:0] SEOut, B, aluO;
wire [3:0] aluctrl;
SignExtention   U0 (.In(), .Out(SEOut));
MUX4to1         U1 (.In0(), .In1(32'd4), .In2(SEOut), .In3(SEOut<<2), .sel(ALUSrcB), .Out(MOB));
ALU             U2 (.dataA(), .dataB(MOB), .aluctrl(aluctrl), .aluresult(aluO), .zero());
ALUOut          U3 (.In(aluO), .clk(), .Out());
ALUControl      U4 (.ALUop(), .funct(), .ALUctrl(aluctrl));
    
endmodule
