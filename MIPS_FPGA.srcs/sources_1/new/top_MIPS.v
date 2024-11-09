`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/09 15:43:06
// Design Name: 
// Module Name: top_MIPS
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


module top_MIPS();
    reg clk, reset;
    
    wire PC_data, PC_current;
    Binary_32bit_Register PC (.clk(clk), .write_data(PC_data), .read_data(PC_current));

    wire Registers_Read_Data1, Registers_Read_Data2;
    wire Reg_A_out, Reg_B_out;
    
    Binary_32bit_Register A (.clk(clk), .write_data(Registers_Read_Data1), .read_data(Reg_A_out));
    Binary_32bit_Register B (.clk(clk), .write_data(Registers_Read_Data2), .read_data(Reg_B_out));
    
    Binary_32bit_Register Memory_Data_Register (.clk(clk), .write_data(PC_data), .read_data(PC_current));



endmodule
