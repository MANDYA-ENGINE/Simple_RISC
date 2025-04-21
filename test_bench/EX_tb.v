`timescale 1ns / 1ps

module EX_tb;
    // Inputs
    reg [31:0] branchTarget;
    reg [31:0] op1, op2;
    reg isRet;
    reg isBeq;
    reg isBgt;
    reg isUBranch;
    reg [1:0] Flag;
    
    // Outputs
    wire isBranchTaken;
    wire [31:0] branchPC;
    
    // Instantiate the Unit Under Test (UUT)
    EX uut (
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
    
    // Test Sequence
    initial begin
        // Initialize Inputs
        branchTarget = 0;
        op1 = 0;
        op2 = 0;
        isRet = 0;
        isBeq = 0;
        isBgt = 0;
        isUBranch = 0;
        Flag = 2'b00;
        
        // Test Case 1: Return operation
        $display("\nTest Case 1: Return operation");
        op1 = 32'h0000_1000;  // Return address
        isRet = 1;
        #10;
        $display("Time: %0t", $time);
        $display("Return address: 0x%h", op1);
        $display("Branch PC: 0x%h", branchPC);
        $display("Branch Taken: %b", isBranchTaken);
        isRet = 0;
        #10;
        
        // Test Case 2: Unconditional branch
        $display("\nTest Case 2: Unconditional branch");
        branchTarget = 32'h0000_2000;
        isUBranch = 1;
        #10;
        $display("Time: %0t", $time);
        $display("Branch target: 0x%h", branchTarget);
        $display("Branch PC: 0x%h", branchPC);
        $display("Branch Taken: %b", isBranchTaken);
        isUBranch = 0;
        #10;
        
        // Test Case 3: Branch if equal (Flag[1] = 1)
        $display("\nTest Case 3: Branch if equal (Flag[1] = 1)");
        branchTarget = 32'h0000_3000;
        isBeq = 1;
        Flag = 2'b10;  // Set equal flag
        #10;
        $display("Time: %0t", $time);
        $display("Branch target: 0x%h", branchTarget);
        $display("Branch PC: 0x%h", branchPC);
        $display("Branch Taken: %b", isBranchTaken);
        isBeq = 0;
        #10;
        
        // Test Case 4: Branch if equal (Flag[1] = 0)
        $display("\nTest Case 4: Branch if equal (Flag[1] = 0)");
        branchTarget = 32'h0000_4000;
        isBeq = 1;
        Flag = 2'b00;  // Clear equal flag
        #10;
        $display("Time: %0t", $time);
        $display("Branch target: 0x%h", branchTarget);
        $display("Branch PC: 0x%h", branchPC);
        $display("Branch Taken: %b", isBranchTaken);
        isBeq = 0;
        #10;
        
        // Test Case 5: Branch if greater than (Flag[0] = 1)
        $display("\nTest Case 5: Branch if greater than (Flag[0] = 1)");
        branchTarget = 32'h0000_5000;
        isBgt = 1;
        Flag = 2'b01;  // Set greater than flag
        #10;
        $display("Time: %0t", $time);
        $display("Branch target: 0x%h", branchTarget);
        $display("Branch PC: 0x%h", branchPC);
        $display("Branch Taken: %b", isBranchTaken);
        isBgt = 0;
        #10;
        
        // Test Case 6: Branch if greater than (Flag[0] = 0)
        $display("\nTest Case 6: Branch if greater than (Flag[0] = 0)");
        branchTarget = 32'h0000_6000;
        isBgt = 1;
        Flag = 2'b00;  // Clear greater than flag
        #10;
        $display("Time: %0t", $time);
        $display("Branch target: 0x%h", branchTarget);
        $display("Branch PC: 0x%h", branchPC);
        $display("Branch Taken: %b", isBranchTaken);
        isBgt = 0;
        #10;
        
        // Test Case 7: Multiple conditions (both flags set)
        $display("\nTest Case 7: Multiple conditions (both flags set)");
        branchTarget = 32'h0000_7000;
        isBeq = 1;
        isBgt = 1;
        Flag = 2'b11;  // Set both flags
        #10;
        $display("Time: %0t", $time);
        $display("Branch target: 0x%h", branchTarget);
        $display("Branch PC: 0x%h", branchPC);
        $display("Branch Taken: %b", isBranchTaken);
        isBeq = 0;
        isBgt = 0;
        #10;
        
        // Test Case 8: Return with branch conditions
        $display("\nTest Case 8: Return with branch conditions");
        op1 = 32'h0000_8000;  // Return address
        isRet = 1;
        isBeq = 1;
        isBgt = 1;
        Flag = 2'b11;
        #10;
        $display("Time: %0t", $time);
        $display("Return address: 0x%h", op1);
        $display("Branch PC: 0x%h", branchPC);
        $display("Branch Taken: %b", isBranchTaken);
        isRet = 0;
        isBeq = 0;
        isBgt = 0;
        #10;
        
        // End simulation
        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end
    
    // Monitor changes
    always @(*) begin
        $display("Time: %0t", $time);
        $display("Inputs: branchTarget=0x%h, Op1=0x%h, Op2=0x%h", 
                 branchTarget, op1, op2);
        $display("Control: isRet=%b, isBeq=%b, isBgt=%b, isUBranch=%b, Flag=%b", 
                 isRet, isBeq, isBgt, isUBranch, Flag);
        $display("Outputs: branchPC=0x%h, isBranchTaken=%b", 
                 branchPC, isBranchTaken);
        $display("----------------------------------------");
    end
    
endmodule