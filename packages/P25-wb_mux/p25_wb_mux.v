// P25 Write-back selector
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p25_wb_mux (
    input  wire [1:0] wbsel,
    input  wire [31:0] alu_y,
    input  wire [31:0] mem_val,
    input  wire [31:0] pc4,
    input  wire [31:0] csr_rd,
    output wire [31:0] wd
);

    assign wd = 32'd0;   // placeholder

endmodule
