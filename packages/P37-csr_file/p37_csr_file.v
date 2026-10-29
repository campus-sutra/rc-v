// P37 Control and status registers
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p37_csr_file (
    input  wire clk,
    input  wire rst,
    input  wire [11:0] addr,
    input  wire we,
    input  wire [31:0] wdata,
    input  wire trap,
    input  wire [31:0] cause,
    input  wire [31:0] pc,
    input  wire mret,
    output wire [31:0] rdata,
    output wire [31:0] mtvec,
    output wire [31:0] mepc,
    output wire mie
);

    assign rdata = 32'd0;   // placeholder
    assign mtvec = 32'd0;   // placeholder
    assign mepc = 32'd0;   // placeholder
    assign mie = 1'd0;   // placeholder

endmodule
