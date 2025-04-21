`timescale 1ns / 1ps

module CU(
    input [4:0] opcode,
    input I,
    output reg [14:0] aluSignals,
    output reg isRet,
    output reg isSt,
    output reg isWb,
    output reg isBeq,
    output reg isBgt,
    output reg isUBranch,
    output reg isLd,
    output reg isCall,
    output reg isImmediate  
);

    reg isAdd;
    reg isSub;
    reg isMul;
    reg isDiv;
    reg isMod;
    reg isCmp;
    reg isAnd;
    reg isOr;
    reg isNot;
    reg isMov;
    reg isLsl;
    reg isLsr;
    reg isAsr;


    always @(*) begin
        // Initialize all flags to 0
        isAdd = 0;
        isSub = 0;
        isMul = 0;
        isDiv = 0;
        isMod = 0;
        isCmp = 0;
        isAnd = 0;
        isOr  = 0;
        isNot = 0;
        isMov = 0;
        isLsl = 0;
        isLsr = 0;
        isAsr = 0;
        isLd  = 0;
        isSt  = 0;
        isBeq = 0;
        isBgt = 0;
        isUBranch = 0;
        isImmediate = 0;
        isWb = 1;
        isCall = 0;
        isRet = 0;

        case (opcode)
            5'b00000: isAdd = 1;
            5'b00001: isSub = 1;
            5'b00010: isMul = 1;
            5'b00011: isDiv = 1;
            5'b00100: isMod = 1;
            5'b00101: begin
                isCmp = 1;
                isWb = 0;
            end
            5'b00110: isAnd = 1;
            5'b00111: isOr  = 1;
            5'b01000: isNot = 1;
            5'b01001: isMov = 1;
            5'b01010: isLsl = 1;
            5'b01011: isLsr = 1;
            5'b01100: isAsr = 1;
            5'b01101: isWb = 0;    // nop
            5'b01110: isLd  = 1;
            5'b01111: begin
                isSt = 1;
                isWb = 0;
            end
            5'b10000: begin
                isBeq = 1;
                isWb = 0;
            end
            5'b10001:  begin
                isBgt = 1;
                isWb = 0;
            end
            5'b10010: begin
                isUBranch = 1;
                isWb = 0;
                
            end
            5'b10011: begin 
                isUBranch = 1;
                isCall = 1;
            end
            5'b10100: begin
                isUBranch = 1;
                isRet = 1;
                isWb = 0;
            end
            
            default: ; // Do nothing for unrecognized opcodes
        endcase
        
        if (I == 1'b1) begin
            isImmediate = I;
        end
        
        // Pack all control signals into output in the correct order
        aluSignals = {
            isSt,    // bit 14
            isLd,    // bit 13
            isAsr,   // bit 12
            isLsr,   // bit 11
            isLsl,   // bit 10
            isMov,   // bit 9
            isNot,   // bit 8
            isOr,    // bit 7
            isAnd,   // bit 6
            isCmp,   // bit 5
            isMod,   // bit 4
            isDiv,   // bit 3
            isMul,   // bit 2
            isSub,   // bit 1
            isAdd    // bit 0
        };
    end
endmodule