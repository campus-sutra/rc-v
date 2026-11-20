// P08 ALU result selector
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p08_alu_select (
    input  wire [3:0] aluop,
    input  wire [31:0] add_y,
    input  wire [31:0] logic_y,
    input  wire [31:0] shl_y,
    input  wire [31:0] shr_y,
    input  wire lt,
    input  wire ltu,
    output reg [31:0] y,
    output wire zero
);
            always @* begin
        case (aluop)
            4'd0, 4'd1:        y = add_y;
            4'd2, 4'd3, 4'd4:  y = logic_y;
            4'd5:              y = shl_y;
            4'd6, 4'd7:        y = shr_y;
            4'd8:              y = {31'b0, lt};
            4'd9:              y = {31'b0, ltu};
            default:           y = 32'd0;
        endcase
    end

    assign zero = (y == 32'd0);

    endmodule
