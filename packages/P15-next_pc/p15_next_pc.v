// P15 Next-PC selector
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p15_next_pc (
    input  wire [2:0] sel,
    input  wire [31:0] pc4,
    input  wire [31:0] target,
    input  wire [31:0] jalr_y,
    input  wire [31:0] mtvec,
    input  wire [31:0] mepc,
    output wire [31:0] npc
);

    assign npc = 32'd0;   // placeholder

endmodule
