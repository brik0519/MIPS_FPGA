`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/02 12:24:01
// Design Name: 
// Module Name: Data_Memory_Module
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


module Instruction_Memory_Unit(
    input wire clk,
    input wire [31:0] address,
    output wire [31:0] read_data
);  
    reg [7:0] memory [0:2047];
    
    integer i;
    reg [31:0] Init_Inst;
     always @(*) begin
        Init_Inst = {6'b111111, 26'd0};
                case (address)
                    0   : Init_Inst = {6'b111111, 26'd0};      // Program Start
                    4   : Init_Inst = 32'h2010_0003;           // ADDI $s0 $0 3
                    //8 : NOP
                    //12: NOP
                    //16: NOP
                    20  : Init_Inst = 32'h0010_2020;           // ADD $a0 $0 $s0
//                    24  : Init_Inst = 32'h2005_0002;           // ADDI $a1 $0 2
//                    28  : Init_Inst = 32'h0C00_0014;           // JAL 80
//                    /* Loop Point */
                    
//                    80  : Init_Inst = 32'h0080_4020;           // ADD $t0 $a0 $0 
//                    //84
//                    //88
//                    //92
//                    96  : Init_Inst = 32'h2908_0005;           // SLTI $t0 $t0 5 
//                    //100
//                    //104
//                    108  : Init_Inst = 32'h214A_0003;           // ADDI $t2 $t2 3
//                    112  : Init_Inst = 32'h1120_0015;           // BEQ $t1 $0 9  
//                    //104
//                    //104
//                    //108
//                    //112
//                    //192
//                    200  : Init_Inst = 32'h03E0_0008;           // JR
                                                                                                    //32: NOP   
                    default: Init_Inst = {6'b111111, 26'd0};
                endcase
    end
    assign read_data = Init_Inst;
    
endmodule