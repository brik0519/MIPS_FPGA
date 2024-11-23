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


module Instruction_Memory_Unit(
    input wire clk, reset,
    input wire MemRead, MemWrite,
    input wire [31:0] address, write_data,
    output reg [31:0] read_data
);  

    reg [31:0] memory [0:511];
    
    integer i;
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 32'd512; i = i + 1) begin
                if (i == 0)
                    memory[i] = 32'h2108_000A;  // ADDI $t0, $t0, 10; 
                else if (i == 1)
                    memory[i] = 32'h0108_0020;  // ADD $s0, $t0, $zero;

                else memory[i] <= 32'b0;
            end
        end
    
        else begin
            if ( MemWrite )
                memory[address] <= write_data;
            if ( MemRead )
                read_data <= memory[address];
        end              
    end
    
endmodule
