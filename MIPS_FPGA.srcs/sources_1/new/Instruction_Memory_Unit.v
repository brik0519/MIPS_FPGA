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
    input wire clk, reset,
    input wire MemRead, MemWrite,
    input wire [31:0] address, write_data,
    output reg [31:0] read_data
);  
    reg [7:0] memory [0:2047];
//    reg [31:0] memory [0:511];
    reg [31:0] Init_Inst = 32'd0;
    integer i;
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 32'd2044; i = i + 4) begin
                case (i)
                    0   : Init_Inst = 32'd0;          // Program Start
//                    4   : Init_Inst = 32'h0108_0020;  // ADD $s0, $t0, $zero;
                    4   : Init_Inst = 32'h2108_000A;  // ADDI $t0, $t0, 10;
//                    8   : Init_Inst = 32'h0000_0000;  // NOP
//                    12  : Init_Inst = 32'h0000_0000;  // NOP
//                    16  : Init_Inst = 32'h0108_0020;  // ADD $s0, $t0, $zero;    
//                    20  : Init_Inst = 32'h0800_0000;  // J 0;
                    default: Init_Inst = 32'd0;
                endcase
                {memory[i], memory[i+1], memory[i+2], memory[i+3]} <= Init_Inst;
            end
        end
    
        else begin
            if ( MemWrite )
                memory[address] <= write_data;
            if ( MemRead )
                read_data <= {
                    memory[address], memory[address+1], memory[address+2], memory[address+3]
                };
        end              
    end
    
endmodule
