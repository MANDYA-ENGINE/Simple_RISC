`timescale 1ns / 1ps

module Simple_RISC_Processor_tb;

    reg Clk;
    reg reset;

    // Wires to observe internal states
    wire [31:0] Instruction;
    wire [31:0] pc_current;
    wire [31:0] aluResult;
    wire [31:0] ldResult;
    wire [31:0] op1, op2, immx;
    wire isWb, isLd, isSt, isBranchTaken;
    wire [1:0] Flag;

    // Instantiate the DUT (Device Under Test)
    Simple_RISC_Processor dut (
        .Clk(Clk),
        .reset(reset),
        .Instruction(Instruction),
        .pc_current(pc_current),
        .aluResult(aluResult),
        .ldResult(ldResult),
        .op1(op1),
        .op2(op2),
        .immx(immx),
        .isWb(isWb),
        .isLd(isLd),
        .isSt(isSt),
        .isBranchTaken(isBranchTaken),
        .Flag(Flag)
    );

    // Clock generation
    always #5 Clk = ~Clk;  // 10ns period clock

    initial begin
        // Dump waveform
        $dumpfile("Simple_RISC_Processor_waveform.vcd");
        $dumpvars(0, Simple_RISC_Processor_tb);

        // Initial setup
        Clk = 0;
        reset = 1;

        #10;
        reset = 0;

        // Run for several cycles
        repeat (30) begin
            #10;
            $display("Time: %0t | PC: %h | Inst: %h | ALU: %h | LD: %h | OP1: %h | OP2: %h | IMM: %h | WB: %b | LD: %b | ST: %b | BR: %b | Flags: %b",
                     $time, pc_current, Instruction, aluResult, ldResult, op1, op2, immx, isWb, isLd, isSt, isBranchTaken, Flag);
        end

        $finish;
    end

endmodule
