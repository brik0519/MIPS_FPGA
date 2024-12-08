`timescale 1ns / 1ps
`default_nettype none
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


module MUX_Nbit_3to1 #(parameter N = 0)(
    input wire [N:0] I1, I2, I3,
    input wire [1:0] sel,
    output reg [N:0] Y
);
    
always @ (*) begin
    case(sel)
        2'b0 : Y = I1;
        2'b1 : Y = I2;
        default : Y = I3;
    endcase
end
    
endmodule
