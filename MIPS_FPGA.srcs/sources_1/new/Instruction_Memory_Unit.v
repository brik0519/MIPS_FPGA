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
        Init_Inst = 32'b0;//{6'b111111, 26'd0};
                case (address)
                    0    : Init_Inst = 32'b0;//{6'b111111, 26'd0};      // Program Start
                    4    : Init_Inst = 32'h2010_0003;           // ADDI $s0 $0 3
                    20   : Init_Inst = 32'h0010_2020;
                    24   : Init_Inst = 32'h2005_0002; 
                    28   : Init_Inst = 32'h0C00_0014; 
                    44   : Init_Inst = 32'h8C08_0000;
                    60   : Init_Inst = 32'h2509_0001;
                    64   : Init_Inst = 32'h3C0A_0007;
                    68   : Init_Inst = 32'h0800_0032;
                    80   : Init_Inst = 32'h0080_4020;
                    96   : Init_Inst = 32'h2949_0005;
                    112  : Init_Inst = 32'h1120_0016;
                    132  : Init_Inst = 32'h0145_5822;
                    148  : Init_Inst = 32'h0144_482A;  
                    152  : Init_Inst = 32'h1520_0007; 
                    168  : Init_Inst = 32'h0008_5A00; 
                    184  : Init_Inst = 32'hAD0B_0000; 
                    188  : Init_Inst = 32'h2140_0001; 
                    192  : Init_Inst = 32'h03E0_0009; 
                    200  : Init_Inst = 32'h0800_0032; 
                                                                                                    //32: NOP   
                    default: Init_Inst = 32'b0;//{6'b111111, 26'd0};
                endcase
    end
    assign read_data = Init_Inst;
    
endmodule