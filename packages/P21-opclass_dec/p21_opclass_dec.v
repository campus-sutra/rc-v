// P21 Opcode class decoder
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p21_opclass_dec (
    input  wire [31:0] instr,
    output wire is_lui,
    output wire is_auipc,
    output wire is_jal,
    output wire is_jalr,
    output wire is_branch,
    output wire is_load,
    output wire is_store,
    output wire is_opimm,
    output wire is_op,
    output wire is_system,
    output wire is_ecall,
    output wire is_mret
);

    assign is_lui = 1'd0;   // placeholder
    assign is_auipc = 1'd0;   // placeholder
    assign is_jal = 1'd0;   // placeholder
    assign is_jalr = 1'd0;   // placeholder
    assign is_branch = 1'd0;   // placeholder
    assign is_load = 1'd0;   // placeholder
    assign is_store = 1'd0;   // placeholder
    assign is_opimm = 1'd0;   // placeholder
    assign is_op = 1'd0;   // placeholder
    assign is_system = 1'd0;   // placeholder
    assign is_ecall = 1'd0;   // placeholder
    assign is_mret = 1'd0;   // placeholder

endmodule
