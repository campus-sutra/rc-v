// P39 Trap controller
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p39_trap_ctrl (
    input  wire stall,
    input  wire irq,
    input  wire [4:0] irq_cause,
    input  wire mie,
    input  wire illegal,
    input  wire is_ecall,
    output wire trap,
    output wire [31:0] cause
);

    assign trap = 1'd0;   // placeholder
    assign cause = 32'd0;   // placeholder

endmodule
