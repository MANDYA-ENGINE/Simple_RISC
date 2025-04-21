`timescale 1ns / 1ps

module EX(
    input [31:0] branchTarget,
    input [31:0] op1,op2,
    input isRet,
    input isBeq,
    input isBgt,
    input isUBranch,
    input [1:0] Flag,
    output reg isBranchTaken,
    output reg [31:0] branchPC
    );
    
reg w1, w2;

always @(*) begin
    isBranchTaken = 0;
    if (isRet == 1) begin
        branchPC = op1;
    end
    else begin
        branchPC = branchTarget;
    end
    
    w1 = isBgt && Flag[0]; // Flags[0] -> flags.GT 
    w2 = isBeq && Flag[1]; // Flags[1] -> flags.E
    isBranchTaken = w1 || w2 || isUBranch ;
end
    
endmodule
