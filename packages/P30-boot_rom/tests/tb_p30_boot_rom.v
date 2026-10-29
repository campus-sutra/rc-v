// generated - do not edit
`timescale 1ns/1ps
module tb_p30_boot_rom;
    reg [13:0] iaddr = 0, daddr = 0;
    wire [31:0] idata, ddata;
    integer errors = 0, checks = 0;
    p30_boot_rom #(.INIT_FILE("tests/boot_test.hex")) dut (.iaddr(iaddr), .daddr(daddr), .idata(idata), .ddata(ddata));
    initial begin
        iaddr = 14'd9476; daddr = 14'd984; #1;
        checks = checks + 1; if (idata !== 32'h29292904) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h29292904); end
        checks = checks + 1; if (ddata !== 32'hdbdbdbd8) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hdbdbdbd8); end
        iaddr = 14'd6881; daddr = 14'd8430; #1;
        checks = checks + 1; if (idata !== 32'h0c1c2c21) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h0c1c2c21); end
        checks = checks + 1; if (ddata !== 32'h0f0f0eee) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h0f0f0eee); end
        iaddr = 14'd1588; daddr = 14'd13015; #1;
        checks = checks + 1; if (idata !== 32'h3a3a3a34) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h3a3a3a34); end
        checks = checks + 1; if (ddata !== 32'h1a2a3a17) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h1a2a3a17); end
        iaddr = 14'd12326; daddr = 14'd4393; #1;
        checks = checks + 1; if (idata !== 32'h56565626) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h56565626); end
        checks = checks + 1; if (ddata !== 32'h4a5a6a69) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h4a5a6a69); end
        iaddr = 14'd2664; daddr = 14'd15123; #1;
        checks = checks + 1; if (idata !== 32'h72727268) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h72727268); end
        checks = checks + 1; if (ddata !== 32'h5e6e7e53) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h5e6e7e53); end
        iaddr = 14'd249; daddr = 14'd7951; #1;
        checks = checks + 1; if (idata !== 32'h0a1a2a39) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h0a1a2a39); end
        checks = checks + 1; if (ddata !== 32'h3e4e5e4f) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h3e4e5e4f); end
        iaddr = 14'd847; daddr = 14'd2380; #1;
        checks = checks + 1; if (idata !== 32'h6272828f) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h6272828f); end
        checks = checks + 1; if (ddata !== 32'h5555554c) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h5555554c); end
        iaddr = 14'd5239; daddr = 14'd13165; #1;
        checks = checks + 1; if (idata !== 32'h9babbbb7) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h9babbbb7); end
        checks = checks + 1; if (ddata !== 32'hb0c0d0ad) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hb0c0d0ad); end
        iaddr = 14'd11416; daddr = 14'd2216; #1;
        checks = checks + 1; if (idata !== 32'hc4c4c498) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hc4c4c498); end
        checks = checks + 1; if (ddata !== 32'hb0b0b0a8) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hb0b0b0a8); end
        iaddr = 14'd13153; daddr = 14'd770; #1;
        checks = checks + 1; if (idata !== 32'ha4b4c4a1) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'ha4b4c4a1); end
        checks = checks + 1; if (ddata !== 32'h05050502) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h05050502); end
        iaddr = 14'd8146; daddr = 14'd9168; #1;
        checks = checks + 1; if (idata !== 32'hf1f1f1d2) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hf1f1f1d2); end
        checks = checks + 1; if (ddata !== 32'hf3f3f3d0) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hf3f3f3d0); end
        iaddr = 14'd14051; daddr = 14'd3128; #1;
        checks = checks + 1; if (idata !== 32'h2a3a4a23) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h2a3a4a23); end
        checks = checks + 1; if (ddata !== 32'h44444438) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h44444438); end
        iaddr = 14'd9123; daddr = 14'd3661; #1;
        checks = checks + 1; if (idata !== 32'hd6e6f6e3) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hd6e6f6e3); end
        checks = checks + 1; if (ddata !== 32'h6b7b8b8d) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h6b7b8b8d); end
        iaddr = 14'd16202; daddr = 14'd10131; #1;
        checks = checks + 1; if (idata !== 32'h8989894a) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h8989894a); end
        checks = checks + 1; if (ddata !== 32'hcadaead3) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hcadaead3); end
        iaddr = 14'd4238; daddr = 14'd10112; #1;
        checks = checks + 1; if (idata !== 32'h9e9e9e8e) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h9e9e9e8e); end
        checks = checks + 1; if (ddata !== 32'ha7a7a780) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'ha7a7a780); end
        iaddr = 14'd10214; daddr = 14'd8258; #1;
        checks = checks + 1; if (idata !== 32'h0e0e0de6) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h0e0e0de6); end
        checks = checks + 1; if (ddata !== 32'h62626242) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h62626242); end
        iaddr = 14'd2632; daddr = 14'd4533; #1;
        checks = checks + 1; if (idata !== 32'h52525248) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h52525248); end
        checks = checks + 1; if (ddata !== 32'hd6e6f6f5) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hd6e6f6f5); end
        iaddr = 14'd7969; daddr = 14'd10309; #1;
        checks = checks + 1; if (idata !== 32'h50607061) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h50607061); end
        checks = checks + 1; if (ddata !== 32'h7d8d9d85) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h7d8d9d85); end
        iaddr = 14'd3883; daddr = 14'd941; #1;
        checks = checks + 1; if (idata !== 32'h4a5a6a6b) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h4a5a6a6b); end
        checks = checks + 1; if (ddata !== 32'hc0d0e0ed) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hc0d0e0ed); end
        iaddr = 14'd13425; daddr = 14'd9861; #1;
        checks = checks + 1; if (idata !== 32'hb5c5d5b1) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hb5c5d5b1); end
        checks = checks + 1; if (ddata !== 32'hbbcbdbc5) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hbbcbdbc5); end
        iaddr = 14'd5868; daddr = 14'd6106; #1;
        checks = checks + 1; if (idata !== 32'h030302ec) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h030302ec); end
        checks = checks + 1; if (ddata !== 32'hf1f1f1da) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hf1f1f1da); end
        iaddr = 14'd15467; daddr = 14'd10854; #1;
        checks = checks + 1; if (idata !== 32'hb7c7d7ab) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hb7c7d7ab); end
        checks = checks + 1; if (ddata !== 32'h90909066) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h90909066); end
        iaddr = 14'd14787; daddr = 14'd10887; #1;
        checks = checks + 1; if (idata !== 32'h0d1d2d03) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h0d1d2d03); end
        checks = checks + 1; if (ddata !== 32'hc1d1e1c7) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hc1d1e1c7); end
        iaddr = 14'd11064; daddr = 14'd2236; #1;
        checks = checks + 1; if (idata !== 32'h63636338) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h63636338); end
        checks = checks + 1; if (ddata !== 32'hc4c4c4bc) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hc4c4c4bc); end
        iaddr = 14'd662; daddr = 14'd3366; #1;
        checks = checks + 1; if (idata !== 32'h98989896) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h98989896); end
        checks = checks + 1; if (ddata !== 32'h33333326) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h33333326); end
        iaddr = 14'd15540; daddr = 14'd15913; #1;
        checks = checks + 1; if (idata !== 32'hf0f0f0b4) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hf0f0f0b4); end
        checks = checks + 1; if (ddata !== 32'h77879769) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h77879769); end
        iaddr = 14'd8570; daddr = 14'd15691; #1;
        checks = checks + 1; if (idata !== 32'h9b9b9b7a) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h9b9b9b7a); end
        checks = checks + 1; if (ddata !== 32'h98a8b88b) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h98a8b88b); end
        iaddr = 14'd8312; daddr = 14'd8375; #1;
        checks = checks + 1; if (idata !== 32'h98989878) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h98989878); end
        checks = checks + 1; if (ddata !== 32'he7f807f7) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'he7f807f7); end
        iaddr = 14'd5569; daddr = 14'd6069; #1;
        checks = checks + 1; if (idata !== 32'he6f70701) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'he6f70701); end
        checks = checks + 1; if (ddata !== 32'hdcecfcf5) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hdcecfcf5); end
        iaddr = 14'd6125; daddr = 14'd9333; #1;
        checks = checks + 1; if (idata !== 32'h1525352d) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h1525352d); end
        checks = checks + 1; if (ddata !== 32'ha9b9c9b5) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'ha9b9c9b5); end
        iaddr = 14'd13767; daddr = 14'd7389; #1;
        checks = checks + 1; if (idata !== 32'h0d1d2d07) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h0d1d2d07); end
        checks = checks + 1; if (ddata !== 32'h0a1a2a1d) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h0a1a2a1d); end
        iaddr = 14'd6990; daddr = 14'd15628; #1;
        checks = checks + 1; if (idata !== 32'h6969694e) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h6969694e); end
        checks = checks + 1; if (ddata !== 32'h4949490c) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h4949490c); end
        iaddr = 14'd12119; daddr = 14'd14147; #1;
        checks = checks + 1; if (idata !== 32'h96a6b697) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h96a6b697); end
        checks = checks + 1; if (ddata !== 32'h8a9aaa83) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h8a9aaa83); end
        iaddr = 14'd9812; daddr = 14'd12457; #1;
        checks = checks + 1; if (idata !== 32'h7a7a7a54) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h7a7a7a54); end
        checks = checks + 1; if (ddata !== 32'he9fa09e9) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'he9fa09e9); end
        iaddr = 14'd12526; daddr = 14'd9876; #1;
        checks = checks + 1; if (idata !== 32'h1f1f1eee) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h1f1f1eee); end
        checks = checks + 1; if (ddata !== 32'hbababa94) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hbababa94); end
        iaddr = 14'd15445; daddr = 14'd12229; #1;
        checks = checks + 1; if (idata !== 32'ha1b1c195) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'ha1b1c195); end
        checks = checks + 1; if (ddata !== 32'h05152505) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h05152505); end
        iaddr = 14'd10169; daddr = 14'd4543; #1;
        checks = checks + 1; if (idata !== 32'hf10110f9) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hf10110f9); end
        checks = checks + 1; if (ddata !== 32'he0f100ff) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'he0f100ff); end
        iaddr = 14'd5198; daddr = 14'd9697; #1;
        checks = checks + 1; if (idata !== 32'h6262624e) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h6262624e); end
        checks = checks + 1; if (ddata !== 32'h17273721) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h17273721); end
        iaddr = 14'd10511; daddr = 14'd670; #1;
        checks = checks + 1; if (idata !== 32'h4858684f) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h4858684f); end
        checks = checks + 1; if (ddata !== 32'ha0a0a09e) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'ha0a0a09e); end
        iaddr = 14'd6186; daddr = 14'd3917; #1;
        checks = checks + 1; if (idata !== 32'h4242422a) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h4242422a); end
        checks = checks + 1; if (ddata !== 32'h6c7c8c8d) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h6c7c8c8d); end
        iaddr = 14'd10964; daddr = 14'd1071; #1;
        checks = checks + 1; if (idata !== 32'hfefefed4) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hfefefed4); end
        checks = checks + 1; if (ddata !== 32'h4353636f) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h4353636f); end
        iaddr = 14'd8317; daddr = 14'd12837; #1;
        checks = checks + 1; if (idata !== 32'hadbdcdbd) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hadbdcdbd); end
        checks = checks + 1; if (ddata !== 32'h67778765) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h67778765); end
        iaddr = 14'd1211; daddr = 14'd14507; #1;
        checks = checks + 1; if (idata !== 32'hcfdfeffb) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hcfdfeffb); end
        checks = checks + 1; if (ddata !== 32'hf40413eb) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hf40413eb); end
        iaddr = 14'd219; daddr = 14'd4724; #1;
        checks = checks + 1; if (idata !== 32'hebfc0c1b) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hebfc0c1b); end
        checks = checks + 1; if (ddata !== 32'h86868674) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h86868674); end
        iaddr = 14'd16268; daddr = 14'd12220; #1;
        checks = checks + 1; if (idata !== 32'hcbcbcb8c) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hcbcbcb8c); end
        checks = checks + 1; if (ddata !== 32'hebebebbc) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hebebebbc); end
        iaddr = 14'd8671; daddr = 14'd14354; #1;
        checks = checks + 1; if (idata !== 32'h1121311f) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h1121311f); end
        checks = checks + 1; if (ddata !== 32'h4a4a4a12) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h4a4a4a12); end
        iaddr = 14'd4541; daddr = 14'd4369; #1;
        checks = checks + 1; if (idata !== 32'hdeeefefd) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hdeeefefd); end
        checks = checks + 1; if (ddata !== 32'h32425251) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h32425251); end
        iaddr = 14'd12769; daddr = 14'd2400; #1;
        checks = checks + 1; if (idata !== 32'h23334321) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h23334321); end
        checks = checks + 1; if (ddata !== 32'h69696960) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h69696960); end
        iaddr = 14'd10889; daddr = 14'd854; #1;
        checks = checks + 1; if (idata !== 32'hc3d3e3c9) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hc3d3e3c9); end
        checks = checks + 1; if (ddata !== 32'h59595956) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h59595956); end
        iaddr = 14'd6344; daddr = 14'd13353; #1;
        checks = checks + 1; if (idata !== 32'he0e0e0c8) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'he0e0e0c8); end
        checks = checks + 1; if (ddata !== 32'h6d7d8d69) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h6d7d8d69); end
        iaddr = 14'd15605; daddr = 14'd105; #1;
        checks = checks + 1; if (idata !== 32'h42526235) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h42526235); end
        checks = checks + 1; if (ddata !== 32'h798999a9) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h798999a9); end
        iaddr = 14'd4677; daddr = 14'd13936; #1;
        checks = checks + 1; if (idata !== 32'h67778785) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h67778785); end
        checks = checks + 1; if (ddata !== 32'ha6a6a670) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'ha6a6a670); end
        iaddr = 14'd2100; daddr = 14'd12474; #1;
        checks = checks + 1; if (idata !== 32'h3c3c3c34) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h3c3c3c34); end
        checks = checks + 1; if (ddata !== 32'heaeaeaba) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'heaeaeaba); end
        iaddr = 14'd8171; daddr = 14'd9587; #1;
        checks = checks + 1; if (idata !== 32'h1b2b3b2b) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h1b2b3b2b); end
        checks = checks + 1; if (ddata !== 32'ha8b8c8b3) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'ha8b8c8b3); end
        iaddr = 14'd9795; daddr = 14'd455; #1;
        checks = checks + 1; if (idata !== 32'h79899983) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h79899983); end
        checks = checks + 1; if (ddata !== 32'hd8e8f907) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hd8e8f907); end
        iaddr = 14'd10310; daddr = 14'd11212; #1;
        checks = checks + 1; if (idata !== 32'h6e6e6e46) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h6e6e6e46); end
        checks = checks + 1; if (ddata !== 32'hf7f7f7cc) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hf7f7f7cc); end
        iaddr = 14'd85; daddr = 14'd15683; #1;
        checks = checks + 1; if (idata !== 32'h65758595) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h65758595); end
        checks = checks + 1; if (ddata !== 32'h90a0b083) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h90a0b083); end
        iaddr = 14'd14664; daddr = 14'd3306; #1;
        checks = checks + 1; if (idata !== 32'h81818148) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h81818148); end
        checks = checks + 1; if (ddata !== 32'hf6f6f6ea) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hf6f6f6ea); end
        iaddr = 14'd11670; daddr = 14'd16026; #1;
        checks = checks + 1; if (idata !== 32'hc3c3c396) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hc3c3c396); end
        checks = checks + 1; if (ddata !== 32'hd8d8d89a) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hd8d8d89a); end
        iaddr = 14'd15637; daddr = 14'd5812; #1;
        checks = checks + 1; if (idata !== 32'h62728255) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h62728255); end
        checks = checks + 1; if (ddata !== 32'hcacacab4) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hcacacab4); end
        iaddr = 14'd3876; daddr = 14'd7952; #1;
        checks = checks + 1; if (idata !== 32'h33333324) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h33333324); end
        checks = checks + 1; if (ddata !== 32'h2f2f2f10) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h2f2f2f10); end
        iaddr = 14'd10896; daddr = 14'd15861; #1;
        checks = checks + 1; if (idata !== 32'hbababa90) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hbababa90); end
        checks = checks + 1; if (ddata !== 32'h43536335) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h43536335); end
        iaddr = 14'd12793; daddr = 14'd3464; #1;
        checks = checks + 1; if (idata !== 32'h3b4b5b39) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h3b4b5b39); end
        checks = checks + 1; if (ddata !== 32'h95959588) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h95959588); end
        iaddr = 14'd6372; daddr = 14'd6575; #1;
        checks = checks + 1; if (idata !== 32'hfcfcfce4) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hfcfcfce4); end
        checks = checks + 1; if (ddata !== 32'hd8e8f8ef) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hd8e8f8ef); end
        iaddr = 14'd15617; daddr = 14'd3101; #1;
        checks = checks + 1; if (idata !== 32'h4e5e6e41) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h4e5e6e41); end
        checks = checks + 1; if (ddata !== 32'h3949595d) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h3949595d); end
        iaddr = 14'd3491; daddr = 14'd12949; #1;
        checks = checks + 1; if (idata !== 32'hc0d0e0e3) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hc0d0e0e3); end
        checks = checks + 1; if (ddata !== 32'hd7e7f7d5) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hd7e7f7d5); end
        iaddr = 14'd3747; daddr = 14'd5644; #1;
        checks = checks + 1; if (idata !== 32'hc1d1e1e3) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hc1d1e1e3); end
        checks = checks + 1; if (ddata !== 32'h2222220c) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h2222220c); end
        iaddr = 14'd5200; daddr = 14'd11268; #1;
        checks = checks + 1; if (idata !== 32'h64646450) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h64646450); end
        checks = checks + 1; if (ddata !== 32'h30303004) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h30303004); end
        iaddr = 14'd698; daddr = 14'd5429; #1;
        checks = checks + 1; if (idata !== 32'hbcbcbcba) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hbcbcbcba); end
        checks = checks + 1; if (ddata !== 32'h5a6a7a75) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h5a6a7a75); end
        iaddr = 14'd12214; daddr = 14'd9963; #1;
        checks = checks + 1; if (idata !== 32'he5e5e5b6) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'he5e5e5b6); end
        checks = checks + 1; if (ddata !== 32'h2232422b) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h2232422b); end
        iaddr = 14'd6240; daddr = 14'd11489; #1;
        checks = checks + 1; if (idata !== 32'h78787860) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h78787860); end
        checks = checks + 1; if (ddata !== 32'h1e2e3e21) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h1e2e3e21); end
        iaddr = 14'd4904; daddr = 14'd7486; #1;
        checks = checks + 1; if (idata !== 32'h3b3b3b28) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h3b3b3b28); end
        checks = checks + 1; if (ddata !== 32'h5b5b5b3e) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h5b5b5b3e); end
        iaddr = 14'd6318; daddr = 14'd4508; #1;
        checks = checks + 1; if (idata !== 32'hc6c6c6ae) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hc6c6c6ae); end
        checks = checks + 1; if (ddata !== 32'hadadad9c) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hadadad9c); end
        iaddr = 14'd4693; daddr = 14'd14516; #1;
        checks = checks + 1; if (idata !== 32'h77879795) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h77879795); end
        checks = checks + 1; if (ddata !== 32'hecececb4) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hecececb4); end
        iaddr = 14'd4011; daddr = 14'd7293; #1;
        checks = checks + 1; if (idata !== 32'hcadaeaeb) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hcadaeaeb); end
        checks = checks + 1; if (ddata !== 32'ha9b9c9bd) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'ha9b9c9bd); end
        iaddr = 14'd10536; daddr = 14'd4696; #1;
        checks = checks + 1; if (idata !== 32'h51515128) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h51515128); end
        checks = checks + 1; if (ddata !== 32'h6a6a6a58) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h6a6a6a58); end
        iaddr = 14'd6218; daddr = 14'd5394; #1;
        checks = checks + 1; if (idata !== 32'h6262624a) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h6262624a); end
        checks = checks + 1; if (ddata !== 32'h27272712) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h27272712); end
        iaddr = 14'd9873; daddr = 14'd13599; #1;
        checks = checks + 1; if (idata !== 32'hc7d7e7d1) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hc7d7e7d1); end
        checks = checks + 1; if (ddata !== 32'h6474845f) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h6474845f); end
        iaddr = 14'd6606; daddr = 14'd9432; #1;
        checks = checks + 1; if (idata !== 32'he7e7e7ce) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'he7e7e7ce); end
        checks = checks + 1; if (ddata !== 32'hfcfcfcd8) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hfcfcfcd8); end
        iaddr = 14'd827; daddr = 14'd13580; #1;
        checks = checks + 1; if (idata !== 32'h4e5e6e7b) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h4e5e6e7b); end
        checks = checks + 1; if (ddata !== 32'h4141410c) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h4141410c); end
        iaddr = 14'd9487; daddr = 14'd136; #1;
        checks = checks + 1; if (idata !== 32'h4454644f) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h4454644f); end
        checks = checks + 1; if (ddata !== 32'h88888888) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h88888888); end
        iaddr = 14'd13095; daddr = 14'd9014; #1;
        checks = checks + 1; if (idata !== 32'h6a7a8a67) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h6a7a8a67); end
        checks = checks + 1; if (ddata !== 32'h59595936) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h59595936); end
        iaddr = 14'd3940; daddr = 14'd15733; #1;
        checks = checks + 1; if (idata !== 32'h73737364) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h73737364); end
        checks = checks + 1; if (ddata !== 32'hc2d2e2b5) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hc2d2e2b5); end
        iaddr = 14'd8912; daddr = 14'd3214; #1;
        checks = checks + 1; if (idata !== 32'hf2f2f2d0) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hf2f2f2d0); end
        checks = checks + 1; if (ddata !== 32'h9a9a9a8e) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h9a9a9a8e); end
        iaddr = 14'd13698; daddr = 14'd15197; #1;
        checks = checks + 1; if (idata !== 32'hb7b7b782) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hb7b7b782); end
        checks = checks + 1; if (ddata !== 32'ha8b8c89d) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'ha8b8c89d); end
        iaddr = 14'd3044; daddr = 14'd15365; #1;
        checks = checks + 1; if (idata !== 32'hefefefe4) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hefefefe4); end
        checks = checks + 1; if (ddata !== 32'h51617145) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h51617145); end
        iaddr = 14'd2481; daddr = 14'd7816; #1;
        checks = checks + 1; if (idata !== 32'hcadaeaf1) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hcadaeaf1); end
        checks = checks + 1; if (ddata !== 32'ha6a6a688) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'ha6a6a688); end
        iaddr = 14'd1471; daddr = 14'd14838; #1;
        checks = checks + 1; if (idata !== 32'hd4e4f4ff) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hd4e4f4ff); end
        checks = checks + 1; if (ddata !== 32'h30302ff6) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h30302ff6); end
        iaddr = 14'd6812; daddr = 14'd0; #1;
        checks = checks + 1; if (idata !== 32'hb6b6b69c) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hb6b6b69c); end
        checks = checks + 1; if (ddata !== 32'h00000000) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h00000000); end
        iaddr = 14'd4473; daddr = 14'd3728; #1;
        checks = checks + 1; if (idata !== 32'h9aaabab9) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h9aaabab9); end
        checks = checks + 1; if (ddata !== 32'h9e9e9e90) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h9e9e9e90); end
        iaddr = 14'd15763; daddr = 14'd8400; #1;
        checks = checks + 1; if (idata !== 32'he0f100d3) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'he0f100d3); end
        checks = checks + 1; if (ddata !== 32'hf0f0f0d0) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hf0f0f0d0); end
        iaddr = 14'd573; daddr = 14'd2407; #1;
        checks = checks + 1; if (idata !== 32'h4f5f6f7d) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h4f5f6f7d); end
        checks = checks + 1; if (ddata !== 32'h8090a0a7) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h8090a0a7); end
        iaddr = 14'd11487; daddr = 14'd6004; #1;
        checks = checks + 1; if (idata !== 32'h1c2c3c1f) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h1c2c3c1f); end
        checks = checks + 1; if (ddata !== 32'h8b8b8b74) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h8b8b8b74); end
        iaddr = 14'd14461; daddr = 14'd10523; #1;
        checks = checks + 1; if (idata !== 32'hc5d5e5bd) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hc5d5e5bd); end
        checks = checks + 1; if (ddata !== 32'h5464745b) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h5464745b); end
        iaddr = 14'd15847; daddr = 14'd14801; #1;
        checks = checks + 1; if (idata !== 32'h35455527) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h35455527); end
        checks = checks + 1; if (ddata !== 32'h1b2b3b11) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h1b2b3b11); end
        iaddr = 14'd13335; daddr = 14'd2061; #1;
        checks = checks + 1; if (idata !== 32'h5b6b7b57) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h5b6b7b57); end
        checks = checks + 1; if (ddata !== 32'h2535454d) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h2535454d); end
        iaddr = 14'd6263; daddr = 14'd2178; #1;
        checks = checks + 1; if (idata !== 32'h9fafbfb7) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h9fafbfb7); end
        checks = checks + 1; if (ddata !== 32'h8a8a8a82) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h8a8a8a82); end
        iaddr = 14'd5680; daddr = 14'd784; #1;
        checks = checks + 1; if (idata !== 32'h46464630) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h46464630); end
        checks = checks + 1; if (ddata !== 32'h13131310) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h13131310); end
        iaddr = 14'd164; daddr = 14'd2373; #1;
        checks = checks + 1; if (idata !== 32'ha4a4a4a4) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'ha4a4a4a4); end
        checks = checks + 1; if (ddata !== 32'h5e6e7e85) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h5e6e7e85); end
        iaddr = 14'd3540; daddr = 14'd10311; #1;
        checks = checks + 1; if (idata !== 32'he1e1e1d4) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'he1e1e1d4); end
        checks = checks + 1; if (ddata !== 32'h7f8f9f87) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h7f8f9f87); end
        iaddr = 14'd5711; daddr = 14'd9285; #1;
        checks = checks + 1; if (idata !== 32'h7585958f) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h7585958f); end
        checks = checks + 1; if (ddata !== 32'h79899985) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h79899985); end
        iaddr = 14'd949; daddr = 14'd14699; #1;
        checks = checks + 1; if (idata !== 32'hc8d8e8f5) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hc8d8e8f5); end
        checks = checks + 1; if (ddata !== 32'hb4c4d4ab) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hb4c4d4ab); end
        iaddr = 14'd11607; daddr = 14'd12763; #1;
        checks = checks + 1; if (idata !== 32'h94a4b497) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h94a4b497); end
        checks = checks + 1; if (ddata !== 32'h1d2d3d1b) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h1d2d3d1b); end
        iaddr = 14'd6243; daddr = 14'd1431; #1;
        checks = checks + 1; if (idata !== 32'h8b9baba3) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h8b9baba3); end
        checks = checks + 1; if (ddata !== 32'hacbcccd7) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hacbcccd7); end
        iaddr = 14'd358; daddr = 14'd3644; #1;
        checks = checks + 1; if (idata !== 32'h67676766) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h67676766); end
        checks = checks + 1; if (ddata !== 32'h4a4a4a3c) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h4a4a4a3c); end
        iaddr = 14'd14128; daddr = 14'd9701; #1;
        checks = checks + 1; if (idata !== 32'h67676730) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h67676730); end
        checks = checks + 1; if (ddata !== 32'h1b2b3b25) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h1b2b3b25); end
        iaddr = 14'd9065; daddr = 14'd3697; #1;
        checks = checks + 1; if (idata !== 32'h9cacbca9) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h9cacbca9); end
        checks = checks + 1; if (ddata !== 32'h8f9fafb1) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h8f9fafb1); end
        iaddr = 14'd12910; daddr = 14'd5876; #1;
        checks = checks + 1; if (idata !== 32'ha0a0a06e) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'ha0a0a06e); end
        checks = checks + 1; if (ddata !== 32'h0b0b0af4) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h0b0b0af4); end
        iaddr = 14'd8719; daddr = 14'd2297; #1;
        checks = checks + 1; if (idata !== 32'h4151614f) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h4151614f); end
        checks = checks + 1; if (ddata !== 32'h12223239) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h12223239); end
        iaddr = 14'd3714; daddr = 14'd12712; #1;
        checks = checks + 1; if (idata !== 32'h90909082) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h90909082); end
        checks = checks + 1; if (ddata !== 32'hd9d9d9a8) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hd9d9d9a8); end
        iaddr = 14'd13919; daddr = 14'd4187; #1;
        checks = checks + 1; if (idata !== 32'ha5b5c59f) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'ha5b5c59f); end
        checks = checks + 1; if (ddata !== 32'h7b8b9b9b) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h7b8b9b9b); end
        iaddr = 14'd11988; daddr = 14'd11685; #1;
        checks = checks + 1; if (idata !== 32'h030302d4) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h030302d4); end
        checks = checks + 1; if (ddata !== 32'he2f302e5) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'he2f302e5); end
        iaddr = 14'd13445; daddr = 14'd2553; #1;
        checks = checks + 1; if (idata !== 32'hc9d9e9c5) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hc9d9e9c5); end
        checks = checks + 1; if (ddata !== 32'h13233339) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h13233339); end
        iaddr = 14'd1457; daddr = 14'd5962; #1;
        checks = checks + 1; if (idata !== 32'hc6d6e6f1) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hc6d6e6f1); end
        checks = checks + 1; if (ddata !== 32'h6161614a) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h6161614a); end
        iaddr = 14'd15709; daddr = 14'd161; #1;
        checks = checks + 1; if (idata !== 32'haabaca9d) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'haabaca9d); end
        checks = checks + 1; if (ddata !== 32'hb1c1d1e1) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hb1c1d1e1); end
        iaddr = 14'd12217; daddr = 14'd5229; #1;
        checks = checks + 1; if (idata !== 32'hf90918f9) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hf90918f9); end
        checks = checks + 1; if (ddata !== 32'h91a1b1ad) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h91a1b1ad); end
        iaddr = 14'd15307; daddr = 14'd11233; #1;
        checks = checks + 1; if (idata !== 32'h1727370b) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h1727370b); end
        checks = checks + 1; if (ddata !== 32'h1d2d3d21) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h1d2d3d21); end
        iaddr = 14'd12855; daddr = 14'd5928; #1;
        checks = checks + 1; if (idata !== 32'h79899977) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h79899977); end
        checks = checks + 1; if (ddata !== 32'h3f3f3f28) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h3f3f3f28); end
        iaddr = 14'd5843; daddr = 14'd12246; #1;
        checks = checks + 1; if (idata !== 32'hfa0a1a13) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'hfa0a1a13); end
        checks = checks + 1; if (ddata !== 32'h060605d6) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'h060605d6); end
        iaddr = 14'd7653; daddr = 14'd10946; #1;
        checks = checks + 1; if (idata !== 32'h13233325) begin errors = errors + 1; if (errors <= 20) $display("idata at %0d = %h, expected %h", iaddr, idata, 32'h13233325); end
        checks = checks + 1; if (ddata !== 32'hecececc2) begin errors = errors + 1; if (errors <= 20) $display("ddata at %0d = %h, expected %h", daddr, ddata, 32'hecececc2); end
        $display("RESULT %s %0d/%0d checks passed", errors == 0 ? "PASS" : "FAIL", checks - errors, checks);
        $finish;
    end
endmodule
