`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/30 18:47:23
// Design Name: 
// Module Name: MEM_WB_Register
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


module MEM_WB_Register(
    input wire clk, reset, 
    input wire MEM_WB_Write,
    
    /*  Input   */
    // Datapath
    input wire [31:0] MEM_Read_Data, MEM_ALU_Result,
    input wire [4:0] MEM_Reg_Destination,
    
    // Control Signal
    input wire MEM_RegWrite, MEM_MemtoReg,
    
    
    /*  Output  */
    // Datapath
    output reg [31:0] WB_Read_Data, WB_ALU_Result,
    output reg [4:0] WB_Reg_Destination,
    
    //Control Signal
    output reg WB_RegWrite, WB_MemtoReg
);
    
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            // Datapath
            WB_Read_Data        <= 32'b0;
            WB_ALU_Result       <= 32'b0;
            WB_Reg_Destination  <= 5'b0;
            
            // Control Signal
            WB_RegWrite <= 1'b0;
            WB_MemtoReg <= 1'b0;
        end
    
        else begin
            // Datapathz    
            WB_Read_Data  <= MEM_Read_Data;
            WB_ALU_Result <= MEM_ALU_Result;
                        
            // Control Signal
            WB_RegWrite <= MEM_RegWrite;
            WB_MemtoReg <= MEM_MemtoReg;
            
            WB_Reg_Destination <= MEM_Reg_Destination;
        end

    end    
    
    
endmodule