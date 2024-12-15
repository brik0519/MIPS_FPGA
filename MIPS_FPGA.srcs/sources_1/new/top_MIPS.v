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
//    input wire clk, reset, 
    input wire RxD, SW, BTN, BTN2,
    
    output wire CA, CB, CC, CD, CE, CF, CG, 
    output wire [7:0] AN,
    output wire [15:0] LED,
    output wire TxD,
    
    output wire sound
);
    wire dout;
    assign LED = {14'b0, dout, SW};
    
    /*  01 Instruction Fetch  */
    wire PCWrite, eo_10M, DBTN;
    wire [31:0] PC_Current, PC_Write_Data, PC_Next, PC_Branch, PC_Jump;
//    assign PCWrite = DBTN & eo_10M;
  

    
    MUX_Nbit_3to1 #(.N(31)) MUX_JUMP_BRANCH ( 
        .I1(PC_Next), .I2(PC_Jump), .I3(PC_Branch), 
        .sel({Branch | MEM_Jr, Jump}), .Y(PC_Write_Data) 
    );


    Program_Counter PC (
        .clk(clk), .reset(reset),
        .PCWrite(PCWrite), .PC_Write_Data(PC_Write_Data),
        .PC_Current(PC_Current)
    );

    Adder_Nbit    #(.N(31)) PC_Adder    ( .A(PC_Current), .B(32'd4), .Y(PC_Next) );


    wire [31:0] Instruction;             
    Instruction_Memory_Unit INSTRUCTION_MEM(
        .clk(clk), .address(PC_Current),
        .read_data(Instruction)
    );


    /* 02 Instruction Decode */
    wire [31:0] ID_PC, ID_Instruction;
    IF_ID_Register IF_ID_REG (
        .clk(clk), .reset(reset), .IF_ID_Write(1'b1),
        .IF_PC(PC_Current), .IF_Instruction(Instruction),
        .ID_PC(ID_PC), .ID_Instruction(ID_Instruction)
    );


    wire [5:0]  op; 
    wire [4:0]  rs, rt, rd;
    wire [5:0]  fn;
    wire [10:6] shamt;
    wire [15:0] imm16;
    
    assign op      = ID_Instruction[31:26];
    assign rs      = ID_Instruction[25:21];    
    assign rt      = ID_Instruction[20:16];
    assign rd      = ID_Instruction[15:11];
    
    assign shamt   = ID_Instruction[10:6]; 
    assign fn      = ID_Instruction[5:0];
    assign imm16   = ID_Instruction[15:0];
    
    assign PC_Jump = {ID_PC[31:28], ID_Instruction[25:0] << 2};

    

    wire [1:0] ALUOp;
    wire ALUSrc, RegDst, MemRead, MemWrite, RegWrite, MemtoReg; 
    wire Beq, Bne, Jump, Jal, Lui;  
    Control_Unit CONTROLL_UNIT (
        // input
        .opcode(op), .reset(reset),
        .Instruction(ID_Instruction),
        
        // output
        .ALUOp(ALUOp), .ALUSrc(ALUSrc), .RegDst(RegDst), 
        .MemRead(MemRead), .MemWrite(MemWrite), .RegWrite(RegWrite), 
        .MemtoReg(MemtoReg), .Beq(Beq), .Bne(Bne), .Jump(Jump), .Jal(Jal), .Lui(Lui)
    );
 
    wire [3:0] ALUCtrl; wire Jr;
    ALUControl ALUControl( .ALUop(EX_ALUOp), .funct(EX_fn), .ALUctrl(ALUCtrl), .Jr(Jr) );


     wire [1023:0] Register_Wires;
    wire [4:0]  Write_Register;
    wire [31:0] Write_Data;
    wire [31:0] Registers_Read_Data_1, Registers_Read_Data_2;
    wire [4:0] WB_Reg_Destination;
    wire [31:0]
        reg0,  reg1,  reg2,  reg3,  
        reg4,  reg5,  reg6,  reg7,  
        reg8,  reg9,  reg10, reg11, 
        reg12, reg13, reg14, reg15,
        reg16, reg17, reg18, reg19, 
        reg20, reg21, reg22, reg23,
        reg24, reg25, reg26, reg27, 
        reg28, reg29, reg30, reg31;
    wire WB_RegWrite;
    
    assign Write_Register = WB_Reg_Destination;

    Registers_Unit REG_UNIT (
        .clk(clk), .reset(reset),
        .RegWrite(WB_RegWrite),
        
        .read_register_1(rs), .read_register_2(rt),
        .write_register(Write_Register),
        
        .read_data_1(Registers_Read_Data_1), .read_data_2(Registers_Read_Data_2),
        .write_data(Write_Data),
        
        .reg0(reg0),   .reg1(reg1),   .reg2(reg2),   .reg3(reg3),  
        .reg4(reg4),   .reg5(reg5),   .reg6(reg6),   .reg7(reg7),  
        .reg8(reg8),   .reg9(reg9),   .reg10(reg10), .reg11(reg11), 
        .reg12(reg12), .reg13(reg13), .reg14(reg14), .reg15(reg15),
        .reg16(reg16), .reg17(reg17), .reg18(reg18), .reg19(reg19), 
        .reg20(reg20), .reg21(reg21), .reg22(reg22), .reg23(reg23),
        .reg24(reg24), .reg25(reg25), .reg26(reg26), .reg27(reg27), 
        .reg28(reg28), .reg29(reg29), .reg30(reg30), .reg31(reg31)
    );
        

    wire [31:0] Extended_Imm_16;
    Sign_extend SIGN_EXTEND (
        .imm_16(imm16),
        .extended_imm_16(Extended_Imm_16)
    );
    

    wire [31:0] EX_PC, EX_Read_Data_1, EX_Read_Data_2, EX_Extended_Imm_16;
    wire [4:0] EX_Rt, EX_Rd, EX_Shamt;
    
    wire [1:0] EX_ALUOp;
    wire EX_ALUSrc, EX_RegDst, EX_MemRead, EX_MemWrite, EX_RegWrite, EX_MemtoReg; 
    wire EX_Beq, EX_Bne, EX_Jal, EX_Lui;
    wire [5:0] EX_fn;
    
    ID_EX_Register ID_EX_REG (
        .clk(clk), .reset(reset), .ID_EX_Write(1'b1),
        
        // Input
        .ALUOp(ALUOp), .ALUSrc(ALUSrc), .RegDst(RegDst), 
        .MemRead(MemRead), .MemWrite(MemWrite), .MemtoReg(MemtoReg), 
        .RegWrite(RegWrite), .Beq(Beq), .Bne(Bne), .Jal(Jal), .Lui(Lui),
        
        .ID_PC(ID_PC),
        .ID_read_data1(Registers_Read_Data_1), .ID_read_data2(Registers_Read_Data_2),
        .ID_extended_imm_16(Extended_Imm_16),
        .ID_rt(rt), .ID_rd(rd), .ID_shamt(shamt),
        .fn(fn),
        
        // Output
        .EX_PC(EX_PC),
        .EX_read_data1(EX_Read_Data_1), .EX_read_data2(EX_Read_Data_2), 
        .EX_extended_imm_16(EX_Extended_Imm_16),
        .EX_rt(EX_Rt), .EX_rd(EX_Rd), .EX_shamt(EX_Shamt),
        .EX_ALUOp(EX_ALUOp),
        .EX_ALUSrc(EX_ALUSrc), .EX_RegDst(EX_RegDst), .EX_MemRead(EX_MemRead), .EX_MemWrite(EX_MemWrite),
        .EX_MemtoReg(EX_MemtoReg), .EX_RegWrite(EX_RegWrite), 
        .EX_Beq(EX_Beq), .EX_Bne(EX_Bne), .EX_Jal(EX_Jal), .EX_Lui(EX_Lui),
         
         // Function code
        .EX_fn(EX_fn)
    );
    
    
    
    /* 03 Execution */
    wire [31:0] data1, data2; 
    wire [31:0] ALU_Result;
    wire Zero;
    assign data1 = EX_Read_Data_1; 
    
    MUX_Nbit_3to1 #(.N(31)) ALUMUX_ReadData2_Extenedimm16 ( 
        .I1(EX_Read_Data_2), .I2(EX_Extended_Imm_16), .I3(EX_Extended_Imm_16 << 16), 
        .sel({EX_Lui, EX_ALUSrc}), .Y(data2) 
    );
    
    wire [31:0] Branch_Add_Result, Jump_Address;
    wire MEM_Beq, MEM_Bne, MEM_Zero;
    wire Branch;
    assign Branch = (MEM_Bne & ~MEM_Zero) | (MEM_Beq & MEM_Zero);
    
    Adder_Nbit #(.N(31)) Branch_Adder( 
        .A(EX_PC), .B(EX_Extended_Imm_16<<2), .Y(Branch_Add_Result) 
    );

    MUX_Nbit_2to1 #(31) MUX_BRANCH_JR ( 
            .I1(Branch_Add_Result), .I2(data1), .sel(Jr), .Y(Jump_Address) 
    );
    
    ALU MAIN_ALU (
        // Input
        .dataA(data1), .dataB(data2), 
        .aluctrl(ALUCtrl), .shamt(EX_Shamt),
        
        // Output 
        .aluresult(ALU_Result), .zero(Zero)
    ); // ADD : aluctrl = 4'b0010;
    
    
    wire [4:0] Reg_Destination;
    
    MUX_Nbit_3to1 #(.N(4)) MUX_EX_rt_rd ( 
        .I1(EX_Rt), .I2(EX_Rd), .I3(5'd31), 
        .sel({EX_Jal, EX_RegDst}), .Y(Reg_Destination) 
    );
    
    
    wire [31:0] MEM_ALUResult, MEM_Read_Data_2, MEM_PC;
    wire [4:0] MEM_Reg_Destination;
    wire MEM_MemWrite, MEM_MemRead, MEM_MemtoReg, MEM_RegWrite, MEM_Jal, MEM_Jr;
    EX_MEM_Register EX_MEM_REG (
        // Input
        // Datapath
        .clk(clk), .reset(reset),
        .EX_PC(EX_PC),
        .Branch_Add_Result(Jump_Address), .ALU_Result(ALU_Result), .Zero(Zero), 
        .EX_Read_Data_2(EX_Read_Data_2),
        .Reg_Destination(Reg_Destination),
    
        // Controll Signal
        .EX_MemWrite(EX_MemWrite), .EX_MemRead(EX_MemRead),
        .EX_MemtoReg(EX_MemtoReg), .EX_RegWrite(EX_RegWrite),
        .EX_Beq(EX_Beq), .EX_Bne(EX_Bne), .EX_Jal(EX_Jal), .EX_Jr(Jr),
    
    
        // Output
        // Datapath
        .MEM_ALUResult(MEM_ALUResult), .MEM_Zero(MEM_Zero),
        .MEM_Read_Data_2(MEM_Read_Data_2),
        .MEM_Branch_Add_Result(PC_Branch),
        .MEM_Reg_Destination(MEM_Reg_Destination),
    
        // Controll Signal
        .MEM_MemWrite(MEM_MemWrite), .MEM_MemRead(MEM_MemRead),
        .MEM_MemtoReg(MEM_MemtoReg), .MEM_RegWrite(MEM_RegWrite),
        .MEM_Beq(MEM_Beq), .MEM_Bne(MEM_Bne), .MEM_PC(MEM_PC), .MEM_Jal(MEM_Jal), .MEM_Jr(MEM_Jr)
    );
    

    
    /*  04 Memory  */
    wire [31:0] Read_Data;
    wire [31:0] memory0, memory1, memory2,  memory3;
    wire [31:0] memory4, memory5, memory6,  memory7;
    wire [31:0] memory8, memory9, memory10, memory11;
    wire [383:0] memory_wires;
    
    Memory_Unit DATA_MEM(
        .clk(clk), .reset(reset), .address(MEM_ALUResult),
        .MemRead(MEM_MemRead), .MemWrite(MEM_MemWrite),
        .write_data(MEM_Read_Data_2), .read_data(Read_Data),
        .memory0(memory0), .memory1(memory1), .memory2(memory2),  .memory3(memory3),
        .memory4(memory4), .memory5(memory5), .memory6(memory6),  .memory7(memory7),
        .memory8(memory8), .memory9(memory9), .memory10(memory10), .memory11(memory11)
    );
    
    
    wire [31:0] WB_Read_Data, WB_ALU_Result, WB_PC; 
    wire WB_Jal;
    wire WB_MemtoReg;
    MEM_WB_Register MEM_WB_REG(
        // Input
        .clk(clk), .reset(reset), 
        .MEM_WB_Write(1'b1),
        .MEM_Read_Data(Read_Data), 
        .MEM_ALU_Result(MEM_ALUResult),
        .MEM_RegWrite(MEM_RegWrite),
        .MEM_MemtoReg(MEM_MemtoReg),
        .MEM_Reg_Destination(MEM_Reg_Destination),
        .MEM_PC(MEM_PC), .MEM_Jal(MEM_Jal),
        
        // Output
        .WB_Read_Data(WB_Read_Data), .WB_ALU_Result(WB_ALU_Result),
        .WB_RegWrite(WB_RegWrite), .WB_Reg_Destination(WB_Reg_Destination),
        .WB_MemtoReg(WB_MemtoReg), .WB_PC(WB_PC), .WB_Jal(WB_Jal)
    );
    
    /*   05 Write Back   */
    MUX_Nbit_3to1 #(.N(31)) WriteDataMUX_aluresult_ReadData ( 
        .I1(WB_Read_Data), .I2(WB_ALU_Result), .I3(WB_PC), 
        .sel({WB_Jal, WB_MemtoReg}), .Y(Write_Data) 
    );
    
    
    /*   I/O Field   */
    //Button
    Debounce U0 (
        .clk(clk), .en(eo_10M), .rstn(reset), .BTN(BTN),
        .debounced(DBTN)
    );
    
    //Seven segment
    wire [3:0] D0, D1, D2, D3, D4, D5, D6, D7;
    seven_segment_8_drv U5 (
        .clk(clk), .reset(reset), 
        .D0(D0),.D1(D1),.D2(D2),.D3(D3),.D4(D4),.D5(D5),.D6(D6),.D7(D7), 
        .a(CA), .b(CB), .c(CC), .d(CD), .e(CE), .f(CF), .g(CG), .AN(AN)
    );
    
    //Clock divider for sampling
    wire eo_100M, eo_1M, eo_100K, eo_10K, eo_1K, eo_100;
    cnt_100M DIV (
        .clk(clk), .rstn(reset),
        .eo_100M(eo_100M), .eo_10M(eo_10M), .eo_1M(eo_1M),
        .eo_100K(eo_100K), .eo_10K(eo_10K), .eo_1K(eo_1K),
        .eo_100(eo_100) 
    );
    
    // UART
