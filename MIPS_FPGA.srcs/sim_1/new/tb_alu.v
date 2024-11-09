`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/02 10:18:26
// Design Name: 
// Module Name: tb_alu
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


module tb_alu;

reg [3:0] aluctrl;
reg [31:0] data1, data2;
wire [31:0] result;
wire zero;

initial begin
//case1 and
aluctrl = 4'b0000;
data1 = 32'd10;
data2 = 32'd25;
//case2 or
#10aluctrl = 4'b0001;
data1 = 32'd10;
data2 = 32'd25;
//case3 add
#10aluctrl = 4'b0010;
data1 = 32'd10;
data2 = 32'd25;
//case4 sub
#10aluctrl = 4'b0110;
data1 = 32'd10;
data2 = 32'd25;
//case5 slt
#10aluctrl = 4'b0111;
data1 = 32'd10;
data2 = 32'd25;
//case6 nor
#10aluctrl = 4'b1100;
data1 = 32'd10;
data2 = 32'd25;
//case6 nor
#10aluctrl = 4'b0110;
data1 = 32'd25;
data2 = 32'd25;
end

ALU U0  (.dataA(data1), .dataB(data2), .aluctrl(aluctrl), .aluresult(result), .zero(zero));


endmodule
