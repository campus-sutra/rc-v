// P35 Cache Tag Store
// 4-line direct-mapped cache tag store.
//
// Address format:
//   addr[7:4] = 4-bit tag
//   addr[3:2] = 2-bit line index
//   addr[1:0] = 2-bit byte offset (not used by tag lookup)
//
// Behaviour:
//   - hit is asserted only when access=1, reset=0, the selected line is valid,
//     and its stored tag matches the requested tag.
//   - On an access miss, the selected line is allocated at the next rising edge.
//   - Reset invalidates all four cache lines.
//
// Storage required: 4 valid bits + (4 lines x 4 tag bits) = 20 state bits.

module p35_cache_tag_store (
    input  wire       clk,
    input  wire       rst,
    input  wire       access,
    input  wire [7:0] addr,
    output wire       hit
);

    // Four cache entries.
    reg       valid [0:3];
    reg [3:0] tag   [0:3];

    // Split the 8-bit address into tag and line index.
    wire [1:0] index;
    wire [3:0] requested_tag;

    assign index         = addr[3:2];
    assign requested_tag = addr[7:4];

    // Select the entry identified by the index.
    wire selected_valid;
    wire tag_match;
    wire selected_miss;

    assign selected_valid = valid[index];
    assign tag_match      = (tag[index] == requested_tag);
    assign selected_miss  = !selected_valid || !tag_match;

    // Combinational hit result.
    assign hit = access && !rst && selected_valid && tag_match;

    // Sequential update:
    // reset clears valid bits; tag contents are don't-care while invalid.
    // On a miss, write the requested tag and mark the selected line valid.
    integer i;
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 4; i = i + 1) begin
                valid[i] <= 1'b0;
            end
        end
        else if (access && selected_miss) begin
            tag[index]   <= requested_tag;
            valid[index] <= 1'b1;
        end
    end

endmodule
