// P56 Instruction-mix counters
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p56_class_stats (
    input  wire clk,
    input  wire rst,
    input  wire sel,
    input  wire we,
    input  wire re,
    input  wire [3:0] ridx,
    input  wire [31:0] wdata,
    output wire [31:0] rdata,
    input  wire commit,
    input  wire is_load,
    input  wire is_store,
    input  wire is_branch,
    input  wire taken,
    input  wire is_jump
);

    assign rdata = 32'd0;   // placeholder

endmodule
