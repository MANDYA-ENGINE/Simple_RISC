`timescale 1ns / 1ps
module RW(
    input wire Clk,
    input wire reset,

    // Write-back inputs
    input wire isWb,
    input wire isCall,
    input wire isLd,
    input wire [3:0] Rd,
    input wire [31:0] aluResult,
    input wire [31:0] ldResult,
    input wire [31:0] pc_current,

    // Read inputs (from OF unit)
    input wire [3:0] reg_addr1,
    input wire [3:0] reg_addr2,

    // Read outputs (to OF unit)
    output wire [31:0] reg_data1,
    output wire [31:0] reg_data2
);

    // Register array
    reg [31:0] registers [0:15];

    // Register selection logic (write port)
    reg [3:0] reg_sel;
    reg [31:0] result;

    // Combinational: decide what to write
    always @(*) begin
        case ({isLd, isCall})
            2'b00: result = aluResult;
            2'b01: result = ldResult;
            2'b10: result = pc_current + 4;
            default: result = 32'bx;
        endcase

        reg_sel = (isCall) ? 4'b1111 : Rd;
    end

    // Register reset + write
    integer j;
    always @(posedge Clk or posedge reset) begin
        if (reset) begin
            for (j = 0; j < 16; j = j + 1)
                registers[j] <= 32'b0;
        end
        else if (isWb && reg_sel != 4'b0000) begin
            registers[reg_sel] <= result;
        end
    end

    // Combinational Read Ports for OF stage
    assign reg_data1 = registers[reg_addr1];
    assign reg_data2 = registers[reg_addr2];

endmodule
