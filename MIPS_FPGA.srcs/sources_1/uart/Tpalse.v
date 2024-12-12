`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/07 20:51:56
// Design Name: 
// Module Name: Tpalse
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


module Tpalse(
    input wire clk, rstn, inPl,
    output wire QP
);

    wire DQ;
    Dflipflop   U0 (.Q(DQ), .en(1'b1), .clk(clk), .rstn(rstn), .D(inPl));
    assign QP = inPl&!DQ;
        
endmodule
