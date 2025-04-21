`timescale 1ns / 1ps

module CU_tb;

    // Inputs
    reg [4:0] opcode;
    reg I;

    // Outputs
    wire [14:0] aluSignals;
    wire isRet;
    wire isSt;
    wire isWb;
    wire isBeq;
    wire isBgt;
    wire isUBranch;
    wire isLd;
    wire isCall;
    wire isImmediate;

    // Instantiate the Control Unit
    CU uut (
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
    );

    // Task to display results
    task display_outputs;
        begin
            $display("Time: %0t | Opcode: %b | I: %b", $time, opcode, I);
            $display("aluSignals: %b", aluSignals);
            $display("isAdd:%b isSub:%b isMul:%b isDiv:%b isMod:%b isCmp:%b", 
                    aluSignals[0], aluSignals[1], aluSignals[2], aluSignals[3], aluSignals[4], aluSignals[5]);
            $display("isAnd:%b isOr:%b isNot:%b isMov:%b", 
                    aluSignals[6], aluSignals[7], aluSignals[8], aluSignals[9]);
            $display("isLsl:%b isLsr:%b isAsr:%b", 
                    aluSignals[10], aluSignals[11], aluSignals[12]);
            $display("isLd:%b isSt:%b", isLd, isSt);
            $display("isBeq:%b isBgt:%b isUBranch:%b", isBeq, isBgt, isUBranch);
            $display("isCall:%b isRet:%b isImmediate:%b isWb:%b",
         isCall, isRet, isImmediate, isWb);

        end
    endtask

    // Stimulus block
    initial begin
        $dumpfile("CU_tb.vcd");
        $dumpvars(0, CU_tb);

        I = 0;

        // Test each opcode
        opcode = 5'b00000; #10; display_outputs; // ADD
        opcode = 5'b00001; #10; display_outputs; // SUB
        opcode = 5'b00010; #10; display_outputs; // MUL
        opcode = 5'b00101; #10; display_outputs; // CMP (no WB)
        opcode = 5'b01101; #10; display_outputs; // NOP (no op, no WB)
        opcode = 5'b01110; #10; display_outputs; // LD
        opcode = 5'b01111; #10; display_outputs; // ST
        opcode = 5'b10000; #10; display_outputs; // BEQ
        opcode = 5'b10010; #10; display_outputs; // UBranch
        opcode = 5'b10011; #10; display_outputs; // CALL
        opcode = 5'b10100; #10; display_outputs; // RET

        // Test Immediate variant
        I = 1;
        opcode = 5'b00000; #10; display_outputs; // ADD (Immediate)
        opcode = 5'b01110; #10; display_outputs; // LD (Immediate)

        $finish;
    end
endmodule
