`timescale 1ns / 1ps

module ALU_tb;
    // Inputs
    reg signed [31:0] op1;
    reg signed [31:0] op2;
    reg signed [31:0] immx;
    reg isImmediate;
    reg [14:0] aluSignals;
    
    // Outputs
    wire signed [31:0] aluResult;
    wire [1:0] Flag;
    
    // Instantiate the Unit Under Test (UUT)
    ALU uut (
        .op1(op1),
        .op2(op2),
        .immx(immx),
        .isImmediate(isImmediate),
        .aluSignals(aluSignals),
        .aluResult(aluResult),
        .Flag(Flag)
    );
    
    // Waveform dump
    initial begin
        $dumpfile("alu_wave.vcd");
        $dumpvars(0, ALU_tb);
    end
    
    // Test Sequence
    initial begin
        // Initialize Inputs
        op1 = 0;
        op2 = 0;
        immx = 0;
        isImmediate = 0;
        aluSignals = 0;
        
        // Wait 100 ns for global reset to finish
        #100;
        
        // Test Case 1: Addition
        $display("\nTest Case 1: Addition");
        op1 = 32'h0000_0005;
        op2 = 32'h0000_0003;
        aluSignals = 15'b0000_0000_0000_0001; // isAdd
        #10;
        $display("Time: %0t", $time);
        $display("5 + 3 = %d", aluResult);
        
        // Test Case 2: Subtraction
        $display("\nTest Case 2: Subtraction");
        op1 = 32'h0000_0005;
        op2 = 32'h0000_0003;
        aluSignals = 15'b0000_0000_0000_0010; // isSub
        #10;
        $display("Time: %0t", $time);
        $display("5 - 3 = %d", aluResult);
        
        // Test Case 3: Multiplication
        $display("\nTest Case 3: Multiplication");
        op1 = 32'h0000_0005;
        op2 = 32'h0000_0003;
        aluSignals = 15'b0000_0000_0000_0100; // isMul
        #10;
        $display("Time: %0t", $time);
        $display("5 * 3 = %d", aluResult);
        
        // Test Case 4: Division
        $display("\nTest Case 4: Division");
        op1 = 32'h0000_000F;
        op2 = 32'h0000_0003;
        aluSignals = 15'b0000_0000_0000_1000; // isDiv
        #10;
        $display("Time: %0t", $time);
        $display("15 / 3 = %d", aluResult);
        
        // Test Case 5: Modulo
        $display("\nTest Case 5: Modulo");
        op1 = 32'h0000_000F;
        op2 = 32'h0000_0004;
        aluSignals = 15'b0000_0000_0001_0000; // isMod
        #10;
        $display("Time: %0t", $time);
        $display("15 %% 4 = %d", aluResult);
        
        // Test Case 6: Comparison
        $display("\nTest Case 6: Comparison");
        op1 = 32'h0000_0005;
        op2 = 32'h0000_0003;
        aluSignals = 15'b0000_0000_0010_0000; // isCmp
        #10;
        $display("Time: %0t", $time);
        $display("5 > 3: Result = %d, Flag = %b", aluResult, Flag);
        
        // Test Case 7: AND operation
        $display("\nTest Case 7: AND operation");
        op1 = 32'hF0F0_F0F0;
        op2 = 32'h0F0F_0F0F;
        aluSignals = 15'b0000_0000_0100_0000; // isAnd
        #10;
        $display("Time: %0t", $time);
        $display("0xF0F0F0F0 & 0x0F0F0F0F = %h", aluResult);
        
        // Test Case 8: OR operation
        $display("\nTest Case 8: OR operation");
        op1 = 32'hF0F0_F0F0;
        op2 = 32'h0F0F_0F0F;
        aluSignals = 15'b0000_0000_1000_0000; // isOr
        #10;
        $display("Time: %0t", $time);
        $display("0xF0F0F0F0 | 0x0F0F0F0F = %h", aluResult);
        
        // Test Case 9: NOT operation
        $display("\nTest Case 9: NOT operation");
        op2 = 32'hF0F0_F0F0;
        aluSignals = 15'b0000_0001_0000_0000; // isNot
        #10;
        $display("Time: %0t", $time);
        $display("~0xF0F0F0F0 = %h", aluResult);
        
        // Test Case 10: Move operation
        $display("\nTest Case 10: Move operation");
        op2 = 32'h1234_5678;
        aluSignals = 15'b0000_0010_0000_0000; // isMov
        #10;
        $display("Time: %0t", $time);
        $display("MOV 0x12345678 = %h", aluResult);
        
        // Test Case 11: Logical Shift Left
        $display("\nTest Case 11: Logical Shift Left");
        op1 = 32'h0000_0001;
        op2 = 32'h0000_0004;
        aluSignals = 15'b0000_0100_0000_0000; // isLsl
        #10;
        $display("Time: %0t", $time);
        $display("1 << 4 = %h", aluResult);
        
        // Test Case 12: Logical Shift Right
        $display("\nTest Case 12: Logical Shift Right");
        op1 = 32'h0000_0010;
        op2 = 32'h0000_0002;
        aluSignals = 15'b0000_1000_0000_0000; // isLsr
        #10;
        $display("Time: %0t", $time);
        $display("16 >> 2 = %h", aluResult);
        
        // Test Case 13: Arithmetic Shift Right
        $display("\nTest Case 13: Arithmetic Shift Right");
        op1 = 32'hF000_0000;
        op2 = 32'h0000_0004;
        aluSignals = 15'b0001_0000_0000_0000; // isAsr
        #10;
        $display("Time: %0t", $time);
        $display("0xF0000000 >>> 4 = %h", aluResult);
        
        // Test Case 14: Immediate Addition
        $display("\nTest Case 14: Immediate Addition");
        op1 = 32'h0000_0005;
        immx = 32'h0000_0003;
        isImmediate = 1;
        aluSignals = 15'b0000_0000_0000_0001; // isAdd
        #10;
        $display("Time: %0t", $time);
        $display("5 + 3 (immediate) = %d", aluResult);
        
        // Test Case 15: Load/Store Address Calculation
        $display("\nTest Case 15: Load/Store Address Calculation");
        op1 = 32'h0000_1000;
        op2 = 32'h0000_0020;
        aluSignals = 15'b0010_0000_0000_0000; // isLd/isSt
        #10;
        $display("Time: %0t", $time);
        $display("Base(0x1000) + Offset(0x20) = %h", aluResult);
        
        // End simulation
        #20;
        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end
    
    // Monitor changes
    always @(*) begin
        $display("Time: %0t", $time);
        $display("Inputs: op1=%h, op2=%h, Immx=%h, isImmediate=%b", op1, op2, immx, isImmediate);
        $display("ALU Signals: %b", aluSignals);
        $display("Outputs: Result=%h, Flag=%b", aluResult, Flag);
        $display("----------------------------------------");
    end
    
endmodule