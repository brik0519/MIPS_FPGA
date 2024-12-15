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
        Init_Inst = 32'b0;
                case (address)
                    0   : Init_Inst = 32'b0;                   // Program Start
                    4   : Init_Inst = 32'h2010_0003;           // ADDI $s0 $0 3
                    //8 : NOP
                    //12: NOP
                    //16: NOP
                    20  : Init_Inst = 32'h0010_2020;           // ADD $a0 $0 $s0
                    24  : Init_Inst = 32'h2005_0002;           // ADDI $a1 $0 2
                    28  : Init_Inst = 32'h0C00_0014;           // JAL 80
                    //32 : NOP
                    //36: NOP
                    //40: NOP
                    
                    44  : Init_Inst = 32'h8C08_0000;           // LW $t0 0($s0)
                    //48: NOP
                    //52: NOP
                    //56: NOP
                    60  : Init_Inst = 32'h2509_0001;           // SUBI $t1 $t0 1
                    64  : Init_Inst = 32'h3C0A_0007;           // Lui $t2 7
                    68  : Init_Inst = 32'h0800_0032;           // J 200
                    
                    
                    /* Loop Point */
                    80  : Init_Inst = 32'h0080_4020;           // ADD $t0 $a0 $0 
                    //84
                    //88
                    //92
                    96  : Init_Inst = 32'h2949_0005;           // SLTI $t0 $t0 5 
                    //100
                    //104
                    112  : Init_Inst = 32'h1120_0016;           //BEQ $t1 $0 9
                    //
                    //
                    //
                    //
                    //
                    132  : Init_Inst = 32'h0145_4822;           //SUB $t2 $t0 $a1
                    //
                    //
                    //
                    148  : Init_Inst = 32'h0144_482A;           //SLT $t1 $t0 $a1
                    //152:NOP
                    //156:NOP
                    //160:NOP
                    152  : Init_Inst = 32'h1520_0007;           // ADDI $t2 $t2 3
                    //
                    //
                    //
                    168  : Init_Inst = 32'h0008_5A00;           // BEQ $t1 $0 9  
                    //104
                    //104
                    //108
                    184  : Init_Inst = 32'hAD6A_0000;
                    188  : Init_Inst = 32'h214A_0001;
                    //112
                    //192
                    204  : Init_Inst = 32'h03E0_0008;           // JR
                    208  : Init_Inst = 32'h0800_0032;
                                                                                                    //32: NOP   
                    default: Init_Inst = 32'b0;//{6'b111111, 26'd0};
                endcase
    end
    assign read_data = Init_Inst;
    
endmodule