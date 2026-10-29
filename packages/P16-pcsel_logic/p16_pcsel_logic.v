// P16 Next-PC decision logic
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p16_pcsel_logic (
    input  wire trap,
    input  wire is_mret,
    input  wire is_jalr,
    input  wire is_jal,
    input  wire is_branch,
    input  wire take,
    output wire [2:0] sel
);

    assign sel = 3'd0;   // placeholder

endmodule
