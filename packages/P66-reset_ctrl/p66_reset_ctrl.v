// P66 Reset controller
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p66_reset_ctrl (
    input  wire clk,
    input  wire btn,
    output wire rst
);

    assign rst = 1'd0;   // placeholder

endmodule
