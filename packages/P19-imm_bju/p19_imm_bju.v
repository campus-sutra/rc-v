// P19 Immediate generator B/J/U
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p19_imm_bju (
    input  wire [31:0] instr,
    output wire [31:0] imm_b,
    output wire [31:0] imm_j,
    output wire [31:0] imm_u
);

    assign imm_b = 32'd0;   // placeholder
    assign imm_j = 32'd0;   // placeholder
    assign imm_u = 32'd0;   // placeholder

endmodule
