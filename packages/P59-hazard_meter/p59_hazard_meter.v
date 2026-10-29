// P59 Pipeline hazard meter
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p59_hazard_meter (
    input  wire clk,
    input  wire rst,
    input  wire sel,
    input  wire we,
    input  wire re,
    input  wire [3:0] ridx,
    input  wire [31:0] wdata,
    output wire [31:0] rdata,
    input  wire commit,
    input  wire [31:0] instr,
    input  wire rf_we,
    input  wire [4:0] rd,
    input  wire is_load
);

    assign rdata = 32'd0;   // placeholder

endmodule
