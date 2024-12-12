`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/07 17:07:57
// Design Name: 
// Module Name: count_char
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


module count_char(
    input wire clk, rst, trig,
    output wire sig, tc
 );
localparam INIT = 2'b00,
CNT = 2'b01,
SIG = 2'b10,
COMP = 2'b11;

reg [1:0] current_state, next_state;
reg [10:0] char_cnt;

always @(posedge clk, posedge rst) begin
    if(rst) begin
        current_state <= INIT;
    end
    else
        current_state <= next_state;
end

 always @* begin
    case(current_state)
        default : if(trig) next_state = CNT;
                  else next_state = INIT;
        CNT : if(tc) next_state = COMP;
              else next_state = SIG;
        SIG : next_state = CNT;
        COMP : next_state = INIT;
    endcase
 end
 
 always @(posedge clk, posedge rst) begin
    if(rst) begin
        char_cnt <= 0;
    end else
    case(current_state)
        default : begin char_cnt <= 0; end
        CNT : begin char_cnt <= char_cnt + 1; end
        SIG : begin char_cnt <= char_cnt; end
        COMP : begin char_cnt <= 0; end
    endcase
 end
 
assign sig = (current_state != INIT) && (current_state != CNT) && (current_state == SIG || current_state == COMP);
assign tc = (char_cnt == 1103);

endmodule
