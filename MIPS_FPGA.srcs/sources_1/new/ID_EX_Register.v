`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/25 10:04:36
// Design Name: 
// Module Name: ID_EX_Register
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


module ID_EX_Register(
    input wire clk, reset,    
    input wire ID_EX_Write,
    
    // Control Signal
    input wire [1:0] ALUOp,
    input wire ALUSrc, RegDst, MemRead, MemWrite,
    input wire MemtoReg, RegWrite, Brench,
    
    // ID side Data
    input wire [31:0] ID_read_data1, ID_read_data2,
    input wire [31:0] ID_extended_imm_16,
    input wire [4:0]  ID_rt, ID_rd,
    input wire [5:0]  fn,
    
    
    
    output reg [31:0] EX_read_data1, EX_read_data2, 
    output reg [31:0] EX_extended_imm_16,
    output reg [4:0]  EX_rt, EX_rd,
    
    output reg [1:0] EX_ALUOp,
    
    output reg EX_ALUSrc, EX_RegDst, EX_MemRead, EX_MemWrite,
    output reg EX_MemtoReg, EX_RegWrite, EX_Brench,
    
    output reg [5:0] ALUcontrol_fn // Function code
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            EX_read_data1 <= 32'b0;
            EX_read_data2 <= 32'b0;
            EX_extended_imm_16 <= 32'b0;
            
            EX_rt <= 5'b0;
            EX_rd <= 5'b0;
            
            EX_ALUSrc   <= 1'b0; 
            EX_RegDst   <= 1'b0; 
            EX_MemRead  <= 1'b0; 
            EX_MemWrite <= 1'b0;
            EX_MemtoReg <= 1'b0; 
            EX_RegWrite <= 1'b0; 
            EX_Brench   <= 1'b0;
            
            ALUcontrol_fn <= 6'b0;
        end
            
        else if (ID_EX_Write) begin
            EX_read_data1 <= ID_read_data1;
            EX_read_data2 <= ID_read_data2;
            EX_extended_imm_16 <= ID_extended_imm_16;
            
            EX_rt <= 5'b0;
            EX_rd <= 5'b0;
            
            EX_ALUSrc   <= 1'b0; 
            EX_RegDst   <= 1'b0; 
            EX_MemRead  <= 1'b0; 
            EX_MemWrite <= 1'b0;
            EX_MemtoReg <= 1'b0; 
            EX_RegWrite <= 1'b0; 
            EX_Brench   <= 1'b0;
            
            ALUcontrol_fn <= 6'b0;
        end
    end


endmodule
