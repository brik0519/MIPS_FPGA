`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/07 17:13:27
// Design Name: 
// Module Name: string_gen
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

module string_gen (
 input wire clk, rst,
 input wire [1023:0] registor_in,
 input wire [1023:0] memory_in,
 
 output wire new,
 output reg [7:0] char
);

wire [31:0] registor [0:31];
wire [31:0] memory [0:31];

genvar i;
generate
    for (i = 0; i < 32; i = i + 1) begin : split_logic
        assign registor[i] = registor_in[1023 - i*32 -: 32];
        assign memory[i] = memory_in[1023 - i*32 -: 32];
    end
endgenerate

function [7:0] print_data;
    input [31:0] data_in;
    input [4:0] index;
    input [7:0] cnt;
    input is_memory;
    begin
    case(cnt)
         0: print_data = is_memory ? "M" : " ";
         1: print_data = is_memory ? "[" : "$";
         2: print_data = index[4] + 8'h30;
         3: if(index[3:0] < 4'ha) print_data = index[3:0] + 8'h30;
            else print_data = (index[3:0] + 8'h37);
         4: print_data = is_memory ? "]" : " ";
         5: print_data = " ";
         6: print_data = ":";
         7: print_data = " ";
         8: if(data_in[31:28] < 4'ha) print_data = data_in[31:28] + 8'h30;
             else print_data = (data_in[31:28] + 8'h37);
         9: if(data_in[27:24] < 4'ha) print_data = data_in[27:24] + 8'h30;
             else print_data = (data_in[27:24] + 8'h37);
         10: if(data_in[23:20] < 4'ha) print_data = data_in[23:20] + 8'h30;
             else print_data = (data_in[23:20] + 8'h37);
         11: if(data_in[19:16] < 4'ha) print_data = data_in[19:16] + 8'h30;
             else print_data = (data_in[19:16] + 8'h37);
         12: if(data_in[15:12] < 4'ha) print_data = data_in[15:12] + 8'h30;
             else print_data = (data_in[15:12] + 8'h37);
         13: if(data_in[11:8] < 4'ha) print_data = data_in[11:8] + 8'h30;
             else print_data = (data_in[11:8] + 8'h37);
         14: if(data_in[7:4] < 4'ha) print_data = data_in[7:4] + 8'h30;
             else print_data = (data_in[7:4] + 8'h37);
         15: if(data_in[3:0] < 4'ha) print_data = data_in[3:0] + 8'h30;
             else print_data = (data_in[3:0] + 8'h37);
         default: print_data = "_";
    endcase    
    end
endfunction 

localparam STATE_CHAR = 0, STATE_TAB = 1, STATE_NEW = 2, STATE_MEM = 3, STATE_RESET = 4;
localparam MAX_DATA = 32, MAX_LINE = 4;

reg is_new, is_mem;
reg [1:0] state;
reg [5:0] index_data;
reg [7:0] cnt_data;

always @(posedge clk, posedge rst) begin
    if (rst) begin
        char <= 8'h0;
        index_data <= 0;
        cnt_data <= 0;
        state <= STATE_CHAR;
        is_mem <= 1'b0;
        is_new <= 1'b0;
    end else begin
        case (state)
            STATE_CHAR: begin
                char <= print_data((is_mem) ? memory[index_data] : registor[index_data], index_data, cnt_data, is_mem);
                cnt_data <= cnt_data + 1;
                if (cnt_data == 15) begin
                    cnt_data <= 0;
                    index_data <= index_data + 1;
                    state <= ((index_data & (MAX_LINE-1)) == (MAX_LINE-1)) ? STATE_NEW : STATE_TAB;
                end
            end
            STATE_TAB: begin
                char <= "\t";
                if (index_data == MAX_DATA) begin
                    is_mem <= 1'b1;
                    index_data <= 0;
                end
                state <= STATE_CHAR;
            end
            STATE_NEW: begin
                char <= is_new ? "\n" : "\r";
                is_new <= ~is_new;
                if (is_new) begin
                    if (index_data == MAX_DATA && !is_mem) begin
                        is_mem <= 1'b1;
                        index_data <= 0;
                        state <= STATE_CHAR;
                    end
                    else if (index_data == MAX_DATA && is_mem) begin
                        is_mem <= 1'b0;
                        index_data <= 0;
                        cnt_data <= 0;
                        state <= STATE_RESET;
                    end
                    else begin
                        state <= STATE_CHAR;
                    end
                end
                else state <= STATE_NEW;
            end
            STATE_RESET: begin
                case(cnt_data)
                0: begin
                    char <= 8'h1B;
                    cnt_data <= cnt_data + 1;
                end
                1: begin
                    char <= 8'h5B;
                    cnt_data <= cnt_data + 1;
                end
                2: begin
                    char <= 8'h48;
                    cnt_data <= cnt_data + 1;
                end
                3: begin
                    char <= 8'h0;
                    index_data <= 0;
                    cnt_data <= 0;
                    state <= STATE_CHAR;
                    is_mem <= 1'b0;
                    is_new <= 1'b0;
                end
                endcase
            end
        endcase
    end
end

 assign new = clk;
endmodule
