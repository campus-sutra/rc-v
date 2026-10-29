// P34 Bus arbiter (CPU vs DMA)
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p34_bus_arbiter (
    input  wire dma_req,
    input  wire [31:0] cpu_addr,
    input  wire [31:0] cpu_wdata,
    input  wire cpu_we,
    input  wire [3:0] cpu_be,
    input  wire [31:0] dma_addr,
    input  wire [31:0] dma_wdata,
    input  wire dma_we,
    output wire grant,
    output wire stall,
    output wire [31:0] addr,
    output wire [31:0] wdata,
    output wire we,
    output wire [3:0] be
);

    assign grant = 1'd0;   // placeholder
    assign stall = 1'd0;   // placeholder
    assign addr = 32'd0;   // placeholder
    assign wdata = 32'd0;   // placeholder
    assign we = 1'd0;   // placeholder
    assign be = 4'd0;   // placeholder

endmodule
