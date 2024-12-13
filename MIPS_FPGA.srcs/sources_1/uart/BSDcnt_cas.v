`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/23 10:14:09
// Design Name: 
// Module Name: BSDcnt_cas
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


module BSDcnt_cas(
input inc, rstn, clk,
output TC,
output [3:0] Q
    );
reg [3:0] Q;
wire fin;

always @(posedge clk)
    if(!rstn) Q<=4'd0;
    else if(inc)
        if(fin) Q<=4'd0;
        else Q<=Q+1;
assign fin = (Q == 4'd9)?1:0;
assign TC = fin & inc;
endmodule
