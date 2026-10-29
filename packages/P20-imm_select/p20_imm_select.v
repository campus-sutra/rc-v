// P20 Immediate selector
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p20_imm_select (
    input  wire [2:0] immsel,
    input  wire [31:0] imm_i,
    input  wire [31:0] imm_s,
    input  wire [31:0] imm_b,
    input  wire [31:0] imm_u,
    input  wire [31:0] imm_j,
    output wire [31:0] imm
);

    assign imm = 32'd0;   // placeholder

endmodule
