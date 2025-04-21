`timescale 1ns / 1ps

module OF(
    input isRet, isSt,
    input [31:0] Instruction,
    input [31:0] pc_current,
    input [31:0] ra,  // Return address register input
    input [31:0] reg_data1, reg_data2,  // Register file read data
    output reg [4:0] opcode,
    output reg I,
    output reg signed [31:0] immx, branchTarget, op1, op2,
    output reg [3:0] Rd,
    output reg [3:0] reg_addr1, reg_addr2  // Register file read addresses
);

reg signed [15:0] Imm_temp;
reg signed [26:0] branch_temp;
reg [28:0] shifted_branch;

always @(*) begin
    // Extract instruction fields
    opcode = Instruction[31:27];  
    I = Instruction[26];
    Rd = Instruction[25:22];
    branch_temp = Instruction[26:0];
    Imm_temp = Instruction[15:0]; 
    
    // Handle immediate value and branch target calculation
    if (I == 1) begin
        // Immediate value extension based on modifier
        if (Instruction[17:16] == 2'b00) begin
            immx = {{16{Imm_temp[15]}}, Imm_temp};  // Sign extension
        end
        else if (Instruction[17:16] == 2'b01) begin
            immx = {16'b0, Imm_temp};  // Zero extension
        end
        else if (Instruction[17:16] == 2'b10) begin
            immx = {Imm_temp, 16'b0};  // Left shift by 16
        end
        
        // Calculate branch target (PC-relative)
        shifted_branch = branch_temp << 2;  // 29-bit result
        branchTarget = {{3{shifted_branch[28]}}, shifted_branch} + pc_current;
    end
    
    // Register selection logic
    if (isRet == 1) begin
        reg_addr1 = 4'b1111;  // Select ra register
    end
    else begin
        reg_addr1 = Instruction[22:19];  // Select rs1
    end
    
    if (isSt == 1) begin
        reg_addr2 = Instruction[26:23];  // Select rd for store
    end
    else begin
        reg_addr2 = Instruction[18:15];  // Select rs2
    end
    
    // Get register values
    op1 = reg_data1;
    op2 = reg_data2;
end

endmodule