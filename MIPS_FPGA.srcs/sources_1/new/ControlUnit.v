`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/16 10:53:01
// Design Name: 
// Module Name: ControlUnit
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

localparam lw       = 6'b100011;
localparam sw       = 6'b101011;
localparam beq      = 6'b000100;
localparam addi     = 6'b001000;
localparam R_type   = 6'b000000;

module Control_Unit(
    input wire rst, brancheq, 
    input wire [5:0] opcode,
    output reg [1:0] ALUOp,
    output reg ALUSrc, RegDst, MemRead, MemWrite, MemtoReg, RegWrite, Branch
);

always @ (*) begin
    ALUSrc = 1'b0;
    RegDst = 1'b0;
    ALUOp = 2'b00;
    MemRead = 1'b0;
    MemWrite = 1'b0;
    MemtoReg = 1'b0;
    RegWrite = 1'b0;
    Branch = 1'b0;
    if(!rst)begin
        case(opcode)
        lw      :begin
                 ALUSrc = 1'b1;
                 MemRead = 1'b1;
                 RegWrite = 1'b1;
                 MemtoReg = 1'b1;
                 end
        sw      :begin
                 ALUSrc = 1'b1;
                 MemWrite = 1'b1;
                 end
        beq     :begin
                 ALUOp = 2'b01;
                 Branch = brancheq;
                 MemtoReg = 1'b1;
                 end
        addi    :begin
                 ALUSrc = 1'b1;
                 ALUOp = 2'b10;
                 RegWrite = 1'b1;
                 MemtoReg = 1'b1;
                 end
        R_type  :begin
                 ALUOp = 2'b10;
                 RegDst = 1'b1;
                 RegWrite = 1'b1;
                 MemtoReg = 1'b1;
                 end
        default :begin
                 ALUSrc = 1'b0;
                 RegDst = 1'b0;
                 ALUOp = 2'b00;
                 MemRead = 1'b0;
                 MemWrite = 1'b0;
                 MemtoReg = 1'b0;
                 RegWrite = 1'b0;
                 Branch = 1'b0;
                 end
        endcase
    end
end


    
endmodule
