// P41 Terminal output (UART)
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p41_uart_tx (
    input  wire clk,
    input  wire rst,
    input  wire sel,
    input  wire we,
    input  wire re,
    input  wire [3:0] ridx,
    input  wire [31:0] wdata,
    output wire [31:0] rdata,
    output wire tx_valid,
    output wire [7:0] tx_char
);

    assign rdata = 32'd0;   // placeholder
    assign tx_valid = 1'd0;   // placeholder
    assign tx_char = 8'd0;   // placeholder

endmodule
