// P02 Branch-target adder (carry look-ahead)
module p02_target_adder (
    input  wire [31:0] a,
    input  wire [31:0] b,
    output wire [31:0] y
);

    wire [31:0] g = a & b;   // generate
    wire [31:0] p = a ^ b;   // propagate
    wire [8:0]  c;           // carry into each 4-bit block
    assign c[0] = 1'b0;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : blk
            wire [3:0] G  = g[4*i +: 4];
            wire [3:0] P  = p[4*i +: 4];
            wire       c0 = c[i];

            // look-ahead equations (no ripple inside the block)
            wire c1 = G[0] | (P[0] & c0);
            wire c2 = G[1] | (P[1] & G[0]) | (P[1] & P[0] & c0);
            wire c3 = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0])
                           | (P[2] & P[1] & P[0] & c0);
            wire c4 = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1])
                           | (P[3] & P[2] & P[1] & G[0])
                           | (P[3] & P[2] & P[1] & P[0] & c0);

            assign c[i+1]      = c4;
            assign y[4*i +: 4] = P ^ {c3, c2, c1, c0};
        end
    endgenerate

endmodule
