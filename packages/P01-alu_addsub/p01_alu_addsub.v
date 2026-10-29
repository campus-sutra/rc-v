// P01 ALU adder/subtractor
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p01_alu_addsub (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire sub,
    output wire [31:0] y,
    output wire c,
    output wire v
);

    assign y = 32'd0;   // placeholder
    assign c = 1'd0;   // placeholder
    assign v = 1'd0;   // placeholder

endmodule
