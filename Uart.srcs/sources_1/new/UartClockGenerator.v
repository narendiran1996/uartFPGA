`timescale 1ns / 1ps

module UartClockGenerator
    (input clk, input rst, input startClkGeneration, input [1:0]baudSelector,
     output clkGeneratedOutput, output midSignal);

// 125000000/baudRate
reg [31:0]countMax;
always@(baudSelector)
    begin
        case(baudSelector)
            2'd0: countMax = 13020;
            2'd1: countMax = 6510;
            2'd2: countMax = 2170;
            2'd3: countMax = 1085;
        endcase
    end


integer count;
reg startCount;

always@(posedge clk)
    begin
        if((rst==1) || ((count == countMax)))
            begin
                startCount <= 0;
            end
        else
            begin
                if(startClkGeneration == 1 && startCount == 0)
                    startCount <= 1;
            end
       end            
always@(posedge clk)
    begin
        if((rst==1) || ((count == countMax)))
            begin
                count <= 0;
            end
        else
            begin
                if((count < countMax) && (startCount==1))
                    begin
                        count <= count + 1;
                    end
            end
    end
assign clkGeneratedOutput = (count == countMax);
assign midSignal =  (count == (countMax>>1));
endmodule