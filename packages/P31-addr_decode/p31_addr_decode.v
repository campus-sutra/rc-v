// P31 Address decoder (memory map)
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p31_addr_decode (
    input  wire [31:0] addr,
    output wire sel_rom,
    output wire sel_ram,
    output wire sel_io,
    output wire [4:0] dev,
    output wire [3:0] ridx
);

    assign sel_rom = 1'd0;   // placeholder
    assign sel_ram = 1'd0;   // placeholder
    assign sel_io = 1'd0;   // placeholder
    assign dev = 5'd0;   // placeholder
    assign ridx = 4'd0;   // placeholder

endmodule
