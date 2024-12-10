`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/02 12:24:01
// Design Name: 
// Module Name: Data_Memory_Module
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


module Instruction_Memory_Unit(
    input wire clk, reset,
    input wire MemRead, MemWrite,
    input wire [31:0] address, write_data,
    output reg [31:0] read_data
);  
    reg [7:0] memory [0:2047];
//    reg [31:0] memory [0:511];
    
    integer i;
    reg [31:0] Init_Inst;
     always @(posedge clk or posedge reset) begin
        Init_Inst = {6'b111111, 26'd0};
        
        if (reset) begin
            for (i = 0; i < 32'd2044; i = i + 4) begin
                case (i)
//                    0   : Init_Inst = {6'b111111, 26'd0};  // Program Start
//                    12   : Init_Inst = 32'h0C00_0003;  // ADDI $t0, $t0, 10;
//                    //8 : NOP
//                    //12: NOP
//                    //16: NOP
                    20  : Init_Inst = 32'h0C00_0003;  // ADD $s0, $t0, $zero;
////                    //24: NOP                    
////                    //28: NOP
////                    //32: NOP
////                    36  : Init_Inst = 32'h3C08_0007; //  LUI $0, $s0, 
//                    36  : Init_Inst = 32'hAD10_0000;  // SW $s0, 0($t0);
//                    //40: NOP    
//                    //44: NOP    
//                    //48: NOP    
//                    52  : Init_Inst = 32'h0208_8022;  // SUB $s0, $s0, $t0;
//                    //56: NOP
//                    //60: NOP
//                    //64: NOP
//                    68  : Init_Inst = 32'h2A10_000A;  // SUBI $s0, $s0, 10;
//                    //72: NOP
//                    //76: NOP
//                    //80: NOP
//                    84  : Init_Inst = 32'h8D10_0000;  // LW $s0, 0($t0);
                      //88: NOP
                      //92: NOP
                      //96: NOP
//                    100 : Init_Inst = 32'h3C08_0007;  // LUI $0, $s0, 7;
//                    104 : Init_Inst = 32'h0109_4080;   // SLL $t1, $t0, 2
                    
                    
                    
//                    20  : Init_Inst = 32'h0800_0000;  // J 0;
//                     20  : Init_Inst = 32'h1000_0004;  // BEQ $Zero, $Zero, 2 -> 8 means.
//                      20 : Init_Inst = 32'h1408_0002;  // BNE $t0, $0, 2
                        0 : Init_Inst = 32'h0C00_0003; // JAL 3
                        32 : Init_Inst = 32'h03F0_0008; // JR $0, $0, $ra

                    default: Init_Inst = {6'b111111, 26'd0};
                endcase
                {memory[i], memory[i+1], memory[i+2], memory[i+3]} <= Init_Inst;
            end
        end
    
        else begin
            if ( MemWrite )
                memory[address] <= write_data;
            if ( MemRead )
                read_data <= {
                    memory[address], memory[address+1], memory[address+2], memory[address+3]
                };
        end              
    end
    
endmodule