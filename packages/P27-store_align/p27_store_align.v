// P27 Store aligner
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p27_store_align (
    input  wire [2:0] funct3,
    input  wire [1:0] addr_lo,
    input  wire [31:0] rs2,
    output wire [31:0] wdata,
    output wire [3:0] be
);

    assign wdata = 32'd0;   // placeholder
    assign be = 4'd0;   // placeholder

endmodule
