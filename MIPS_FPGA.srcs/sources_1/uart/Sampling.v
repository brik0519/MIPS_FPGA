`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/07 20:49:09
// Design Name: 
// Module Name: Sampling
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


module Sampling(
    input wire din, clk, sample_clk, rstn,
    output wire Q
);

    wire sampled;
    Dflipflop   U1(.Q(sampled), .D(din), .en(sample_clk), .clk(clk), .rstn(rstn));
    Dflipflop   U2(.Q(Q), .D(sampled), .en(1'b1), .clk(clk), .rstn(rstn));
    
endmodule
