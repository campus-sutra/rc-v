// rcv_soc.v - the RC-V computer: every package's block wired together.
// Owned by shared/: students never edit this file. Each `pNN_...` instance
// below is one student's Verilog module.
//
// Single-cycle RV32I-subset processor + ROM + RAM + 24 I/O devices.
// One instruction per clock, except cycles stolen by the DMA controller.
`timescale 1ns/1ps
module rcv_soc #(parameter ROM_FILE = "rom.hex") (
    input  wire        clk,
    input  wire        btn,          // reset button
    input  wire        use_rom,      // 0 = hardwired control (P22), 1 = microprogrammed (P23)
    input  wire [7:0]  buttons,
    input  wire        kbd_valid,    // keyboard: a key is offered
    input  wire [7:0]  kbd_char,
    output wire        kbd_take,     // ... and taken at this clock edge
    output wire        tx_valid,     // terminal: a character was printed
    output wire [7:0]  tx_char,
    output wire [15:0] leds,
    output wire [6:0]  segments,
    output wire [7:0]  anodes,
    input  wire [5:0]  scr_addr,     // screen read-back for the test bench
    output wire [7:0]  scr_char,
    output wire        halted,
    output wire        ctrl_mismatch,
    output wire [31:0] pc_out,
    output wire        commit_out
);
    // ------------------------------------------------------------ reset (P66)
    wire rst;
    p66_reset_ctrl u_reset (.clk(clk), .btn(btn), .rst(rst));

    // ------------------------------------------------------------ fetch
    wire [31:0] pc, npc, pc4, instr;
    wire stall, trap, commit, pc_en;
    assign commit = ~stall & ~trap & ~halted;
    assign pc_en  = ~stall & ~halted;
    assign pc_out = pc;
    assign commit_out = commit;

    p14_pc_reg  u_pc   (.clk(clk), .rst(rst), .en(pc_en), .d(npc), .q(pc));
    p03_pc_inc  u_pc4  (.pc(pc), .pc4(pc4));

    wire [31:0] bus_addr, rom_d;
    p30_boot_rom #(.INIT_FILE(ROM_FILE)) u_rom (.iaddr(pc[15:2]), .daddr(bus_addr[15:2]), .idata(instr), .ddata(rom_d));

    // ------------------------------------------------------------ decode
    wire [6:0] opcode, funct7;
    wire [4:0] rd, rs1, rs2;
    wire [2:0] funct3;
    wire [11:0] csr_addr;
    p17_ifields u_fields (.instr(instr), .opcode(opcode), .rd(rd), .funct3(funct3), .rs1(rs1), .rs2(rs2),
                          .funct7(funct7), .csr(csr_addr));

    wire is_lui, is_auipc, is_jal, is_jalr, is_branch, is_load, is_store, is_opimm, is_op, is_system, is_ecall, is_mret;
    p21_opclass_dec u_class (.instr(instr), .is_lui(is_lui), .is_auipc(is_auipc), .is_jal(is_jal), .is_jalr(is_jalr),
                             .is_branch(is_branch), .is_load(is_load), .is_store(is_store), .is_opimm(is_opimm),
                             .is_op(is_op), .is_system(is_system), .is_ecall(is_ecall), .is_mret(is_mret));

    wire [15:0] ctrl_hw, ctrl_rom, ctrl;
    p22_ctrl_hw u_ctrl_hw (.is_lui(is_lui), .is_auipc(is_auipc), .is_jal(is_jal), .is_jalr(is_jalr),
                           .is_branch(is_branch), .is_load(is_load), .is_store(is_store), .is_opimm(is_opimm),
                           .is_op(is_op), .is_system(is_system), .ctrl(ctrl_hw));
    p23_ctrl_rom u_ctrl_rom (.op_hi(opcode[6:2]), .ctrl(ctrl_rom));
    p24_ctrl_check u_ctrl (.ctrl_hw(ctrl_hw), .ctrl_rom(ctrl_rom), .use_rom(use_rom), .ctrl(ctrl), .mismatch(ctrl_mismatch));

    // control word fields (see docs/ARCHITECTURE.md); bit 15 is unused
    wire       c_regwrite = ctrl[14], c_asel_pc = ctrl[13], c_bsel_imm = ctrl[12], c_a_zero = ctrl[11];
    wire       c_memread  = ctrl[10], c_memwrite = ctrl[9];
    wire [1:0] c_wbsel    = ctrl[8:7];
    wire [2:0] c_immsel   = ctrl[6:4];
    wire       c_branch = ctrl[3], c_jal = ctrl[2], c_jalr = ctrl[1], c_csr = ctrl[0];

    wire [31:0] imm_i, imm_s, imm_b, imm_j, imm_u, imm;
    p18_imm_is     u_imm_is  (.instr(instr), .imm_i(imm_i), .imm_s(imm_s));
    p19_imm_bju    u_imm_bju (.instr(instr), .imm_b(imm_b), .imm_j(imm_j), .imm_u(imm_u));
    p20_imm_select u_imm     (.immsel(c_immsel), .imm_i(imm_i), .imm_s(imm_s), .imm_b(imm_b), .imm_u(imm_u),
                              .imm_j(imm_j), .imm(imm));

    // ------------------------------------------------------------ registers
    wire [31:0]   wd, r1, r2;
    wire [31:0]   wen;
    wire [1023:0] q_flat;
    wire rf_write = c_regwrite & commit;
    p11_rf_decoder u_rf_dec  (.we(rf_write), .rd(rd), .wen(wen));
    p12_rf_storage u_rf      (.clk(clk), .rst(rst), .wen(wen), .wd(wd), .q_flat(q_flat));
    p13_rf_readmux u_rf_rs1  (.q_flat(q_flat), .ra(rs1), .rd(r1));
    p13_rf_readmux u_rf_rs2  (.q_flat(q_flat), .ra(rs2), .rd(r2));

    // ------------------------------------------------------------ execute
    wire [31:0] opa, opb;
    p26_opab_mux u_opab (.a_zero(c_a_zero), .asel_pc(c_asel_pc), .bsel_imm(c_bsel_imm), .rs1(r1), .pc(pc),
                         .rs2(r2), .imm(imm), .a(opa), .b(opb));

    wire [3:0] aluop;
    p10_aluctl u_aluctl (.is_op(is_op), .is_opimm(is_opimm), .funct3(funct3), .funct7b5(funct7[5]), .aluop(aluop));

    wire [31:0] add_y, logic_y, shl_y, shr_y, alu_y;
    wire lt, ltu, add_c, add_v, alu_zero;
    wire [1:0] logic_op = (aluop == 4'd2) ? 2'd0 : (aluop == 4'd3) ? 2'd1 : (aluop == 4'd4) ? 2'd2 : 2'd3;
    p01_alu_addsub u_add   (.a(opa), .b(opb), .sub(aluop == 4'd1), .y(add_y), .c(add_c), .v(add_v));
    p04_alu_logic  u_logic (.a(opa), .b(opb), .op(logic_op), .y(logic_y));
    p05_shift_left u_shl   (.a(opa), .sh(opb[4:0]), .y(shl_y));
    p06_shift_right u_shr  (.a(opa), .sh(opb[4:0]), .arith(aluop == 4'd7), .y(shr_y));
    p07_slt_unit   u_slt   (.a(opa), .b(opb), .lt(lt), .ltu(ltu));
    p08_alu_select u_alu   (.aluop(aluop), .add_y(add_y), .logic_y(logic_y), .shl_y(shl_y), .shr_y(shr_y),
                            .lt(lt), .ltu(ltu), .y(alu_y), .zero(alu_zero));

    wire take;
    p09_branch_cmp u_brcmp (.a(r1), .b(r2), .funct3(funct3), .take(take));

    wire [31:0] target;
    p02_target_adder u_target (.a(pc), .b(imm), .y(target));

    // ------------------------------------------------------------ traps and CSRs
    wire illegal;
    p40_illegal_detect u_illegal (.instr(instr), .illegal(illegal));

    wire irq, mie;
    wire [4:0]  irq_cause;
    wire [31:0] cause, mtvec, mepc, csr_rd, csr_new;
    wire csr_write;
    p39_trap_ctrl u_trap (.stall(stall), .irq(irq), .irq_cause(irq_cause), .mie(mie), .illegal(illegal),
                          .is_ecall(is_ecall), .trap(trap), .cause(cause));
    p38_csr_op u_csr_op (.funct3(funct3), .rs1_val(r1), .rs1_idx(rs1), .old(csr_rd), .new_val(csr_new), .write(csr_write));
    p37_csr_file u_csr (.clk(clk), .rst(rst), .addr(csr_addr), .we(c_csr & csr_write & commit & (funct3 != 3'd0)),
                        .wdata(csr_new), .trap(trap), .cause(cause), .pc(pc), .mret(is_mret & commit),
                        .rdata(csr_rd), .mtvec(mtvec), .mepc(mepc), .mie(mie));

    // ------------------------------------------------------------ next PC
    wire [2:0] npc_sel;
    p16_pcsel_logic u_pcsel (.trap(trap), .is_mret(is_mret), .is_jalr(c_jalr), .is_jal(c_jal),
                             .is_branch(c_branch), .take(take), .sel(npc_sel));
    p15_next_pc u_npc (.sel(npc_sel), .pc4(pc4), .target(target), .jalr_y(alu_y), .mtvec(mtvec), .mepc(mepc),
                       .npc(npc));

    // ------------------------------------------------------------ memory bus
    wire [31:0] st_wdata, bus_wdata, raw_rd, mem_val, ram_d, io_d;
    wire [3:0]  st_be, bus_be;
    wire        bus_we, grant;
    wire        dma_req, dma_we;
    wire [31:0] dma_addr, dma_wdata;
    p27_store_align u_st (.funct3(funct3), .addr_lo(alu_y[1:0]), .rs2(r2), .wdata(st_wdata), .be(st_be));
    p34_bus_arbiter u_arb (.dma_req(dma_req), .cpu_addr(alu_y), .cpu_wdata(st_wdata), .cpu_we(c_memwrite & commit),
                           .cpu_be(st_be), .dma_addr(dma_addr), .dma_wdata(dma_wdata), .dma_we(dma_we),
                           .grant(grant), .stall(stall), .addr(bus_addr), .wdata(bus_wdata), .we(bus_we), .be(bus_be));

    wire sel_rom, sel_ram, sel_io;
    wire [4:0] dev;
    wire [3:0] ridx;
    p31_addr_decode u_dec (.addr(bus_addr), .sel_rom(sel_rom), .sel_ram(sel_ram), .sel_io(sel_io), .dev(dev), .ridx(ridx));
    p29_data_ram u_ram (.clk(clk), .we(bus_we & sel_ram), .addr(bus_addr[13:2]), .be(bus_be), .wdata(bus_wdata), .rdata(ram_d));

    wire [1023:0] dev_flat;
    p33_io_bus_mux u_iomux (.dev_flat(dev_flat), .dev(dev), .rdata(io_d));
    p32_read_mux u_rmux (.sel_rom(sel_rom), .sel_ram(sel_ram), .sel_io(sel_io), .rom_d(rom_d), .ram_d(ram_d),
                         .io_d(io_d), .rdata(raw_rd));
    p28_load_extend u_ld (.raw(raw_rd), .addr_lo(bus_addr[1:0]), .funct3(funct3), .val(mem_val));
    p25_wb_mux u_wb (.wbsel(c_wbsel), .alu_y(alu_y), .mem_val(mem_val), .pc4(pc4), .csr_rd(csr_rd), .wd(wd));

    // cache model (P35 tag store + P36 counters) watches committed RAM accesses
    wire cache_access = commit & (c_memread | c_memwrite) & sel_ram;
    wire cache_hit;
    p35_cache_tags u_ctags (.clk(clk), .rst(rst), .access(cache_access), .addr(bus_addr), .hit(cache_hit));

    // ------------------------------------------------------------ I/O devices
    wire [31:0] io_sel;
    genvar g;
    generate for (g = 0; g < 32; g = g + 1) begin : slot
        assign io_sel[g] = sel_io & (dev == g);
    end endgenerate
    wire dev_re = c_memread & commit;
    wire [31:0] rdv [0:31];
    generate for (g = 24; g < 32; g = g + 1) begin : empty_slot
        assign rdv[g] = 32'd0;
    end endgenerate
    generate for (g = 0; g < 32; g = g + 1) begin : flat
        assign dev_flat[32*g +: 32] = rdv[g];
    end endgenerate

    wire timer_irq, kbd_irq, dma_irq, sp_irq;
    wire irq_line = irq & mie;
    wire trap_irq = trap & irq_line;
    wire rf_we_any = c_regwrite & (rd != 5'd0);

`define DEV(k) .clk(clk), .rst(rst), .sel(io_sel[k]), .we(bus_we), .re(dev_re), .ridx(ridx), .wdata(bus_wdata), .rdata(rdv[k])
    p41_uart_tx       u_uart  (`DEV(0), .tx_valid(tx_valid), .tx_char(tx_char));
    p42_kbd_rx        u_kbd   (`DEV(1), .ext_valid(kbd_valid), .ext_char(kbd_char), .ext_take(kbd_take), .irq(kbd_irq));
    wire [31:0] seg_value;
    p43_gpio          u_gpio  (`DEV(2), .buttons(buttons), .leds(leds), .seg(seg_value));
    p46_timer         u_timer (`DEV(3), .irq(timer_irq));
    p47_irq_ctrl      u_irq   (`DEV(4), .lines({sp_irq, dma_irq, kbd_irq, timer_irq}), .irq(irq), .cause(irq_cause));
    p48_dma           u_dma   (`DEV(5), .req(dma_req), .m_addr(dma_addr), .m_we(dma_we), .m_wdata(dma_wdata),
                               .m_rdata(raw_rd), .irq(dma_irq));
    p49_perf_counters u_perf  (`DEV(6), .commit(commit));
    p36_cache_stats   u_cache (`DEV(7), .access(cache_access), .hit(cache_hit));
    p50_mul_unit      u_mul   (`DEV(8));
    p51_simd_unit     u_simd  (`DEV(9));
    p52_bcd_unit      u_bcd   (`DEV(10));
    p53_watchdog      u_wdt   (`DEV(11));
    p54_rng_lfsr      u_rng   (`DEV(12));
    p55_sp_guard      u_spg   (`DEV(13), .commit(commit), .rf_we(rf_we_any), .rd(rd), .rf_wd(wd), .irq(sp_irq));
    p56_class_stats   u_stats (`DEV(14), .commit(commit), .is_load(c_memread), .is_store(c_memwrite),
                               .is_branch(c_branch), .taken(c_branch & take), .is_jump(c_jal | c_jalr));
    p57_halt_ctrl     u_halt  (`DEV(15), .commit(commit), .instr(instr), .halted(halted));
    p58_bpred         u_bpred (`DEV(16), .commit(commit), .is_branch(c_branch), .taken(take), .pc(pc));
    p59_hazard_meter  u_haz   (`DEV(17), .commit(commit), .instr(instr), .rf_we(rf_we_any), .rd(rd), .is_load(c_memread));
    p60_parity_unit   u_par   (`DEV(18));
    p61_text_screen   u_scr   (`DEV(19), .dbg_addr(scr_addr), .dbg_char(scr_char));
    p62_irq_latency   u_lat   (`DEV(20), .irq_line(irq_line), .trap_irq(trap_irq));
    p63_hw_stack      u_stk   (`DEV(21));
    p64_code_conv     u_conv  (`DEV(22));
    p65_complement_unit u_cmp (`DEV(23));
`undef DEV

    // ------------------------------------------------------------ display
    wire [3:0] digit;
    p45_hex_display  u_hex (.clk(clk), .rst(rst), .value(seg_value), .digit(digit), .anode(anodes));
    p44_seg7_decoder u_seg (.hex(digit), .seg(segments));
endmodule
