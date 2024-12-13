`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/10 10:55:19
// Design Name: 
// Module Name: clkDivider
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


module clkdiv(
input wire rstn, clk,
output wire clk_1000hz, clk_100hz, clk_10hz, clk_1hz
    );
    
 wire tc0, tc1, tc2, tc3, tc4, tc5, tc6, tc7;

BSDcnt_cas  U1(.inc('b1), .rstn(rstn), .clk(clk), .TC(tc0));
BSDcnt_cas  U2(.inc(tc0), .rstn(rstn), .clk(clk), .TC(tc1)); 
BSDcnt_cas  U3(.inc(tc1), .rstn(rstn), .clk(clk), .TC(tc2)); 
BSDcnt_cas  U4(.inc(tc2), .rstn(rstn), .clk(clk), .TC(tc3)); 
BSDcnt_cas  U5(.inc(tc3), .rstn(rstn), .clk(clk), .TC(tc4));
BSDcnt_cas  U6(.inc(tc4), .rstn(rstn), .clk(clk), .TC(tc5)); 
BSDcnt_cas  U7(.inc(tc5), .rstn(rstn), .clk(clk), .TC(tc6)); 
BSDcnt_cas  U8(.inc(tc6), .rstn(rstn), .clk(clk), .TC(tc7)); 

assign clk_10hz = tc6;
assign clk_100hz = tc5;
assign clk_1000hz = tc4;
assign clk_1hz = tc7;

endmodule
