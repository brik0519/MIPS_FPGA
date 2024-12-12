`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/30 16:42:35
// Design Name: 
// Module Name: top
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


module top(
input wire clk, rst,
input wire RxD,
output wire TxD
    );

wire data_new;
wire [7:0] data;
    
UART_top    UART(
    .clk(clk),
    .rst(rst),
    .datain_ext(data), // TxD�� ���� �۽� �� Data
    .dataout_ext(data), // RxD�� ���� ���ŵ� Data
    .new_in(data_new), // UART�� ���ο� data�� ����
    .new_out(data_new), // UART�� ���� ���ο� �����Ͱ� ����
    //.error,
    .RxD(RxD),
    .TxD(TxD)
    );
    
    
endmodule
