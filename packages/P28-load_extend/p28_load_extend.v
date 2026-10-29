// P28 Load extender
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p28_load_extend (
    input  wire [31:0] raw,
    input  wire [1:0] addr_lo,
    input  wire [2:0] funct3,
    output wire [31:0] val
);

    assign val = 32'd0;   // placeholder

endmodule
