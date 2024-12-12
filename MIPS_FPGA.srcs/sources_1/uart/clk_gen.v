`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/07 17:06:05
// Design Name: 
// Module Name: clk_gen
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


module clk_gen(
 input wire clk_100MHz,
 input wire rst,
 output reg clk_low
 );
 integer cnt;

 always @(posedge clk_100MHz, posedge rst)
    if(rst) begin
        clk_low <= 0;
        cnt <= 0;
    end
    else if (cnt < 100000) begin
        cnt <= cnt + 1;
    end
    else begin
        cnt <= 0;
        clk_low = ~clk_low;
    end
endmodule

