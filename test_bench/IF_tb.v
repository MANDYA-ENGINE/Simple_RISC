`timescale 1ns / 1ps

module IF_tb;

    // Testbench signals
    reg Clk;
    reg reset;
    reg isBranchTaken;
    reg [31:0] branchPC;
    wire [31:0] pc_current;
    wire [31:0] Instruction;

    // Instantiate the DUT (Device Under Test)
    IF uut (
        .Clk(Clk),
        .reset(reset),
        .isBranchTaken(isBranchTaken),
        .branchPC(branchPC),
        .pc_current(pc_current),
        .Instruction(Instruction)
    );

    // Clock generation: 10ns period
    always #5 Clk = ~Clk;

    initial begin
        // Enable waveform dump
        $dumpfile("IF_waveform.vcd");  // Output file for GTKWave
        $dumpvars(0, IF_tb);           // Dump all variables in this testbench

        // Initialize inputs
        Clk = 0;
        reset = 1;
        isBranchTaken = 0;
        branchPC = 0;

        // Apply reset
        #10;
        reset = 0;

        // Fetch a few instructions normally
        repeat (4) begin
            #10;
            $display("Time: %0t | PC: %h | Instruction: %h", $time, pc_current, Instruction);
        end

        // Simulate branch
        isBranchTaken = 1;
        branchPC = 32'h00000010; // Jump to address 0x10
        #10;
        $display("Time: %0t | BRANCH TAKEN | PC: %h | Instruction: %h", $time, pc_current, Instruction);

        // Continue fetching normally after branch
        isBranchTaken = 0;
        repeat (2) begin
            #10;
            $display("Time: %0t | PC: %h | Instruction: %h", $time, pc_current, Instruction);
        end

        // Finish simulation
        $finish;
    end

endmodule
