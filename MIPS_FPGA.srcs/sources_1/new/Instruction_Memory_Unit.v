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
    
    integer i;
    reg [31:0] Init_Inst;
     always @(posedge clk) begin
        Init_Inst = {6'b111111, 26'd0};
        
        if (reset) begin
            for (i = 0; i < 32'd2044; i = i + 4) begin
                case (i)
                    0   : Init_Inst = {6'b111111, 26'd0};  // Program Start
                    4   : Init_Inst = 32'h2108_000A;  // ADDI $t0, $t0, 10;
                    16  : Init_Inst = 32'h0100_8014;  // ADD $s0, $t0, $zero;
//                    26  : Init_Inst = 32'h2104_000A;  // ADD $s0, $t0, $zero;    
//                    20  : Init_Inst = 32'h0800_0000;  // J 0;
                    default: Init_Inst = {6'b111111, 26'd0};
                endcase
                {memory[i], memory[i+1], memory[i+2], memory[i+3]} <= Init_Inst;
            end
        end
    
        else begin
            if ( MemWrite )
                memory[address] <= write_data;
            else
                memory[address] <= 32'b0;
            if ( MemRead )
                read_data <= {
                    memory[address], memory[address+1], memory[address+2], memory[address+3]
                };
        end              
    end
    
endmodule