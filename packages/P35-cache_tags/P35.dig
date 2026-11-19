// P35 Cache Tag Store
// 4-line direct-mapped cache
// Address: tag = addr[7:4], index = addr[3:2], offset = addr[1:0]
// Write-allocate on miss. Reset clears all valid bits.
module p35_cache_tag_store (
    input  wire       clk,
    input  wire       rst,
    input  wire       access,
    input  wire [7:0] addr,
    output wire       hit
);

    reg [3:0] tag   [0:3];
    reg       valid [0:3];

    wire [1:0] index         = addr[3:2];
    wire [3:0] requested_tag = addr[7:4];

    wire selected_valid = valid[index];
    wire tag_match      = (tag[index] == requested_tag);

    assign hit = access && !rst && selected_valid && tag_match;

    integer i;
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 4; i = i + 1)
                valid[i] <= 1'b0;
        end else if (access && !hit) begin
            tag[index]   <= requested_tag;
            valid[index] <= 1'b1;
        end
    end
endmodule
