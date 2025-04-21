`timescale 1ns / 1ps
module Simple_RISC_Processor(
    input wire Clk,
    input wire reset,

    // Debug outputs for waveform
    output wire [31:0] Instruction,
    output wire [31:0] pc_current,
    output wire [31:0] aluResult,
    output wire [31:0] ldResult,
    output wire [31:0] op1,
    output wire [31:0] op2,
    output wire [31:0] immx,
    output wire isWb,
    output wire isLd,
    output wire isSt,
    output wire isBranchTaken,
    output wire [1:0] Flag
);

    wire [31:0] branchPC;
    wire isBeq, isBgt, isUBranch;
    wire isRet, isCall;
    wire isImmediate;
    wire [4:0] opcode; 
    wire [31:0] ra;
    wire [31:0] reg_data1, reg_data2;
    wire I;
    wire [31:0] branchTarget;
    wire [3:0] reg_addr1, reg_addr2;
    wire [3:0] Rd;
    wire [14:0] aluSignals;

    IF u_instruction_fetch(
        .Clk(Clk),
        .reset(reset),
        .isBranchTaken(isBranchTaken),
        .branchPC(branchPC),
        .pc_current(pc_current),
        .Instruction(Instruction)
    );

    OF u_operand_fetch(
        .isRet(isRet),
        .isSt(isSt),
        .Instruction(Instruction),
        .pc_current(pc_current),
        .ra(ra),
        .reg_data1(reg_data1),
        .reg_data2(reg_data2),
        .opcode(opcode),
        .I(I),
        .immx(immx),
        .branchTarget(branchTarget),
        .op1(op1),
        .op2(op2),
        .Rd(Rd),
        .reg_addr1(reg_addr1),
        .reg_addr2(reg_addr2)
    );

    ALU u_alu(
        .op1(op1),
        .op2(op2),
        .immx(immx),
        .isImmediate(isImmediate),
        .aluSignals(aluSignals),
        .aluResult(aluResult),
        .Flag(Flag)
    );

    EX u_execute(
        .branchTarget(branchTarget),
        .op1(op1),
        .op2(op2),
        .isRet(isRet),
        .isBeq(isBeq),
        .isBgt(isBgt),
        .isUBranch(isUBranch),
        .Flag(Flag),
        .isBranchTaken(isBranchTaken),
        .branchPC(branchPC)
    );

    MA u_memory_access(
        .Clk(Clk),
        .reset(reset),
        .aluResult(aluResult),
        .op2(op2),
        .isLd(isLd),
        .isSt(isSt),
        .ldResult(ldResult)
    );

    RW u_register_file(
        .Clk(Clk),
        .reset(reset),
        .isWb(isWb),
        .isCall(isCall),
        .isLd(isLd),
        .Rd(Rd),
        .aluResult(aluResult),
        .ldResult(ldResult),
        .pc_current(pc_current),
        .reg_addr1(reg_addr1),
        .reg_addr2(reg_addr2),
        .reg_data1(reg_data1),
        .reg_data2(reg_data2)
    );

    CU u_control_unit(
        .opcode(opcode),
        .I(I),
        .aluSignals(aluSignals),
        .isRet(isRet),
        .isSt(isSt),
        .isWb(isWb),
        .isBeq(isBeq),
        .isBgt(isBgt),
        .isUBranch(isUBranch),
        .isLd(isLd),
        .isCall(isCall),
        .isImmediate(isImmediate)
        // isBranchTaken intentionally removed
    );

endmodule
