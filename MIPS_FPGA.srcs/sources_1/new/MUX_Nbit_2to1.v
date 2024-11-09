`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/28 09:39:59
// Design Name: 
// Module Name: MUX_Nbit_2to1
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


module MUX_Nbit_2to1 #(parameter N = 0)(
input [N:0] I1,I2,
input sel,
output reg [N:0] Y
    );
    
always @ (*) begin
    case(sel)
    1'b1 : Y = I2;
    default : Y = I1;
    endcase
end
    
endmodule
