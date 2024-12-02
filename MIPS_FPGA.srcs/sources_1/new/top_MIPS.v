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


module top_MIPS(
    input wire clk, reset,
    output wire LED
);
    assign LED = 1'b1;
    
    
    
    /*  01 Instruction Fetch  */
    reg PCWrite;
    wire PCSrc;//, PC_write;
    wire [31:0] PC_Current, PC_Write_Data, PC_Next, PC_Branch;
    assign PCSrc = MEM_Branch & MEM_Zero;
 
    MUX_Nbit_2to1 #(.N(31)) MUX_Branch  ( .I1(PC_Next), .I2(PC_Branch), .sel(PCSrc), .Y(PC_Write_Data)); //!PC_Branch !PC_Write_Data

    Program_Counter PC (
        .clk(clk), .reset(reset),
        .PCWrite(PCWrite), .PC_Write_Data(PC_Write_Data),
        .PC_Current(PC_Current)
    );

    Adder_Nbit    #(.N(31)) PC_Adder    ( .A(PC_Current), .B(32'b1), .Y(PC_Next) );


    wire [31:0] Instruction; 
    Instruction_Memory_Unit INSTRUCTION_MEM(
        .clk(clk), .reset(reset), .address(PC_Current),
        .MemRead(1'b1), .MemWrite(1'b0),
        .write_data(), .read_data(Instruction)
    );


    /* 02 Instruction Decode */
    wire [31:0] ID_PC, ID_Instruction;
    IF_ID_Register IF_ID_REG (
        .clk(clk), .reset(reset), .IF_ID_Write(1'b1),
        .IF_PC(PC_Next), .IF_Instruction(Instruction),
        .ID_PC(ID_PC), .ID_Instruction(ID_Instruction)
    );


    wire [5:0]  op; 
    wire [4:0]  rs, rt, rd;
    wire [5:0]  fn;
    wire [15:0] imm16;
    
    assign op     = ID_Instruction[31:26];
    assign rs     = ID_Instruction[25:21];    
    assign rt     = ID_Instruction[20:16];
    assign rd     = ID_Instruction[15:11];
    assign fn     = ID_Instruction[5:0];
    assign imm16  = ID_Instruction[15:0];
    

    wire [1:0] ALUOp;
    wire ALUSrc, RegDst, MemRead, MemWrite, RegWrite, MemtoReg, Branch;    
    Control_Unit CONTROLL_UNIT (
        // input
        .opcode(op), .reset(reset),
        
        // output
        .ALUOp(ALUOp), .ALUSrc(ALUSrc), .RegDst(RegDst), 
        .MemRead(MemRead), .MemWrite(MemWrite), .RegWrite(RegWrite), 
        .MemtoReg(MemtoReg), .Branch(Branch)
    );
 
    wire [3:0] ALUCtrl;
    ALUControl ALUControl(
        .ALUop(EX_ALUOp), .funct(EX_fn), .ALUctrl(ALUCtrl)
    );

    // wire RegWrite;
    wire [4:0]  Write_Register;
    wire [31:0] Write_Data;
    wire [31:0] Registers_Read_Data_1, Registers_Read_Data_2;
    assign Write_Register = WB_Reg_Destination;
    
    Registers_Unit REG_UNIT (
        .clk(clk), .reset(reset),
        .RegWrite(RegWrite),
        
        .read_register_1(rs), .read_register_2(rt),
        .write_register(Write_Register),
        
        .read_data_1(Registers_Read_Data_1), .read_data_2(Registers_Read_Data_2),
        .write_data(Write_Data)
    );
        

    wire [31:0] Extended_Imm_16;
    Sign_extend SIGN_EXTEND (
        .imm_16(imm16),
        .extended_imm_16(Extended_Imm_16)
    );
    

    wire [31:0] EX_Read_Data_1, EX_Read_Data_2, EX_Extended_Imm_16;
    wire [4:0] EX_Rt, EX_Rd;
    
    wire [1:0] EX_ALUOp;
    wire EX_ALUSrc, EX_RegDst, EX_MemRead, EX_MemWrite, EX_RegWrite, EX_MemtoReg, EX_Branch;
    wire [5:0] EX_fn;
    
    ID_EX_Register ID_EX_REG (
        .clk(clk), .reset(reset), .ID_EX_Write(1'b1),
        
        // Input
        .ALUOp(ALUOp), .ALUSrc(ALUSrc), .RegDst(RegDst), 
        .MemRead(MemRead), .MemWrite(MemWrite), .MemtoReg(MemtoReg), 
        .RegWrite(RegWrite), .Branch(Branch),
        
        .ID_read_data1(Registers_Read_Data_1), .ID_read_data2(Registers_Read_Data_2),
        .ID_extended_imm_16(Extended_Imm_16),
        .ID_rt(rt), .ID_rd(rd),
        .fn(fn),
        
        // Output
        .EX_read_data1(EX_Read_Data_1), .EX_read_data2(EX_Read_Data_2), 
        .EX_extended_imm_16(EX_Extended_Imm_16),
        .EX_rt(EX_Rt), .EX_rd(EX_Rd),
        .EX_ALUOp(EX_ALUOp),
        .EX_ALUSrc(EX_ALUSrc), .EX_RegDst(EX_RegDst), .EX_MemRead(EX_MemRead), .EX_MemWrite(EX_MemWrite),
        .EX_MemtoReg(EX_MemtoReg), .EX_RegWrite(EX_RegWrite), .EX_Branch(EX_Branch),
         
         // Function code
        .EX_fn(EX_fn)
    );
    
    
    
    /* 03 Execution */
    wire [31:0] data1, data2; 
    wire [31:0] ALU_Result;
    wire Zero;
    assign data1 = EX_Read_Data_1;
    
    MUX_Nbit_2to1 #(31) ALUMUX_ReadData2_Extenedimm16 ( 
        .I1(EX_Read_Data_1), .I2(EX_Extended_Imm_16), .sel(EX_ALUSrc), .Y(data2) 
    );
    
    ALU MAIN_ALU (
        .dataA(data1), .dataB(data2), .aluctrl(ALUCtrl), .aluresult(ALU_Result), .zero(Zero)
    ); // ADD : aluctrl = 4'b0010;
    
    
    wire [4:0] Reg_Destination;
    MUX_Nbit_2to1 #(4) MUX_EX_rt_rd ( 
        .I1(EX_Rt), .I2(EX_Rd), .sel(RegDst), .Y(Reg_Destination) 
    );
    
    
    wire [31:0] MEM_ADDResult, MEM_ALUResult, MEM_Read_Data_2;
    wire [4:0] MEM_Reg_Destination;
    wire MEM_MemWrite, MEM_MemRead, MEM_MemtoReg, MEM_RegWrite, MEM_Branch, MEM_Zero;
    EX_MEM_Register EX_MEM_REG (
        // Input
        // Datapath
        .clk(clk), .reset(reset),
        .ADD_Result(PC_Branch), .ALU_Result(ALU_Result), .Zero(Zero), 
        .EX_Read_Data_2(EX_Read_Data_2),
        .Reg_Destination(Reg_Destination),
    
        // Controll Signal
        .EX_MemWrite(EX_MemWrite), .EX_MemRead(EX_MemRead),
        .EX_MemtoReg(EX_MemtoReg), .EX_RegWrite(EX_RegWrite),
        .EX_Branch(EX_Branch),
    
    
        // Output
        // Datapath
        .MEM_ADDResult(MEM_ADDResult), .MEM_ALUResult(MEM_ALUResult), .MEM_Zero(MEM_Zero),
        .MEM_Read_Data_2(MEM_Read_Data_2),
        .MEM_Reg_Destination(MEM_Reg_Destination),
    
        // Controll Signal
        .MEM_MemWrite(MEM_MemWrite), .MEM_MemRead(MEM_MemRead),
        .MEM_MemtoReg(MEM_MemtoReg), .MEM_RegWrite(MEM_RegWrite),
        .MEM_Branch(MEM_Branch)
    );

    Adder_Nbit #(.N(31)) Branch_Adder( .A(PC_Next), .B(Extended_Imm_16<<2), .Y(PC_Branch) );
    
    /*  04 Memory  */
    wire [31:0] Read_Data;
    Memory_Unit DATA_MEM(
        .clk(clk), .reset(reset), .address(MEM_ALUResult),
        .MemRead(MEM_MemRead), .MemWrite(MEM_MemWrite),
        .write_data(MEM_Read_Data_2), .read_data(Read_Data)
    );
    
    
    wire [31:0] WB_Read_Data, WB_ALU_Result;
    wire [4:0] WB_Reg_Destination;
    wire WB_MemWrite, WB_MemRead;
    MEM_WB_Register MEM_WB_REG(
        // Input
        .clk(clk), .reset(reset), 
        .MEM_WB_Write(1'b1),
        .MEM_Read_Data(Read_Data), 
        .MEM_ALU_Result(MEM_ALUResult),
        .MEM_MemWrite(MEM_MemWrite), 
        .MEM_MemRead(MEM_MemRead),
        .MEM_Reg_Destination(MEM_Reg_Destination),
        
        // Output
        .WB_Read_Data(WB_Read_Data), .WB_ALU_Result(WB_ALU_Result),
        .WB_MemWrite(WB_MemWrite), .WB_MemRead(WB_MemRead),
        .WB_Reg_Destination(WB_Reg_Destination)
    );
    
    /*   05 Write Back   */
    MUX_Nbit_2to1 #(31) WriteDataMUX_aluresult_ReadData ( 
        .I1(WB_ALU_Result), .I2(WB_Read_Data), .sel(ALUSrc), .Y(Write_Data) 
    );
    

//    always #1 clk = ~clk;
    
    
//    initial begin
//        clk = 1; reset = 1;
//        PCWrite = 0;
//        #3 reset = 0; #2;
               
//        PCWrite = 1; #4 PCWrite = 0;
       

//        #50 $finish;

//    end

endmodule
