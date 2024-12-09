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

module Control_Unit(
    input wire reset,
    
    input wire [31:0] Instruction,
    input wire [5:0]  opcode,
    
    output reg [1:0]  ALUOp,
    output reg ALUSrc, MemRead, RegDst, MemWrite, MemtoReg, RegWrite, Beq, Jump, Bne, Jal
);

localparam lw       = 6'b100011;
localparam sw       = 6'b101011;
localparam beq      = 6'b000100;
localparam bne      = 6'b000101;
localparam jump     = 6'b000010;
localparam jal      = 6'b000011;
localparam addi     = 6'b001000;
localparam subi     = 6'b001010;
localparam slti     = 6'b001010;
localparam R_type   = 6'b000000;


always @ (*) begin
    ALUSrc = 1'b0;
    RegDst = 1'b0;
    ALUOp = 2'b00;
    MemRead = 1'b0;
    MemWrite = 1'b0;
    MemtoReg = 1'b0;
    RegWrite = 1'b0;
    Beq = 1'b0;
    Bne = 1'b0;
    Jump = 1'b0;
    Jal = 1'b0;
    if(!reset)begin // Reset or All Instruction bits are 0
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
                 Beq = 1'b1;
                 MemtoReg = 1'b1;
                 end
        bne     :begin
                 ALUOp = 2'b01;
                 Bne = 1'b1;
                 MemtoReg = 1'b1;
                 end
        addi    :begin
                 ALUSrc = 1'b1;
                 ALUOp = 2'b10;
                 RegWrite = 1'b1;
                 MemtoReg = 1'b1;
                 end
        subi    :begin
                 ALUSrc = 1'b1;
                 ALUOp = 2'b01;
                 RegWrite = 1'b1;
                 MemtoReg = 1'b1;
                 end
        slti    :begin
                 ALUSrc = 1'b1;
                 ALUOp = 2'b11;
                 RegWrite = 1'b1;
                 MemtoReg = 1'b1;
                 end
        R_type  :begin
                 ALUOp = 2'b10;
                 RegDst = 1'b1;
                 RegWrite = 1'b1;
                 MemtoReg = 1'b1;
                 end
        jump    :begin
                 Jump = 1'b1;
                 end
        jal     :begin
                 Jump = 1'b1;
                 RegWrite = 1'b1;
                 RegDst = 1'b0;
                 Jal = 1'b1;
                 end
        default :begin
                 ALUSrc = 1'b0;
                 RegDst = 1'b0;
                 ALUOp = 2'b00;
                 MemRead = 1'b0;
                 MemWrite = 1'b0;
                 MemtoReg = 1'b0;
                 RegWrite = 1'b0;
                 Beq = 1'b0;
                 Bne = 1'b0;
                 Jump = 1'b0;
                 Jal = 1'b0;
                 end
        endcase
    end
end


    
endmodule