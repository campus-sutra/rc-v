// P22 Hardwired control unit
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p22_ctrl_hw (
    input  wire is_lui,
    input  wire is_auipc,
    input  wire is_jal,
    input  wire is_jalr,
    input  wire is_branch,
    input  wire is_load,
    input  wire is_store,
    input  wire is_opimm,
    input  wire is_op,
    input  wire is_system,
    output wire [15:0] ctrl
);

    assign ctrl = 16'd0;   // placeholder

endmodule
