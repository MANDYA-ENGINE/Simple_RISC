`timescale 1ns/1ps
module MA(
    input wire Clk,
    input wire reset,
    input wire [31:0] aluResult,   // Byte address from ALU
    input wire [31:0] op2,         // Data to store (store)
    input wire isLd,               // Load enable
    input wire isSt,               // Store enable
    output reg [31:0] ldResult     // Loaded data (from memory)
);

    reg [31:0] mar;
    reg [31:0] mdr; 

    // Byte-addressable memory: 1024 bytes (can hold 256 words)
    reg [7:0] data_memory [0:1023];

    always @(posedge Clk or posedge reset) begin
        if (reset) begin
            ldResult <= 32'b0;
            mar <= 32'b0;
            mdr <= 32'b0;
        end else begin
            mar <= aluResult;

            if (isSt) begin
                mdr <= op2;
                // Split 32-bit word into 4 bytes and store
                data_memory[aluResult]     <= op2[7:0];
                data_memory[aluResult + 1] <= op2[15:8];
                data_memory[aluResult + 2] <= op2[23:16];
                data_memory[aluResult + 3] <= op2[31:24];
            end

            if (isLd) begin
                // Combine 4 bytes into 32-bit word
                ldResult <= {
                    data_memory[aluResult + 3],
                    data_memory[aluResult + 2],
                    data_memory[aluResult + 1],
                    data_memory[aluResult]
                };
                mdr <= ldResult;
            end
        end
    end
endmodule
