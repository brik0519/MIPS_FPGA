`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/09 00:41:46
// Design Name: 
// Module Name: Debounce
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


module Debounce (
        input wire clk, en, rstn, BTN,
        output wire debounced
    );
    
    wire Q0,Q1;
    
    dff U0 ( .clk(clk), .en(en), .D(BTN), .rstn(rstn), .Q(Q0) );
    dff U1 ( .clk(clk), .en(en), .D(Q0),  .rstn(rstn), .Q(Q1)  );
    
    assign debounced = Q0 & ~Q1;
    
    
endmodule
