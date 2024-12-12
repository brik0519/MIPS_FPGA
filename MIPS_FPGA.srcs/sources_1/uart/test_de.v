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
    input clk,           // �ý��� Ŭ��
    input rst,           // ���� ��ȣ
    input din,
    input RxD,           // UART ���� ��ȣ
    output TxD,           // UART �۽� ��ȣ
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
