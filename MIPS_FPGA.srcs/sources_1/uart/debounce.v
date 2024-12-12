`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/07 20:53:19
// Design Name: 
// Module Name: debounce
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


module debounce(
    input wire clk, rstn, din,
    output wire tick, toggle
);

    wire sample_palsse, clk_1khz;
    clkdiv      X0 (.rstn(rstn), .clk(clk), .clk_1000hz(clk_1khz));
    Sampling    U0 (.din(din), .clk(clk), .sample_clk(clk_1khz), .rstn(rstn), .Q(sample_palsse));
    Tpalse      U1 (.clk(clk), .rstn(rstn), .inPl(sample_palsse),.QP(tick));
    Tflipflop   U2 (.T(tick), .en(1'b1), .clk(clk), .rstn(rstn), .Q(toggle));
        
endmodule
