// P33 I/O read bus
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p33_io_bus_mux (
    input  wire [1023:0] dev_flat,
    input  wire [4:0] dev,
    output wire [31:0] rdata
);

    assign rdata = 32'd0;   // placeholder

endmodule
