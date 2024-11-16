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


module Registers_Unit (
    input wire clk, reset,
    input wire RegWrite,
    
    input wire [4:0] read_register_1, read_register_2,
    input wire [4:0] write_register,
    
    output reg [31:0] read_data_1, read_data_2,
    input wire [31:0] write_data
);

    reg [31:0] register [0:31];
    

    
    integer i;
    always @(negedge clk) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                register[i] <= 32'b0;
        end
        
        else if ( RegWrite )
            register[write_register] <= write_data;
    end
    
    always @(*) begin
        read_data_1 = register[read_register_1];
        read_data_2 = register[read_register_2];
    end
    
endmodule
