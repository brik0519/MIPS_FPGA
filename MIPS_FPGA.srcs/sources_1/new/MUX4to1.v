`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/09 10:27:57
// Design Name: 
// Module Name: MUX4to1
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


module MUX4to1(
input [31:0] In0, In1, In2, In3,
input [1:0] sel,
output reg [31:0] Out
    );
    
always @ (*) begin
    case(sel)
        2'd1: Out = In1;
        2'd2: Out = In2;
        2'd3: Out = In3;
        default Out = In0;
     endcase
end
    
endmodule
