// P61 Text screen
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p61_text_screen (
    input  wire clk,
    input  wire rst,
    input  wire sel,
    input  wire we,
    input  wire re,
    input  wire [3:0] ridx,
    input  wire [31:0] wdata,
    output wire [31:0] rdata,
    input  wire [5:0] dbg_addr,
    output wire [7:0] dbg_char
);

    assign rdata = 32'd0;   // placeholder
    assign dbg_char = 8'd0;   // placeholder

endmodule
