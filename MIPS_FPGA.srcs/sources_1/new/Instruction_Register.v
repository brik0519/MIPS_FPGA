`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/09 16:42:56
// Design Name: 
// Module Name: Instruction_Register
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


module Instruction_Register(
    input wire clk, reset, IRWrite,
    input wire [31:0] Instruction, 
    
    output wire [5:0] op,
    output wire [4:0] rs, wire [4:0] rt, wire [4:0] rd,
    output wire [15:0] imm16
);
    
    reg [31:0] Fetched_Instruction;
    always @(negedge clk) begin
        if (reset) 
            Fetched_Instruction <= 32'd0;
        else if (IRWrite) 
            Fetched_Instruction <=  Instruction;
    end
    
    assign op = Fetched_Instruction[31:26];
    assign rs = Fetched_Instruction[25:21];    
    assign rt = Fetched_Instruction[20:16];
    assign rd = Fetched_Instruction[15:11];
    
    assign imm16 = Fetched_Instruction[15:0];
    


endmodule
