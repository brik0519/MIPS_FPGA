`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/09 15:49:07
// Design Name: 
// Module Name: tb_top_MIPS
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


module tb_top_MIPS();
    reg clk, reset;
    always #1 clk = ~clk;
    
    reg [31:0] Program
    
    
    
    always @(posedge clk) begin
        MemWrite = 1;
        write_data = init_data;
        
        if (address < 32'hFFFFFFFF) begin
            address <= address + 1;
            init_data <= init_data + 1;
        end
        $display ("Value = %d", address);
    end
    
    initial begin
        clk = 1; 
        address = 32'b0; init_data = 32'b0;
    end
endmodule
