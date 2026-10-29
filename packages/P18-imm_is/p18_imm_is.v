// P18 Immediate generator I/S
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p18_imm_is (
    input  wire [31:0] instr,
    output wire [31:0] imm_i,
    output wire [31:0] imm_s
);

    assign imm_i = 32'd0;   // placeholder
    assign imm_s = 32'd0;   // placeholder

endmodule
