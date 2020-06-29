`timescale 1ns / 1ps

module edgeDetector#(parameter posEdge_negEdge = 1)(input clk, input signalToDetect, output signalEdge);

reg signalFF1, signalFF2;

always@(posedge clk)
    begin
        signalFF1 <= signalToDetect;
        signalFF2 <= signalFF1;
    end

assign signalEdge = (posEdge_negEdge == 0) ? (signalFF1 && ~signalFF2) : (~signalFF1 && signalFF2); 
endmodule
