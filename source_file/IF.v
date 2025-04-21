`timescale 1ns / 1ps
module IF(
    input Clk,
    input reset,
    input isBranchTaken,
    input [31:0] branchPC,
    output reg [31:0] pc_current,
    output reg [31:0] Instruction
);

reg [31:0] PC; // Internal PC register
reg [7:0] InstructionMemory [0:1023]; // 8-bit wide, byte addressable instruction memory

// Load instruction memory from hex file
initial begin
    $readmemh("input.hex", InstructionMemory);
end

always @(posedge Clk) begin
    if (reset) begin
        PC <= 0;
        pc_current <= 0;
        Instruction <= 0;
    end else begin
        // Set current PC
        pc_current <= PC;

        // Fetch 32-bit instruction from memory (little endian)
        Instruction[7:0]   <= InstructionMemory[PC];
        Instruction[15:8]  <= InstructionMemory[PC + 1];
        Instruction[23:16] <= InstructionMemory[PC + 2];
        Instruction[31:24] <= InstructionMemory[PC + 3];

        // Update PC for next instruction
        if (isBranchTaken)
            PC <= branchPC;
        else
            PC <= PC + 4;
    end
end

endmodule
