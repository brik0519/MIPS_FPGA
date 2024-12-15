`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/09 15:49:07
// Design Name: 
// Module Name: tb_top_MIPS
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


module tb_top_MIPS();
    
    reg clk, reset, BTN, BTN2;
    wire RxD, SW, CA, CB, CC, CD, CE, CF, CG, AN;
    wire LED, TxD, sound;
    
    top_MIPS MIPS(
        .clk(clk), .reset(reset), .BTN(BTN), .BTN2(BTN2),
        .RxD(RxD), .SW(SW),
        
        .CA(CA), .CB(CB), .CC(CC), .CD(CD), .CE(CE), .CF(CF), .CG(CG), 
        .AN(AN), .LED(LED), .TxD(TxD),
        
        .sound(sound)
    );
    
    always #1 clk = ~clk;
    
    initial begin
        clk = 1; BTN = 1; BTN2 = 0; 
        reset = 1;
        #5 reset = 0;
        #50 $finish;
    end


endmodule
