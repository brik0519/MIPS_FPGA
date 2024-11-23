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
    input wire reset,
    input wire MemRead,
    input wire MemWrite,
    input wire [31:0] address,
    input wire [31:0] write_data,
    output reg [31:0] read_data
);  
    reg [31:0] memory [0:511];
    
    reg [31:0] init_address;
    integer i;
    
    always @(negedge clk) begin
        if (reset) begin
            for (i = 0; i < 32'd512; i = i + 1) begin
                memory[i] <= 32'b0;
            end
        end
    
        if ( MemWrite )
            memory[address] <= write_data;
        else 
            memory[address] <= 32'b0;
            
        if ( MemRead )
            read_data <= memory[address];
        else
            read_data <= 32'b0;      
    end
    
endmodule
