`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/02 12:24:01
// Design Name: 
// Module Name: Data_Memory_Module
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


module Memory_Unit(
    input wire clk,
    input wire MemRead,
    input wire MemWrite,
    input wire [31:0] address,
    input wire [31:0] write_data,
    output reg [31:0] read_data
);

    reg [31:0] memory [0:4095];
    
    always @(negedge clk) begin
        if ( MemWrite )
            memory[address] <= write_data;
        if ( MemRead )
            read_data <= memory[address];      
    end
    
    
    initial begin
        
    
    
    end
    
endmodule
