// P08 ALU result selector
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p08_alu_select (
    input  wire [3:0] aluop,
    input  wire [31:0] add_y,
    input  wire [31:0] logic_y,
    input  wire [31:0] shl_y,
    input  wire [31:0] shr_y,
    input  wire lt,
    input  wire ltu,
    output wire [31:0] y,
    output wire zero
);

    assign y = 32'd0;   // placeholder
    assign zero = 1'd0;   // placeholder

endmodule
