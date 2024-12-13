`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/30 16:42:35
// Design Name: 
// Module Name: top
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


module top(
input wire clk, reset, BTN2,
input wire RxD,
output wire TxD
    );
    
    UART_Top_Buffer UART(
        /*  Input  */
        .clk(clk), .rst(reset), .din(BTN2),
        .RxD(RxD),
        
        // Data
        .registor_in(
        {32'd31, 32'd30,32'd29,32'd28,32'd27,32'd26,32'd25,
        32'd24,32'd23,32'd22,32'd21,32'd20,32'd19,32'd18,32'd17,
        32'd16,32'd15,32'd14,32'd13,32'd12,32'd11,32'd10,32'd09,
        32'd08,32'd07,32'd06,32'd05,32'd04,32'd03,32'd02,32'd01, 32'd00}),
        .memory_in({32'd31, 32'd30,32'd29,32'd28,32'd27,32'd26,32'd25,
        32'd24,32'd23,32'd22,32'd21,32'd20,32'd19,32'd18,32'd17,
        32'd16,32'd15,32'd14,32'd13,32'd12,32'd11,32'd10,32'd09,
        32'd08,32'd07,32'd06,32'd05,32'd04,32'd03,32'd02,32'd01, 32'd00}),
        
        /*  Output  */
        .TxD(TxD), .man_clk(), 
        .error(), .dout()
    );
    
    
endmodule
