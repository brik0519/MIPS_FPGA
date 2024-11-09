`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/03 17:25:23
// Design Name: 
// Module Name: tb_Data_Memory_Module
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


module tb_Data_Memory_Module();

    reg clk;
    reg [31:0] address, write_data;
    wire [31:0] read_data;
    reg MemRead, MemWrite;
    reg [31:0] init_data;
    integer i;
    
    Memory_Unit MEM (
        .clk(clk),
        .address(address),
        .MemRead(MemRead), .MemWrite(MemWrite),
        .write_data(write_data), .read_data(read_data)
    );
    
    
    
    always #1 clk = ~clk;

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
