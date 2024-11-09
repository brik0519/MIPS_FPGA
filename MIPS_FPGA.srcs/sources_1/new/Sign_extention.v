`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/09 15:39:31
// Design Name: 
// Module Name: Sign_extention
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


module Sign_extender (
    input  wire [15:0] imm_16,
    output wire [31:0] extended_imm_16        
);

    assign extended_imm_16 = {  { 16{imm_16[15]} }, imm_16  };

endmodule
