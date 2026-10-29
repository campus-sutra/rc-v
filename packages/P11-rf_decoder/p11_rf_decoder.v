// P11 Register-file write decoder
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p11_rf_decoder (
    input  wire we,
    input  wire [4:0] rd,
    output wire [31:0] wen
);

    assign wen = 32'd0;   // placeholder

endmodule