//    wire man_clk, error;
//    UART_Top_Buffer UART(
//        /*  Input  */
//        .clk(clk), .rst(reset), .din(BTN2),
//        .RxD(RxD),
        
//        // Data
//        .registor_in(Register_Wires),
//        .memory_in(Memory_Wires),
        
//        /*  Output  */
//        .TxD(TxD), .man_clk(man_clk), 
//        .error(error), .dout(dout)
//    );
    
    // Speaker
    sound_gen speaker(
        //input
        .clk(clk), .ev(Branch||Jump||Jr), .rst(reset),
        //output
        .pwm_sound(sound)
    );
    
//    assign D0 = PC_Current[3:0];
//    assign D1 = PC_Current[7:4];
//    assign D2 = PC_Current[11:8];
//    assign D3 = PC_Current[15:12];
//    assign D4 = PC_Current[19:16];
//    assign D5 = PC_Current[23:20];
//    assign D6 = PC_Current[27:24];
//    assign D7 = PC_Current[31:28];

    
    
//    assign D0 = WB_ALU_Result[3:0];
//    assign D1 = WB_ALU_Result[7:4];
//    assign D2 = WB_ALU_Result[11:8];
//    assign D3 = WB_ALU_Result[15:12];
//    assign D4 = WB_ALU_Result[19:16];
//    assign D5 = WB_ALU_Result[23:20];
//    assign D6 = WB_ALU_Result[27:24];
//    assign D7 = WB_ALU_Result[31:28];
    
