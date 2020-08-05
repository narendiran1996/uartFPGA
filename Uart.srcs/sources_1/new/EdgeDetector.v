`timescale 1ns / 1ps

module EdgeDetector#(parameter POSedge0_NEGedge1 = 0)(input clk, input signalToDetect, output signalEdge);

reg signalFF1, signalFF2;

always@(posedge clk)
    begin
        signalFF1 <= signalToDetect;
        signalFF2 <= signalFF1;
    end

assign signalEdge = (POSedge0_NEGedge1 == 0) ? (signalFF1 && ~signalFF2) : (~signalFF1 && signalFF2); 
endmodule