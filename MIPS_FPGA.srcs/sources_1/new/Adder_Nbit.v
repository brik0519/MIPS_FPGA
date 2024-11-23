`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/23 12:19:03
// Design Name: 
// Module Name: Adder_Nbit
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


module Adder_Nbit #(parameter N = 0)(
    input wire [N:0] A, B,
    // input wire cin,
    output wire cout,
    output wire [N:0] Y
);  
    
 assign {cout, Y} = A + B;
 
endmodule
