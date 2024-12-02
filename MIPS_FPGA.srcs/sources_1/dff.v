`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/08 22:45:15
// Design Name: 
// Module Name: Diff
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


module dff(
    input wire clk, rstn, en, D,
    output reg Q 
);

always @( posedge clk )
    if (rstn)
        Q <= 0;
    else if (en)
        Q <= D;

endmodule
