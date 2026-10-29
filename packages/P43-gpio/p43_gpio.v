// P43 LEDs, display register and buttons
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p43_gpio (
    input  wire clk,
    input  wire rst,
    input  wire sel,
    input  wire we,
    input  wire re,
    input  wire [3:0] ridx,
    input  wire [31:0] wdata,
    output wire [31:0] rdata,
    input  wire [7:0] buttons,
    output wire [15:0] leds,
    output wire [31:0] seg
);

    assign rdata = 32'd0;   // placeholder
    assign leds = 16'd0;   // placeholder
    assign seg = 32'd0;   // placeholder

endmodule
