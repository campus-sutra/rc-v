// P35 Cache tag store
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module P35_Cache_Tag_Store (
    input clk,
    input rst,
    input access,
    input [7:0] addr,
    output hit
);

    // Address division
    wire [3:0] tag;
    wire [1:0] index;

    assign tag   = addr[7:4];
    assign index = addr[3:2];

    // Four cache lines
    reg [3:0] tag_mem [0:3];
    reg valid [0:3];

    integer i;

    // Tag and valid bit storage
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 4; i = i + 1) begin
                tag_mem[i] <= 4'b0000;
                valid[i] <= 1'b0;
            end
        end
        else if (access) begin
            tag_mem[index] <= tag;
            valid[index] <= 1'b1;
        end
    end

    // Tag comparison and hit detection
    assign hit = access &&
                 valid[index] &&
                 (tag_mem[index] == tag);

endmodule
