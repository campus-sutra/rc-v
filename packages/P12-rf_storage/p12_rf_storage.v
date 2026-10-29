// P12 Register-file storage
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p12_rf_storage (
    input  wire clk,
    input  wire rst,
    input  wire [31:0] wen,
    input  wire [31:0] wd,
    output wire [1023:0] q_flat
);

    assign q_flat = 1024'd0;   // placeholder

endmodule
