// P09 Branch comparator
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p09_branch_cmp (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [2:0] funct3,
    output wire take
);

    assign take = 1'd0;   // placeholder

endmodule
