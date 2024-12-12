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


module Tflipflop(
    output reg Q,
    input wire T, en, clk, rstn
);

    always@(posedge clk)
        if(!rstn) Q <= 1'b0;
        else if(en)
            if(T) Q <= ~Q;

endmodule
