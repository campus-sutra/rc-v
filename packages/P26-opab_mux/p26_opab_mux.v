// P26 ALU operand selector
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p26_opab_mux (
    input  wire a_zero,
    input  wire asel_pc,
    input  wire bsel_imm,
    input  wire [31:0] rs1,
    input  wire [31:0] pc,
    input  wire [31:0] rs2,
    input  wire [31:0] imm,
    output wire [31:0] a,
    output wire [31:0] b
);

    assign a = 32'd0;   // placeholder
    assign b = 32'd0;   // placeholder

endmodule
