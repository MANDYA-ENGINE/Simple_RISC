`timescale 1ns / 1ps

module MA_tb;
    // Inputs
    reg Clk;
    reg reset;
    reg [31:0] aluResult;   // Memory address from ALU
    reg [31:0] op2;         // Data to store
    reg isLd;               // Load enable
    reg isSt;               // Store enable
    
    // Outputs
    wire [31:0] ldResult;   // Loaded data
    
    // Instantiate the Unit Under Test (UUT)
    MA uut (
        .Clk(Clk),
        .reset(reset),
        .aluResult(aluResult),
        .op2(op2),
        .isLd(isLd),
        .isSt(isSt),
        .ldResult(ldResult)
    );
    
    // Clock generation
    always #5 Clk = ~Clk;
    
    // Waveform dump
    initial begin
        $dumpfile("ma_wave.vcd");
        $dumpvars(0, MA_tb);
    end
    
    // Test Sequence
    initial begin
        // Initialize Inputs
        Clk = 0;
        reset = 1;
        aluResult = 0;
        op2 = 0;
        isLd = 0;
        isSt = 0;
        
        // Deassert reset after a delay
        #20 reset = 0;
        
        // Wait for reset to complete
        #10;
        
        // Test Case 1: Store word at address 0x0000_0000
        $display("\nTest Case 1: Store word at address 0x0000_0000");
        aluResult = 32'h0000_0000;
        op2 = 32'h1234_5678;
        isSt = 1;
        #10;
        isSt = 0;
        #10;
        $display("Time: %0t", $time);
        $display("Stored 0x%h at address 0x%h", op2, aluResult);
        
        // Test Case 2: Load word from address 0x0000_0000
        $display("\nTest Case 2: Load word from address 0x0000_0000");
        aluResult = 32'h0000_0000;
        isLd = 1;
        #10;
        isLd = 0;
        #10;
        $display("Time: %0t", $time);
        $display("Loaded 0x%h from address 0x%h", ldResult, aluResult);
        
        // Test Case 3: Store word at address 0x0000_0004
        $display("\nTest Case 3: Store word at address 0x0000_0004");
        aluResult = 32'h0000_0004;
        op2 = 32'hDEAD_BEEF;
        isSt = 1;
        #10;
        isSt = 0;
        #10;
        $display("Time: %0t", $time);
        $display("Stored 0x%h at address 0x%h", op2, aluResult);
        
        // Test Case 4: Load word from address 0x0000_0004
        $display("\nTest Case 4: Load word from address 0x0000_0004");
        aluResult = 32'h0000_0004;
        isLd = 1;
        #10;
        isLd = 0;
        #10;
        $display("Time: %0t", $time);
        $display("Loaded 0x%h from address 0x%h", ldResult, aluResult);
        
        // Test Case 5: Store word at non-aligned address (should still work)
        $display("\nTest Case 5: Store word at non-aligned address");
        aluResult = 32'h0000_0001;
        op2 = 32'hAABB_CCDD;
        isSt = 1;
        #10;
        isSt = 0;
        #10;
        $display("Time: %0t", $time);
        $display("Stored 0x%h at address 0x%h", op2, aluResult);
        
        // Test Case 6: Load word from non-aligned address
        $display("\nTest Case 6: Load word from non-aligned address");
        aluResult = 32'h0000_0001;
        isLd = 1;
        #10;
        isLd = 0;
        #10;
        $display("Time: %0t", $time);
        $display("Loaded 0x%h from address 0x%h", ldResult, aluResult);
        
        // Test Case 7: Store multiple words
        $display("\nTest Case 7: Store multiple words");
        aluResult = 32'h0000_0008;
        op2 = 32'h1111_1111;
        isSt = 1;
        #10;
        isSt = 0;
        #10;
        
        aluResult = 32'h0000_000C;
        op2 = 32'h2222_2222;
        isSt = 1;
        #10;
        isSt = 0;
        #10;
        
        aluResult = 32'h0000_0010;
        op2 = 32'h3333_3333;
        isSt = 1;
        #10;
        isSt = 0;
        #10;
        
        // Test Case 8: Load multiple words
        $display("\nTest Case 8: Load multiple words");
        aluResult = 32'h0000_0008;
        isLd = 1;
        #10;
        isLd = 0;
        #10;
        $display("Loaded from 0x0000_0008: 0x%h", ldResult);
        
        aluResult = 32'h0000_000C;
        isLd = 1;
        #10;
        isLd = 0;
        #10;
        $display("Loaded from 0x0000_000C: 0x%h", ldResult);
        
        aluResult = 32'h0000_0010;
        isLd = 1;
        #10;
        isLd = 0;
        #10;
        $display("Loaded from 0x0000_0010: 0x%h", ldResult);
        
        // Test Case 9: Verify control signals are mutually exclusive
        $display("\nTest Case 9: Verify control signals are mutually exclusive");
        aluResult = 32'h0000_0014;
        op2 = 32'h4444_4444;
        isLd = 1;
        isSt = 1;
        #10;
        isLd = 0;
        isSt = 0;
        #10;
        $display("Time: %0t", $time);
        $display("Both isLd and isSt were high - check waveform for behavior");
        
        // End simulation
        #20;
        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end
    
    // Monitor changes
    always @(posedge Clk) begin
        $display("Time: %0t", $time);
        $display("Inputs: aluResult=0x%h, op2=0x%h, isLd=%b, isSt=%b", 
                 aluResult, op2, isLd, isSt);
        $display("Output: ldResult=0x%h", ldResult);
        $display("----------------------------------------");
    end
    
endmodule