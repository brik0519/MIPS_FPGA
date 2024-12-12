`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/02 09:39:26
// Design Name: 
// Module Name: ALU
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


module ALU(
input wire [31:0] dataA, dataB,
input wire [3:0] aluctrl,
input wire [4:0] shamt,
output reg [31:0] aluresult,
output reg zero
    );
    always @(*) begin
        zero = 1'd0;                                //default zero
        aluresult = 32'd0;                          //default aluresult
        
        casex (aluctrl)
            4'b0000: aluresult = dataA & dataB;     //and
            4'b0001: aluresult = dataA | dataB;     //or
            4'b0010: aluresult = dataA + dataB;     //add
            4'b011x: begin
                        aluresult = dataA - dataB;  //sub
                        if(aluctrl[0] == 1)         //slt detect
                            if(dataA < dataB) aluresult = 32'd1;
                            else aluresult = 32'd0;
                     end
            4'b0011: aluresult = dataA << shamt;
            4'b1100: aluresult = ~(dataA | dataB);  //nor
            default: aluresult = 32'd0;
        endcase
        
        if (aluresult == 32'd0)                     //for beq
            zero = 1;
         
    end
endmodule
