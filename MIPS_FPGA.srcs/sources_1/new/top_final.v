`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/15 20:24:46
// Design Name: 
// Module Name: top_final
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


module top_final(
    input wire clk, reset, BTN, BTN2, SW,
    
    input wire RxD,
    output wire TxD,
    
    output wire CA, CB, CC, CD, CE, CF, CG, 
    output wire [7:0] AN,
    output wire [15:0] LED,
    output wire sound
    );
    wire dout, error, man_clk;
    assign LED = {14'b0, dout, SW};
    wire BTN_clk;
    
    debounce    Debounce(
         .clk(clk), .rstn(!reset),
        .din(BTN),
        .tick(BTN_clk),
        .toggle()
    );
    
    wire sound_ev; 
    wire [1023:0] Register_Wires, Memory_Wires;
    wire [31:0] ID_Instruction, PC_Current;
    top_MIPS    MIPS(
        //input
        .clk(BTN_clk), .reset(reset),
        //output

        .sound(sound_ev),
        .registor_out(Register_Wires), .memory_out(Memory_Wires),
        .ID_Instruction(ID_Instruction), .PC_Current(PC_Current)
    );
    
    UART_Top_Buffer UART(
        /*  Input  */
        .clk(clk), .rst(reset), .din(BTN2),
        .RxD(RxD),
        
        // Data
        .registor_in(Register_Wires),
        .memory_in(Memory_Wires),
        
        /*  Output  */
        .TxD(TxD), .man_clk(man_clk), 
        .error(error), .dout(dout)
    );
    
    // Speaker
    sound_gen speaker(
        //input
        .clk(clk), .ev(sound_ev), .rst(reset),
        //output
        .pwm_sound(sound)
    );

    //Seven segment
    wire [3:0] D0, D1, D2, D3, D4, D5, D6, D7;
    seven_segment_8_drv U5 (
        .clk(clk), .reset(reset), 
        .D0(D0),.D1(D1),.D2(D2),.D3(D3),.D4(D4),.D5(D5),.D6(D6),.D7(D7), 
        .a(CA), .b(CB), .c(CC), .d(CD), .e(CE), .f(CF), .g(CG), .AN(AN)
    );
    
//    assign D0 = PC_Current[3:0];
//    assign D1 = PC_Current[7:4];
//    assign D2 = PC_Current[11:8];
//    assign D3 = PC_Current[15:12];
//    assign D4 = PC_Current[19:16];
//    assign D5 = PC_Current[23:20];
//    assign D6 = PC_Current[27:24];
//    assign D7 = PC_Current[31:28];
    
    assign D0 = ( SW ) ? ID_Instruction[3:0]   : PC_Current[3:0];
    assign D1 = ( SW ) ? ID_Instruction[7:4]   : PC_Current[7:4];
    assign D2 = ( SW ) ? ID_Instruction[11:8]  : PC_Current[11:8];
    assign D3 = ( SW ) ? ID_Instruction[15:12] : PC_Current[15:12];
    assign D4 = ( SW ) ? ID_Instruction[19:16] : PC_Current[19:16];
    assign D5 = ( SW ) ? ID_Instruction[23:20] : PC_Current[23:20];
    assign D6 = ( SW ) ? ID_Instruction[27:24] : PC_Current[27:24];
    assign D7 = ( SW ) ? ID_Instruction[31:28] : PC_Current[31:28];


endmodule
