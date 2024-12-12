`timescale 1ns / 1ps

module UART_Top_Buffer(
    input wire clk, rst, din,
    input wire RxD,
    
    input wire [1024:0] registor_in,
    input wire [1024:0] memory_in,
    
    output wire TxD,
    output wire man_clk,
    output wire error,
    output wire dout
);
 
    assign dout = din;
    wire new, sig0, sig1, sig2, tc, clk_low;
    wire [7:0] data;

    debounce DBNC0 (
        .clk(clk), .rstn(!rst),
        .din(din || tc),
        .tick(),
        .toggle(sig0)
    );
    
    debounce DBNC1 (
        .clk(clk),
        .rstn(!rst),
        .din(din),
        .tick(man_clk),
        .toggle()
    );

    clk_gen CLK (
        .clk_100MHz(clk),
        .rst(rst),
        .clk_low(clk_low)
    );

    count_char CNT (
        .clk(clk_low),
        .rst(rst),
        .trig(sig0),
        .sig(sig1),
        .tc(tc)
    );

    debounce DBNC2 (
        .clk(clk),
        .rstn(!rst),
        .din(sig1),
        .tick(sig2),
        .toggle()
    );

    string_gen STR (
        .clk(sig2),
        .rst(rst),
        .registor_in(1024'd0),
        .memory_in(1024'd0),
        .new(new),
        .char(data)
    ); 
    // UART_top 인스턴스
    UART_top UART (
        .clk(clk),
        .rst(rst),
        .datain_ext(data),
        .dataout_ext(),
        .new_in(new),
        .new_out(),
        .error(error),
        .RxD(RxD),
        .TxD(TxD)
    );

endmodule
