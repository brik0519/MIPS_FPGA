`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/16 20:16:23
// Design Name: 
// Module Name: Program_Counter
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

module Program_Counter (
    input wire clk, reset, PCWrite,
    input wire [31:0] PC_Write_Data,
    output reg [31:0] PC_Current
);

    always @ (posedge clk, posedge reset) begin
        if (reset)
            PC_Current <= 0;
        else if (PCWrite)
            PC_Current <= PC_Write_Data;      
    end

endmodule

