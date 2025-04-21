`timescale 1ns / 1ps

module OF_tb;

    // Inputs
    reg isRet;
    reg isSt;
    reg [31:0] Instruction;
    reg [31:0] pc_current;
    reg [31:0] ra;
    reg [31:0] reg_data1;
    reg [31:0] reg_data2;

    // Outputs
    wire [4:0] opcode;
    wire I;
    wire signed [31:0] immx;
    wire signed [31:0] branchTarget;
    wire signed [31:0] op1;
    wire signed [31:0] op2;
    wire [3:0] Rd;
    wire [3:0] reg_addr1;
    wire [3:0] reg_addr2;

    // Instantiate the OF unit
    OF uut (
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

    initial begin
        // VCD dump for waveform viewing
        $dumpfile("OF_tb.vcd");
        $dumpvars(0, OF_tb);

        // Initial values
        isRet = 0;
        isSt = 0;
        Instruction = 32'b0;
        pc_current = 32'h1000;
        ra = 32'hDEAD0004;
        reg_data1 = 32'h11111111;
        reg_data2 = 32'h22222222;

        #10;

        // Test Case 1: Regular R-type instruction (no immediate)
        Instruction = 32'b00001_0_0001_0001_0000_0000_0000_0000;  // rs1=0001, rs2=0000, rd=0001
        isRet = 0;
        isSt = 0;
        reg_data1 = 32'h12345678;
        reg_data2 = 32'h87654321;
        #10;
        $display("=== R-type ===");
        $display("Opcode: %b, Rd: %d, Op1: %h, Op2: %h", opcode, Rd, op1, op2);

        // Test Case 2: I-type with sign extension
        Instruction = 32'b00010_1_0010_000000_0000000011111111; // Imm = 0x00FF, modifier=00 -> sign-extend
        isRet = 0;
        isSt = 0;
        reg_data1 = 32'hAAAAAAAA;
        #10;
        $display("=== I-type (sign-ext) ===");
        $display("immx: %h, Op1: %h, reg_addr1: %d", immx, op1, reg_addr1);

        // Test Case 3: I-type with zero extension
        Instruction = 32'b00010_1_0010_000001_0000000011111111; // modifier=01
        #10;
        $display("=== I-type (zero-ext) ===");
        $display("immx: %h", immx);

        // Test Case 4: I-type with left shift
        Instruction = 32'b00010_1_0010_000010_0000000011111111; // modifier=10
        #10;
        $display("=== I-type (shift-left) ===");
        $display("immx: %h", immx);

        // Test Case 5: isRet active
        isRet = 1;
        Instruction = 32'b00011_0_0011_0000_0000_0000_0000;
        ra = 32'hCAFEBABE;
        reg_data1 = ra;  // Should select reg[15]
        #10;
        $display("=== Ret Instruction ===");
        $display("Op1 (should be ra): %h, reg_addr1: %d", op1, reg_addr1);

        // Test Case 6: isSt active
        isRet = 0;
        isSt = 1;
        Instruction = 32'b00100_0_0100_0000_0000_0000_0000; // Store, so rs2 = Rd = bits 26:23
        reg_data2 = 32'h55555555;
        #10;
        $display("=== Store Instruction ===");
        $display("Op2 (store data): %h, reg_addr2: %d", op2, reg_addr2);

        #20;
        $finish;
    end

endmodule
