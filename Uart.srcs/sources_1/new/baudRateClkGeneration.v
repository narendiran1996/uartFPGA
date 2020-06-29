`timescale 1ns / 1ps

module baudRateClkGeneration(input clk, input rst, input startClkGeneration, output clkGenerationDone, output midPulse);

parameter baudRate = 9600;
parameter countMax = 1000;
reg [13:0]count;
always@(posedge clk)
    begin
        if((rst==1) || ((count == countMax)))
            begin
                count <= 0;
            end
        else
            begin
                if((count < countMax) && (startClkGeneration==1))
                    begin
                        count <= count + 1;
                    end
            end
    end

assign clkGenerationDone = (count == countMax);
assign midPulse = (count == (countMax>>1));
endmodule
