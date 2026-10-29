// P45 Hex display scanner
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p45_hex_display (
    input  wire clk,
    input  wire rst,
    input  wire [31:0] value,
    output wire [3:0] digit,
    output wire [7:0] anode
);

    assign digit = 4'd0;   // placeholder
    assign anode = 8'd0;   // placeholder

endmodule
