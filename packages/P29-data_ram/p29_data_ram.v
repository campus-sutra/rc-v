// P29 Data memory
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p29_data_ram (
    input  wire clk,
    input  wire we,
    input  wire [11:0] addr,
    input  wire [3:0] be,
    input  wire [31:0] wdata,
    output wire [31:0] rdata
);

    assign rdata = 32'd0;   // placeholder

endmodule
