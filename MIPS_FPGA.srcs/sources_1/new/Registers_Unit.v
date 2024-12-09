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
    input wire [31:0] write_data,
    
    output reg [31:0] read_data_1, read_data_2,
    
    output reg [31:0] 
        reg0,  reg1,  reg2,  reg3,  
        reg4,  reg5,  reg6,  reg7,  
        reg8,  reg9,  reg10, reg11, 
        reg12, reg13, reg14, reg15,
        reg16, reg17, reg18, reg19, 
        reg20, reg21, reg22, reg23,
        reg24, reg25, reg26, reg27, 
        reg28, reg29, reg30, reg31
);

    reg [31:0] register [0:31];
    
    integer i;
    always @(negedge clk) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                register[i] <= 32'b0;
        end
        
        else if ( RegWrite & write_register )
            register[write_register] <= write_data;
    end
    
    always @(*) begin
        read_data_1 = register[read_register_1];
        read_data_2 = register[read_register_2];
        
        
        reg0 <= register[0]; 
        reg1 <= register[1]; 
        reg2 <= register[2]; 
        reg3 <= register[3]; 
        
        reg4 <= register[4]; 
        reg5 <= register[5]; 
        reg6 <= register[6]; 
        reg7 <= register[7]; 
        
        reg8 <= register[8]; 
        reg9 <= register[9]; 
        reg10 <= register[10]; 
        reg11 <= register[11]; 
        
        reg12 <= register[12]; 
        reg13 <= register[13]; 
        reg14 <= register[14]; 
        reg15 <= register[15]; 
        
        reg16 <= register[16]; 
        reg17 <= register[17]; 
        reg18 <= register[18]; 
        reg19 <= register[19]; 
        
        reg20 <= register[20]; 
        reg21 <= register[21]; 
        reg22 <= register[22]; 
        reg23 <= register[23]; 
        
        reg24 <= register[24]; 
        reg25 <= register[25]; 
        reg26 <= register[26]; 
        reg27 <= register[27]; 
        
        reg28 <= register[28]; 
        reg29 <= register[29]; 
        reg30 <= register[30]; 
        reg31 <= register[31]; 
    end
    
endmodule
