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


    /* 02 Instruction Decode */
    // wire IF_ID_Write;
    wire [31:0] ID_PC, ID_Instruction;
    IF_ID_Register IF_ID_REG (
        .clk(clk), .reset(reset), .IF_ID_Write(1'b1),
        .IF_PC(PC_next), .IF_Instruction(Instruction),
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
        .opcode(op), .rst(reset), .brancheq(zero),
        
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
    wire [4:0]  write_register;
    wire [31:0] Registers_Read_Data1, Registers_Read_Data2;
    
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
    

    wire [31:0] EX_read_data1, EX_read_data2, EX_extended_imm_16;
    wire [4:0] EX_rt, EX_rd;
    
    wire [1:0] EX_ALUOp;
    wire EX_ALUSrc, EX_RegDst, EX_MemRead, EX_MemWrite, EX_RegWrite, EX_MemtoReg, EX_Branch;
    wire [5:0] EX_fn;
    
    ID_EX_Register ID_EX_REG (
        .clk(clk), .reset(reset), .ID_EX_Write(1'b1),
        
        // Input
        .ALUOp(ALUOp), .ALUSrc(ALUSrc), .RegDst(RegDst), 
        .MemRead(MemRead), .MemWrite(MemWrite), .MemtoReg(MemtoReg), 
        .RegWrite(RegWrite), .Branch(Branch),
        
        .ID_read_data1(Registers_Read_Data1), .ID_read_data2(Registers_Read_Data2),
        .ID_extended_imm_16(extended_imm_16),
        .ID_rt(rt), .ID_rd(rd),
        .fn(fn),
        
        // Output
        .EX_read_data1(EX_read_data1), .EX_read_data2(EX_read_data2), 
        .EX_extended_imm_16(EX_extended_imm_16),
        .EX_rt(EX_rt), .EX_rd(EX_rd),
        .EX_ALUOp(EX_ALUOp),
        .EX_ALUSrc(EX_ALUSrc), .EX_RegDst(EX_RegDst), .EX_MemRead(EX_MemRead), .EX_MemWrite(EX_MemWrite),
        .EX_MemtoReg(EX_MemtoReg), .EX_RegWrite(EX_RegWrite), .EX_Branch(EX_Branch),
         
         // Function code
        .EX_fn(EX_fn)
    );
    
    
    /* 03 Execution */
    wire [31:0] data1, data2; 
    wire [31:0] ALU_Result;
    wire zero;
    assign data1 = EX_read_data1;
    
    MUX_Nbit_2to1 #(31) ALUMUX_ReadData2_Extenedimm16 ( 
        .I1(EX_read_data1), .I2(EX_extended_imm_16), .sel(EX_ALUSrc), .Y(data2) 
    );
    
    ALU MAIN_ALU (
        .dataA(data1), .dataB(data2), .aluctrl(ALUCtrl), .aluresult(ALU_Result), .zero(zero)
    ); // ADD : aluctrl = 4'b0010;
    
    
    wire [4:0] Reg_Destination;
    MUX_Nbit_2to1 #(4) MUX_EX_rt_rd ( 
        .I1(EX_rt), .I2(EX_rd), .sel(RegDst), .Y(Reg_Destination) 
    );
    
    
    wire [31:0] MEM_ADDResult, MEM_ALUResult, MEM_Read_Data_2;
    wire [4:0] MEM_Reg_Destination;
    wire MEM_MemWrite, MEM_MemRead, MEM_MemtoReg, MEM_RegWrite;
    EX_MEM_Register EX_MEM_REG (
        /*  Input   */
        // Datapath
        .clk(clk), .reset(reset),
        .ADD_Result(PC_branch), .ALU_Result(ALU_Result), .EX_Read_Data_2(EX_read_data2),
        .Reg_Destination(Reg_Destination),
    
        // Controll Signal
        .EX_MemWrite(EX_MemWrite), .EX_MemRead(EX_MemRead),
        .EX_MemtoReg(EX_MemtoReg), .EX_RegWrite(EX_RegWrite),
    
    
        /*  Output  */
        // Datapath
        .MEM_ADDResult(MEM_ADDResult), .MEM_ALUResult(MEM_ALUResult), .MEM_Read_Data_2(MEM_Read_Data_2),
        .MEM_Reg_Destination(MEM_Reg_Destination),
    
        // Controll Signal
        .MEM_MemWrite(MEM_MemWrite), .MEM_MemRead(MEM_MemRead),
        .MEM_MemtoReg(MEM_MemtoReg), .MEM_RegWrite(MEM_RegWrite)
    );

    
    /*  04 Memory  */
    wire [31:0] read_data;
    Memory_Unit DATA_MEM(
        .clk(clk), .reset(reset), .address(MEM_ALUResult),
        .MemRead(MEM_MemRead), .MemWrite(MEM_MemWrite),
        .write_data(MEM_Read_Data_2), .read_data(read_data)
    );
    
    
    wire [31:0] WB_Read_Data, WB_ALU_Result;
    wire WB_MemWrite, WB_MemRead;
    MEM_WB_Register MEM_WB_REG(
        // Input
        .clk(clk), .reset(reset), 
        .MEM_WB_Write(1'b1),
        .MEM_Read_Data(read_data), .MEM_ALU_Result(MEM_ALUResult),
        .MEM_MemWrite(MEM_MemWrite), .MEM_MemRead(MEM_MemRead),
        
        // Output
        .WB_Read_Data(WB_Read_Data), .WB_ALU_Result(WB_ALU_Result),
        .WB_MemWrite(WB_MemWrite), .WB_MemRead(WB_MemRead)
    );
    
    /*   05 Write Back   */
    wire [31:0] write_data;
    MUX_Nbit_2to1 #(31) WriteDataMUX_aluresult_ReadData ( 
        .I1(WB_ALU_Result), .I2(WB_Read_Data), .sel(ALUSrc), .Y(write_data) 
    );
    
        

    always #1 clk = ~clk;
    
    
    initial begin
        clk = 1; reset = 1;
        PC_write = 0;
        #3 reset = 0; #2;
               
        PC_write = 1; #3 PC_write = 0;
       

        #50 $finish;

    end

endmodule
