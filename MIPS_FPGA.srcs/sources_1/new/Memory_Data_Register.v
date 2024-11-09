`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/08 00:25:59
// Design Name: 
// Module Name: Memory_Data_Register
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


module Binary_32bit_Register (
    input wire clk,
    input wire [31:0] write_data,
    output reg [31:0] read_data
);

    always @ (negedge clk)
        read_data <= write_data;

endmodule
