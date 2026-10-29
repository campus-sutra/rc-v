// P38 CSR read-modify-write
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p38_csr_op (
    input  wire [2:0] funct3,
    input  wire [31:0] rs1_val,
    input  wire [4:0] rs1_idx,
    input  wire [31:0] old,
    output wire [31:0] new_val,
    output wire write
);

    assign new_val = 32'd0;   // placeholder
    assign write = 1'd0;   // placeholder

endmodule
