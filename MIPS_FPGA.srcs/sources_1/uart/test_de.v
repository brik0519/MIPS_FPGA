`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/07 22:09:23
// Design Name: 
// Module Name: test_de
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


module test_de(
    input clk,           // 시스템 클럭
    input rst,           // 리셋 신호
    input din,
    input RxD,           // UART 수신 신호
    output TxD,           // UART 송신 신호
    output man_clk,
    output error,
    output dout
    );
assign dout = din;
assign man_clk = 1'b0;
assign TxD = 1'b0;
debounce    U0 (
 .clk(clk),
 .rstn(!rst),
 .din(din),
 .tick(),
 .toggle(error));
endmodule
