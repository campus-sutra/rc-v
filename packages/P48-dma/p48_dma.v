// P48 DMA controller
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p48_dma (
    input  wire clk,
    input  wire rst,
    input  wire sel,
    input  wire we,
    input  wire re,
    input  wire [3:0] ridx,
    input  wire [31:0] wdata,
    output wire [31:0] rdata,
    output wire req,
    output wire [31:0] m_addr,
    output wire m_we,
    output wire [31:0] m_wdata,
    input  wire [31:0] m_rdata,
    output wire irq
);

    assign rdata = 32'd0;   // placeholder
    assign req = 1'd0;   // placeholder
    assign m_addr = 32'd0;   // placeholder
    assign m_we = 1'd0;   // placeholder
    assign m_wdata = 32'd0;   // placeholder
    assign irq = 1'd0;   // placeholder

endmodule