//    assign D0 = ( SW ) ? ID_Instruction[3:0]   : PC_Current[3:0];
//    assign D1 = ( SW ) ? ID_Instruction[7:4]   : PC_Current[7:4];
//    assign D2 = ( SW ) ? ID_Instruction[11:8]  : PC_Current[11:8];
//    assign D3 = ( SW ) ? ID_Instruction[15:12] : PC_Current[15:12];
//    assign D4 = ( SW ) ? ID_Instruction[19:16] : PC_Current[19:16];
//    assign D5 = ( SW ) ? ID_Instruction[23:20] : PC_Current[23:20];
//    assign D6 = ( SW ) ? ID_Instruction[27:24] : PC_Current[27:24];
//    assign D7 = ( SW ) ? ID_Instruction[31:28] : PC_Current[31:28];
    
    assign D0 = ( SW ) ? WB_ALU_Result[3:0]   : PC_Current[3:0];
    assign D1 = ( SW ) ? WB_ALU_Result[7:4]   : PC_Current[7:4];
    assign D2 = ( SW ) ? WB_ALU_Result[11:8]  : PC_Current[11:8];
    assign D3 = ( SW ) ? WB_ALU_Result[15:12] : PC_Current[15:12];
    assign D4 = ( SW ) ? WB_ALU_Result[19:16] : PC_Current[19:16];
    assign D5 = ( SW ) ? WB_ALU_Result[23:20] : PC_Current[23:20];
    assign D6 = ( SW ) ? WB_ALU_Result[27:24] : PC_Current[27:24];
    assign D7 = ( SW ) ? WB_ALU_Result[31:28] : PC_Current[31:28];
    
    
    /*   For Simulation   */
    reg clk, reset;
    assign PCWrite = 1'b1; // for debugging  
    always #1 clk = ~clk;
    initial begin
        clk = 0; reset = 1;
        #2 reset = 0; #1;
       

        #100 $finish;

    end

endmodule
