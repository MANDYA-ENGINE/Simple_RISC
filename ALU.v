`timescale 1ns / 1ps
module ALU(
    input signed [31:0] op1,         // Operand 1
    input signed [31:0] op2,         // Operand 2
    input signed [31:0] immx,        // Immediate value
    input isImmediate,        // Immediate bit (I bit)
    input [14:0]aluSignals,
    output reg signed [31:0] aluResult, // Output of the ALU
    output reg [1:0] Flag
);

reg signed [31:0] opB;

wire isAdd = aluSignals[0];
wire isSub = aluSignals[1];
wire isMul = aluSignals[2];
wire isDiv = aluSignals[3];
wire isMod = aluSignals[4];
wire isCmp = aluSignals[5];
wire isAnd = aluSignals[6];
wire isOr = aluSignals[7];
wire isNot = aluSignals[8];
wire isMov = aluSignals[9];
wire isLsl = aluSignals[10];
wire isLsr = aluSignals[11];
wire isAsr = aluSignals[12];
wire isLd = aluSignals[13];
wire isSt = aluSignals[14];


always @(*) begin
    opB = (isImmediate)? immx:op2;
    
    aluResult = 32'b0;
    Flag[0] = 1'b0; // GT flag
    Flag[1] = 1'b0; // E flag
    
    if (isAdd)
        aluResult = op1 + opB;
    else if (isSub)
        aluResult = op1 - opB;
    else if (isMul) 
        aluResult = op1*opB;
    else if (isDiv) begin
        if (opB == 0) begin
            aluResult = 32'hFFFFFFFF; // Handle division by zero
        end else begin
            aluResult = op1/opB;
        end
    end   
    else if (isMod) begin
        if (opB == 0) begin
            aluResult = 32'hFFFFFFFF; // Handle modulo by zero
        end else begin
            aluResult = op1%opB;
        end
    end
    else if (isCmp)begin 
        if (op1 == opB) begin
            aluResult = 32'b0;
            Flag[0] = 1'b0; // GT flag
            Flag[1] = 1'b1; // E flag
        end
        else if (op1 > opB) begin
            aluResult = 32'b1;
            Flag[0] = 1'b1; 
            Flag[1] = 1'b0;
        end else begin
            aluResult = -32'b1; // or any other indicator
            Flag[0] = 1'b0;
            Flag[1] = 1'b0;
        end
    end
    else if (isAnd) 
        aluResult = op1&opB;
    else if (isNot) 
        aluResult = ~opB;
    else if (isMov) 
        aluResult = opB;
    else if (isLsl) 
        aluResult = op1<<opB;
    else if (isLsr) 
        aluResult = op1>>opB;
    else if (isAsr) 
        aluResult = op1>>>opB;
    else if (isLd) 
        aluResult = op1 + opB;
    else if (isSt) 
        aluResult = op1 + opB;
  
end  
endmodule