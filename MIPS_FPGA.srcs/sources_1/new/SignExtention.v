`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/09 10:18:10
// Design Name: 
// Module Name: SignExtention
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


module SignExtention(
input [15:0] In,
output [31:0] Out
    );
    
assign Out = {{16{In[15]}}, In};
    
endmodule
