// P10 ALU control
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p10_aluctl (
    input  wire is_op,
    input  wire is_opimm,
    input  wire [2:0] funct3,
    input  wire funct7b5,
    output wire [3:0] aluop
);

    assign aluop = 4'd0;   // placeholder

endmodule
