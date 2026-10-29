// P42 Keyboard input
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p42_kbd_rx (
    input  wire clk,
    input  wire rst,
    input  wire sel,
    input  wire we,
    input  wire re,
    input  wire [3:0] ridx,
    input  wire [31:0] wdata,
    output wire [31:0] rdata,
    input  wire ext_valid,
    input  wire [7:0] ext_char,
    output wire ext_take,
    output wire irq
);

    assign rdata = 32'd0;   // placeholder
    assign ext_take = 1'd0;   // placeholder
    assign irq = 1'd0;   // placeholder

endmodule
