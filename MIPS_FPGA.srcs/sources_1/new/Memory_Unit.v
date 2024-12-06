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
    // Input
    input wire clk, reset,
    input wire MemRead, MemWrite,
    input wire [31:0] address, write_data,
    
    output reg [31:0] read_data,
    
    output reg [31:0] memory0, memory1, memory2, memory3,
    output reg [31:0] memory4, memory5, memory6, memory7
);  
    reg [31:0] memory [0:31];
    
    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32'd32; i = i + 1) begin
                memory[i] <= 32'b0;
            end
        end
    
        else begin 
            if ( MemWrite )
                memory[address] <= write_data;
            else 
                memory[address] <= 32'b0;
                
            if ( MemRead )
                read_data <= memory[address];
            else
                read_data <= 32'b0;      
        end
        
        memory0 <= memory[0];
        memory1 <= memory[1];
        memory2 <= memory[2];
        memory3 <= memory[3];
        memory4 <= memory[4];
        memory5 <= memory[5];
        memory6 <= memory[6];
        memory7 <= memory[7];
    end
    
endmodule
