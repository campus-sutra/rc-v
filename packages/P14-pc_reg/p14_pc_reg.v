// P14 Program counter register
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p14_pc_reg (
    input  wire clk,
    input  wire rst,
    input  wire en,
    input  wire [31:0] d,
    output wire [31:0] q
);

    assign q = 32'd0;   // placeholder

endmodule
