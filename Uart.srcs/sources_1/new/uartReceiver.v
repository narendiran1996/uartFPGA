`timescale 1ns / 1ps


module uartReceiver(input clk, rst, rxSignal, output reg [7:0]dataOut, output reg receiveDone);

wire canReceive, countDone, midPulse;
reg startCount;
reg [2:0]bitIndx;


parameter IDLE = 2'd0, START = 2'd1, RXDATA = 2'd2, STOP = 2'd3;
reg [1:0]currentState, nextState;

edgeDetector #(.posEdge_negEdge(1))rxSignalNegedgeDetector(clk, rxSignal, canReceive);
baudRateClkGeneration #(.countMax(10416))baudRate9600(clk, rst, startCount, countDone, midPulse);



always@(posedge clk)
    begin
        if(rst)
            currentState <= IDLE;
        else
            currentState <= nextState;
    end
    
always@(posedge clk)
    begin
        if(rst == 1 || currentState == IDLE)
            begin
                bitIndx <= 0;
            end
        else
            begin
                if(currentState == RXDATA && countDone == 1)
                    begin
                        bitIndx <= bitIndx + 1;
                    end
            end
    end
always@(posedge clk)
    begin
        if(rst == 1)
            dataOut <= 0;
        if(midPulse == 1 && currentState == RXDATA )
            dataOut[bitIndx] <= rxSignal;
    end

always@(currentState, canReceive, countDone, bitIndx)
    begin
        receiveDone = 0;
        case(currentState)
            IDLE :
                begin
                    startCount = 0;
                    if(canReceive == 1)
                        nextState = START;
                    else
                        nextState = IDLE;
                end
            START:
                begin
                    if(countDone == 1)
                        begin
                            startCount = 0;
                            nextState = RXDATA;
                        end
                    else
                        begin
                            startCount = 1;
                            nextState = START;
                        end
                end
            RXDATA:
                begin
                    if(countDone == 1)
                        begin
                            if(bitIndx == 7)
                                begin
                                    startCount = 0;
                                    nextState = STOP;
                                end
                            else
                                begin
                                    startCount = 1;
                                    nextState = RXDATA;
                                end
                            
                        end
                    else
                        begin
                            startCount = 1;
                            nextState = RXDATA;
                        end
                end
            STOP:
                begin
                    if(countDone == 1)
                        begin
                            startCount = 0;
                            nextState = IDLE;
                            receiveDone = 1;
                        end
                    else
                        begin
                            startCount = 1;
                            nextState = STOP;
                            receiveDone = 0;
                        end
                end
            default:
                begin
                    startCount = 1'bx;
                    nextState = 2'bxx;
                    receiveDone = 1'bx;
                end
        endcase
    end
  
endmodule
