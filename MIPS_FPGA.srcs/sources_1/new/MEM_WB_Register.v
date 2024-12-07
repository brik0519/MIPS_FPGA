`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/30 18:47:23
// Design Name: 
// Module Name: MEM_WB_Register
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


module MEM_WB_Register(
    input wire clk, reset, 
    input wire MEM_WB_Write,
    
    /*  Input   */
    // Datapath
    input wire [31:0] MEM_PC, MEM_Read_Data, MEM_ALU_Result,
    input wire [4:0] MEM_Reg_Destination,
    
    // Control Signal
    input wire MEM_MemWrite, MEM_MemRead, MEM_RegWrite,
    
    
    /*  Output  */
    // Datapath
    output reg [31:0] WB_PC, WB_Read_Data, WB_ALU_Result,
    output reg [4:0] WB_Reg_Destination,
    
    //Control Signal
    output reg WB_MemWrite, WB_MemRead, WB_RegWrite
);
    
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            // Datapath
            WB_PC         <= 32'b0;
            WB_Read_Data  <= 32'b0;
            WB_ALU_Result <= 32'b0;
            
            // Control Signal
            WB_MemWrite <= 1'b0;
            WB_MemRead  <= 1'b0;
            WB_RegWrite <= 1'b0;
        end
    
        else begin
            WB_PC         <= MEM_PC;
            WB_Read_Data  <= MEM_Read_Data;
            WB_ALU_Result <= MEM_ALU_Result;
            
            WB_MemWrite <= MEM_MemWrite;
            WB_MemRead  <= MEM_MemRead;
            WB_RegWrite <= MEM_RegWrite;
            
            WB_Reg_Destination <= MEM_Reg_Destination;
        end

    end    
    
    
endmodule
