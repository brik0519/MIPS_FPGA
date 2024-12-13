`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/07 13:14:01
// Design Name: 
// Module Name: Tflipflop
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


module Dflipflop(
    output reg Q,
    input wire D, en, clk, rstn
);

always@(posedge clk or negedge  rstn)
    if(!rstn) Q <= 1'b0;
    else if(en) Q <= D;

endmodule
