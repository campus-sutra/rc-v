// P17 Instruction field splitter
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p17_ifields (
    input  wire [31:0] instr,
    output wire [6:0] opcode,
    output wire [4:0] rd,
    output wire [2:0] funct3,
    output wire [4:0] rs1,
    output wire [4:0] rs2,
    output wire [6:0] funct7,
    output wire [11:0] csr
);

    assign opcode = 7'd0;   // placeholder
    assign rd = 5'd0;   // placeholder
    assign funct3 = 3'd0;   // placeholder
    assign rs1 = 5'd0;   // placeholder
    assign rs2 = 5'd0;   // placeholder
    assign funct7 = 7'd0;   // placeholder
    assign csr = 12'd0;   // placeholder

endmodule
