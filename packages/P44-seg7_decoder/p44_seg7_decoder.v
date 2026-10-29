// P44 Seven-segment decoder
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p44_seg7_decoder (
    input  wire [3:0] hex,
    output wire [6:0] seg
);

    assign seg = 7'd0;   // placeholder

endmodule
