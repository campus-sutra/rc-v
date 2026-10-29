// P55 Stack guard
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p55_sp_guard (
    input  wire clk,
    input  wire rst,
    input  wire sel,
    input  wire we,
    input  wire re,
    input  wire [3:0] ridx,
    input  wire [31:0] wdata,
    output wire [31:0] rdata,
    input  wire commit,
    input  wire rf_we,
    input  wire [4:0] rd,
    input  wire [31:0] rf_wd,
    output wire irq
);

    assign rdata = 32'd0;   // placeholder
    assign irq = 1'd0;   // placeholder

endmodule
