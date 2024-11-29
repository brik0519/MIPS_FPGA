`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/22 21:52:33
// Design Name: 
// Module Name: IF_ID_Register
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


module IF_ID_Register(
    input wire clk, reset,
    
    input wire IF_ID_Write,
    input wire [31:0] IF_PC, IF_Instruction,
    
    output reg [31:0] ID_PC, ID_Instruction
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ID_PC <= 32'b0;
            ID_Instruction <= 32'b0;
        end
            
        else if (IF_ID_Write) begin
            ID_PC <= IF_PC;
            ID_Instruction <= IF_Instruction;
        end
    end

endmodule
