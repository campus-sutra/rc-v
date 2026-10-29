// P35 Cache tag store
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p35_cache_tags (
    input  wire clk,
    input  wire rst,
    input  wire access,
    input  wire [31:0] addr,
    output wire hit
);

    assign hit = 1'd0;   // placeholder

endmodule
