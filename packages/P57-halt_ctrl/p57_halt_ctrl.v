// P57 Halt controller
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p57_halt_ctrl (
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
    output wire halted
);

    assign rdata = 32'd0;   // placeholder
    assign halted = 1'd0;   // placeholder

endmodule
