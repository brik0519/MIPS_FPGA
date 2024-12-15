`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/13 11:20:45
// Design Name: 
// Module Name: sound_gen
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


module sound_gen(
    input wire clk, ev, rst,
    output reg pwm_sound
    );
    
    reg [32:0] counter;
    localparam tone_freq = 440;
    localparam dutycycle = 50;
    
    always @ (posedge clk or posedge rst) begin
        if(rst) begin
            counter <= 0;
            pwm_sound <= 0;
        end
        else begin
            if(counter == 113632) begin
                counter <= 0;
                if(ev) pwm_sound <= ~pwm_sound;
            end
            else begin
                counter <= counter + 1;
            end
        end
    end
    
endmodule
