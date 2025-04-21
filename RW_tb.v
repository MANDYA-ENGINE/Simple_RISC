`timescale 1ns / 1ps

module RW_tb;

    // Inputs
    reg Clk;
    reg reset;
    reg isWb;
    reg isCall;
    reg isLd;
    reg [3:0] Rd;
    reg [31:0] aluResult;
    reg [31:0] ldResult;
    reg [31:0] pc_current;
    reg [3:0] reg_addr1, reg_addr2;

    // Outputs
    wire [31:0] reg_data1;
    wire [31:0] reg_data2;

    // Instantiate the RegisterFile module
    RW uut (
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

    // Clock generation
    always #5 Clk = ~Clk;  // 10 ns clock period

    initial begin
        // Waveform dump
        $dumpfile("RW_tb.vcd");
        $dumpvars(0, RW_tb);

        // Initial values
        Clk = 0;
        reset = 1;
        isWb = 0;
        isCall = 0;
        isLd = 0;
        Rd = 0;
        aluResult = 0;
        ldResult = 0;
        pc_current = 0;
        reg_addr1 = 0;
        reg_addr2 = 0;

        // Apply reset
        #10;
        reset = 0;

        // --- Write aluResult to R1 ---
        isWb = 1;
        isCall = 0;
        isLd = 0;
        Rd = 4'd1;
        aluResult = 32'hDEADBEEF;
        #10;

        // --- Write ldResult to R2 ---
        isWb = 1;
        isLd = 1;
        isCall = 0;
        Rd = 4'd2;
        ldResult = 32'hBEEFCAFE;
        #10;

        // --- Write return address (pc + 4) to RA ---
        isWb = 1;
        isLd = 0;
        isCall = 1;
        Rd = 4'd0;  // Ignored
        pc_current = 32'h00001000;
        #10;

        // --- Read back values from R1, R2, RA ---
        isWb = 0;
        reg_addr1 = 4'd1;
        reg_addr2 = 4'd2;
        #5;
        $display("Read R1 = %h, R2 = %h", reg_data1, reg_data2);

        reg_addr1 = 4'd15;  // RA
        reg_addr2 = 4'd0;   // Some unused
        #5;
        $display("Read RA = %h", reg_data1);

        // Done
        #20;
        $finish;
    end

endmodule
