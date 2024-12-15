`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/29 21:53:04
// Design Name: 
// Module Name: EX_MEM_Register
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


module EX_MEM_Register(
    /*  Input   */
    // Datapath
    input wire clk, reset,
    input wire [31:0] Branch_Add_Result, ALU_Result, EX_PC, 
    input wire [31:0] EX_Read_Data_2,
    input wire [4:0] Reg_Destination,
    input wire Zero,

    // Controll Signal
    input wire EX_MemWrite, EX_MemRead,
    input wire EX_MemtoReg, EX_RegWrite, 
    input wire EX_Beq, EX_Bne, EX_Jr, EX_Jal,


    /*  Output  */
    // Datapath
    output reg [31:0] MEM_Branch_Add_Result, MEM_ALUResult, MEM_PC,
    output reg [31:0] MEM_Read_Data_2,
    output reg [4:0] MEM_Reg_Destination,
    output reg MEM_Zero,

    // Controll Signal
    output reg MEM_MemWrite, MEM_MemRead,
    output reg MEM_MemtoReg, MEM_RegWrite, 
    output reg MEM_Beq, MEM_Bne, MEM_Jal, MEM_Jr
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Datapath
            MEM_PC <= 32'b0;
            MEM_Branch_Add_Result   <= 32'b0;
            MEM_ALUResult           <= 32'b0;
            MEM_Read_Data_2         <= 32'b0;
            MEM_Reg_Destination     <= 5'b0;
            MEM_Zero <=  1'b0;

            // Controll Signal
            MEM_MemWrite <= 1'b0;
            MEM_MemRead  <= 1'b0;
            MEM_MemtoReg <= 1'b0;
            MEM_RegWrite <= 1'b0;
            
            MEM_Beq   <= 1'b0;
            MEM_Bne   <= 1'b0;
            MEM_Jal <= 1'b0;
            MEM_Jr    <= 1'b0;
        end

        else begin
            // Datapath
            MEM_PC <= EX_PC;
            MEM_Branch_Add_Result       <= Branch_Add_Result;
            MEM_ALUResult               <= ALU_Result;
            MEM_Read_Data_2             <= EX_Read_Data_2;
            MEM_Reg_Destination         <= Reg_Destination;
            MEM_Zero                    <= Zero;

            // Controll Signal
            MEM_MemWrite <= EX_MemWrite;
            MEM_MemRead  <= EX_MemRead;
            MEM_MemtoReg <= EX_MemtoReg;
            MEM_RegWrite <= EX_RegWrite;
            
            MEM_Beq   <= EX_Beq;
            MEM_Bne   <= EX_Bne;
            
            MEM_Jal <= EX_Jal;
            MEM_Jr  <= EX_Jr;
        end

    end


endmodule