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
    
    
    /*  01 Instruction Fetch  */
    reg PC_write;
    wire Branch;//, PC_write;
    wire [31:0] PC_current, PC_write_data, PC_next, PC_branch;
    Program_Counter PC (
        .clk(clk), .reset(reset),
        .PC_write(PC_write), .PC_write_data(PC_write_data),
        .PC_current(PC_current)
    );
 
    Adder_Nbit #(.N(31))    PC_Adder    ( .A(PC_current), .B(32'b1), .Y(PC_next) );
    MUX_Nbit_2to1 #(.N(31)) MUX_Branch  ( .I1(PC_next), .I2(PC_branch), .sel(Branch), .Y(PC_write_data));
    Adder_Nbit #(.N(31))    Branch_Adder( .A(PC_next), .B(extended_imm_16<<2), .Y(PC_branch) );

    wire [31:0] Instruction; 
    Instruction_Memory_Unit INSTRUCTION_MEM(
        .clk(clk), .reset(reset), .address(PC_current),
        .MemRead(1'b1), .MemWrite(1'b0),
        .write_data(), .read_data(Instruction)
    );

//    wire IF_ID_Write;
    wire [31:0] ID_PC, ID_Instruction;
    IF_ID_Register IF_ID_REG (
        .clk(clk), .reset(reset), .IF_ID_Write(1'b1),
        .IF_PC(PC_next), .IF_Instruction(Instruction),
        .ID_PC(ID_PC), .ID_Instruction(ID_Instruction)
    );

    
    // 02 Instruction Decode
    wire [5:0]  op; 
    wire [4:0]  rs, rt, rd;
    wire [5:0]  functn;
    wire [15:0] imm16;
    
    assign op     = Instruction[31:26];
    assign rs     = Instruction[25:21];    
    assign rt     = Instruction[20:16];
    assign rd     = Instruction[15:11];
    assign functn = Instruction[5:0];
    assign imm16  = Instruction[15:0];
    
    wire ALUSrc, RegDst, ALUOp;
    wire RegDst, MemRead, MemWrite, RegWrite, Branch;
    Control_Unit ControlUnit (
        .opcode(op), .rst(reset), .brancheq(zero),
        .ALUOp(ALUOp), .ALUSrc(ALUSrc), .RegDst(RegDst), 
        .MemRead(MemRead), .MemWrite(MemWrite), .RegWrite(RegWrite), .Branch(Branch)
    );
    
    wire [3:0] aluCtrl;
    ALUControl ALUControl(
        .ALUop(ALUOp), .funct(extended_imm_16[5:0]), .ALUctrl(aluCtrl)
    );

    // wire RegWrite;
    wire [4:0]  write_register;
    wire [31:0] Registers_Read_Data1, Registers_Read_Data2;
    MUX_Nbit_2to1 #(4) RegistersMUX_rs_rd ( .I1(rt), .I2(rd), .sel(RegDst), .Y(write_register) );
    
    Registers_Unit REG_UNIT (
        .clk(clk), .reset(reset),
        .RegWrite(RegWrite),
        
        .read_register_1(rs), .read_register_2(rt),
        .write_register(write_register),
        
        .read_data_1(Registers_Read_Data1), .read_data_2(Registers_Read_Data2),
        .write_data(write_data)
    );
        

    wire [31:0] extended_imm_16;
    Sign_extender SIGN_EXTENDER (
        .imm_16(imm16),
        .extended_imm_16(extended_imm_16)
    );
    
    
    wire [31:0] data1, data2; 
    wire [31:0] aluResult;
    wire zero;
    assign data1 = Registers_Read_Data1;
    
    MUX_Nbit_2to1 #(31) ALUMUX_ReadData2_Extenedimm16 ( 
        .I1(Registers_Read_Data2), .I2(extended_imm_16), .sel(ALUSrc), .Y(data2) 
    );
    
    ALU MAIN_ALU (
        .dataA(data1), .dataB(data2), .aluctrl(aluCtrl), .aluresult(aluResult), .zero(zero)
    ); // ADD : aluctrl = 4'b0010;
    
    wire [31:0] read_data;
    Memory_Unit DATA_MEM(
        .clk(clk), .reset(reset), .address(aluResult),
        .MemRead(MemRead), .MemWrite(MemWrite),
        .write_data(Registers_Read_Data2), .read_data(read_data)
    );
    
    wire [31:0] write_data;
    MUX_Nbit_2to1 #(31) WriteDataMUX_aluresult_ReadData ( 
        .I1(aluResult), .I2(extended_imm_16), .sel(ALUSrc), .Y(write_data) 
    );
    
        

    always #1 clk = ~clk;
    
    
    initial begin
        clk = 1; reset = 1;
        PC_write = 0;
        #10 reset = 0; #10;
               
        PC_write = 1; #2 PC_write = 0;
       

        #50 $finish;

    end

endmodule
