// P47 Interrupt controller
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p47_irq_ctrl (
    input  wire clk,
    input  wire rst,
    input  wire sel,
    input  wire we,
    input  wire re,
    input  wire [3:0] ridx,
    input  wire [31:0] wdata,
    output wire [31:0] rdata,
    input  wire [3:0] lines,
    output wire irq,
    output wire [4:0] cause
);

    assign rdata = 32'd0;   // placeholder
    assign irq = 1'd0;   // placeholder
    assign cause = 5'd0;   // placeholder

endmodule
