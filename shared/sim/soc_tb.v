// soc_tb.v - runs a program on the whole RC-V computer (owned by shared/).
//   +rom=<file.hex>    program image (passed as the ROM_FILE parameter at compile time)
//   +input=<file>      keyboard input
//   +maxcycles=<n>     stop after this many cycles
//   +userom            use the microprogrammed control unit (P23) instead of P22
// Prints the terminal output, the screen (if used) and "[halted after N cycles]".
`timescale 1ns/1ps
module soc_tb;
    parameter ROM_FILE = "rom.hex";
    reg clk = 0, btn = 0, use_rom = 0;
    reg [7:0] kbd [0:4095];
    integer kbd_len = 0, kbd_idx = 0, cycles = 0, maxcycles = 3000000, fd, c, mism = 0;
    wire kbd_take, tx_valid, halted, mismatch, commit;
    wire [7:0] tx_char, scr_char;
    reg  [5:0] scr_addr = 0;
    wire [15:0] leds;
    wire [6:0] segments;
    wire [7:0] anodes;
    wire [31:0] pc;
    reg [1023:0] inname;

    rcv_soc #(.ROM_FILE(ROM_FILE)) dut (
        .clk(clk), .btn(btn), .use_rom(use_rom), .buttons(8'hA5),
        .kbd_valid(kbd_idx < kbd_len), .kbd_char(kbd_idx < kbd_len ? kbd[kbd_idx] : 8'd0), .kbd_take(kbd_take),
        .tx_valid(tx_valid), .tx_char(tx_char), .leds(leds), .segments(segments), .anodes(anodes),
        .scr_addr(scr_addr), .scr_char(scr_char), .halted(halted), .ctrl_mismatch(mismatch),
        .pc_out(pc), .commit_out(commit));

    always #5 clk = ~clk;

    always @(posedge clk) begin
        if (kbd_take && !dut.rst) kbd_idx <= kbd_idx + 1;
        if (!dut.rst) begin
            cycles <= cycles + 1;
            if (mismatch && commit) mism <= mism + 1;   // illegal opcodes may differ: they trap anyway
        end
    end

    task dump_screen;
        integer r, k, used;
        reg [7:0] ch;
        begin
            used = 0;
            for (k = 0; k < 64; k = k + 1) begin
                scr_addr = k; #0.1;
                if (scr_char !== 8'd32) used = 1;
            end
            if (used) begin
                $write("[screen]\n");
                for (r = 0; r < 4; r = r + 1) begin
                    $write("|");
                    for (k = 0; k < 16; k = k + 1) begin
                        scr_addr = r * 16 + k; #0.1;
                        $write("%c", scr_char);
                    end
                    $write("|\n");
                end
            end
        end
    endtask

    initial begin
        if ($value$plusargs("input=%s", inname)) begin
            fd = $fopen(inname, "rb");
            if (fd != 0) begin
                c = $fgetc(fd);
                while (c != -1) begin
                    kbd[kbd_len] = c;
                    kbd_len = kbd_len + 1;
                    c = $fgetc(fd);
                end
                $fclose(fd);
            end
        end
        if ($value$plusargs("maxcycles=%d", maxcycles)) ;
        if ($test$plusargs("userom")) use_rom = 1;
        forever begin
            @(posedge clk); #1;
            if (tx_valid) $write("%c", tx_char);
            if (halted || cycles >= maxcycles) begin
                dump_screen;
                if (halted) $write("\n[halted after %0d cycles]\n", cycles);
                else $write("\n[cycle limit after %0d cycles]\n", cycles);
                if (mism) $write("[control units disagreed in %0d cycles]\n", mism);
                $finish;
            end
        end
    end
endmodule
