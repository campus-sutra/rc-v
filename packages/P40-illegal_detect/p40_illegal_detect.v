// P40 Illegal-instruction detector
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p40_illegal_detect (
    input  wire [31:0] instr,
    output wire illegal
);

    assign illegal = 1'd0;   // placeholder

endmodule
