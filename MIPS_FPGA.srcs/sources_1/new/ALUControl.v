`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/09 10:51:00
// Design Name: 
// Module Name: ALUControl
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


module ALUControl(
    input [1:0] ALUop,
    input [5:0] funct,
    output reg [3:0] ALUctrl,
    output reg jump
);
always @ (*) begin
    jump = 1'b0;
    case(ALUop)
        2'b00: ALUctrl = 4'b0010;   //lw,sw 
        2'b01: ALUctrl = 4'b0110;   //beq(sub)
        2'b10: if (funct == 6'b000000) ALUctrl = 4'b0011;       //sll
               else if(funct == 6'b100000) ALUctrl = 4'b0010;   //add
               else if(funct == 6'b100010) ALUctrl = 4'b0110;   //sub
               else if(funct == 6'b100100) ALUctrl = 4'b0000;   //and
               else if(funct == 6'b100101) ALUctrl = 4'b0001;   //or
               else if(funct == 6'b101010) ALUctrl = 4'b0111;   //slt
               else if(funct == 6'b100111) ALUctrl = 4'b1100;   //nor
               else if(funct == 6'b001000) begin 
                        ALUctrl = 4'b0000;   //jr(and)
                        jump = 1'b1;
                    end
               else ALUctrl = 4'b0010;                          //add
        2'b11: ALUctrl = 4'b0111;   //slti
        default: ALUctrl = 4'b0000;
    endcase
end    

endmodule
