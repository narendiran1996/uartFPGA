`timescale 1ns / 1ps
module uartTester();

reg clk, rst, txStart;
reg [7:0]dataIn;

wire txDone, receiveDone;
wire [7:0]dataOut;

wire tx_rx;

uartTransmitter UartTX(.clk(clk), .rst(rst), .dataIn(dataIn), .txStart(txStart),
                       .txSignal(tx_rx), .txDone(txDone));
                       
uartReceiver UartRX(.clk(clk), .rst(rst), .rxSignal(tx_rx), .dataOut(dataOut), .receiveDone(receiveDone));

initial
    begin
        clk = 0;
        rst = 1;
        txStart = 0;
        dataIn = 8'haa;
    end

always
    begin
    #5 clk = ~clk;
    end

initial
    begin
        #100 rst = 0;
        #100 txStart = 1;
    end
endmodule
