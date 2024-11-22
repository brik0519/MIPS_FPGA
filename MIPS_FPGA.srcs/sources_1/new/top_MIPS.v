`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/09 15:43:06
// Design Name: 
// Module Name: top_MIPS
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


module top_MIPS();
    reg clk, reset;
    
    // 00 Previous Components
//    reg [31:0] address, write_data, read_data;
//    Memory_Unit MEM(
//        .clk(clk), .address(address),
//        .MemRead(MemRead), .MemWrite(MemWrite),
//        .write_data(write_data), .read_data(read_data),
//    );

    // 01 Instruction Fetch
//    wire [31:0] PC_write, PC_write_data;//, PC_current;
//    reg [31:0] PC_current, PC_write_data;
//    Program_Counter PC (
//        .clk(clk), .reset(reset),
//        .PC_write(PC_write), .PC_write_data(PC_write_data),
//        .PC_current(PC_current)
//    );
    
    
    reg IRWrite;
    wire [5:0] op; 
    wire [4:0]rs, rt, rd;
    wire [15:0] imm16;
    Instruction_Register IR (
        .clk(clk), .reset(reset), .IRWrite(IRWrite),
        .Instruction(Instruction), 
        .op(op), .rs(rs), .rt(rt), .rd(rd), .imm16(imm16)
    );
    
    
    // 02 Instruction Decode
    reg RegWrite;
    reg [4:0] write_register;
    reg [31:0] write_data;
    Registers_Unit REG_UNIT (
        .clk(clk), .reset(reset),
        .RegWrite(RegWrite),
        
        .read_register_1(rs), .read_register_2(rt),
        .write_register(write_register),
        
        .read_data_1(Registers_Read_Data1), .read_data_2(Registers_Read_Data2),
        .write_data(write_data)
    );
    
    
    wire [31:0]Registers_Read_Data1, Registers_Read_Data2;
//    wire Reg_A_out, Reg_B_out;
    Binary_32bit_Register A ( .clk(clk), .write_data(Registers_Read_Data1), .read_data(data1) );
    Binary_32bit_Register B ( .clk(clk), .write_data(Registers_Read_Data2), .read_data(data2) );
//    Binary_32bit_Register Memory_Data_Register ( .clk(clk), .write_data(PC_current), .read_data(PC_current) );

    
    wire [31:0] extended_imm_16;
    Sign_extender EXT(
        .imm_16(imm16),
        .extended_imm_16(extended_imm_16)
    );
    
    
    wire [31:0]data1, data2; 
    reg [3:0] aluctrl;
    wire [31:0] aluresult;
    wire zero;
    ALU MAIN_ALU (
        .dataA(data1), .dataB(extended_imm_16), .aluctrl(aluctrl), .aluresult(aluresult), .zero(zero)
    ); // ADD : aluctrl = 4'b0010;
    
    
    reg init_data, MemWrite;
    reg [31:0] Instruction;
    
    always #1 clk = ~clk;
    
    integer i;
    initial begin
        clk = 1; reset = 1;
        RegWrite = 0;
        write_data = 32'b0;
        Instruction = 32'h2108_000A; // ADDI $t0, $t0, 10;
        
        #10 reset = 0; #10;

        
        write_register = 5'b01000;   // $t0 (8번 레지스터)
        write_data = 32'd0;          // 초기 쓰기 데이터 값
//        read_register_1 = 5'b01000;  // $t0 (8번 레지스터)
//        read_register_2 = 5'b01001;  // $t1 (9번 레지스터)
        
        // 01 Instrunction Fetch
        IRWrite = 1'b1; #5 IRWrite = 1'b0;
        
        // 02 Instruction Decode
        
        // 03 Execute Instrucion
        aluctrl = 4'b0010;
        #10;

    end

endmodule
