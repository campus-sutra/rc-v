# All 66 packages

Hardware ●, program ● weights always add up to 4. Click a package for its task.

## A. Arithmetic and logic

| Package | Block | Units | Hardware | Program | I/O slot |
|---|---|---|---|---|---|
| [P01](../packages/P01-alu_addsub/README.md) | ALU adder/subtractor | 1, 2, 3 | ●●○ | ●●○ |  |
| [P02](../packages/P02-target_adder/README.md) | Branch-target adder (carry look-ahead) | 2, 3 | ●●● | ●○○ |  |
| [P03](../packages/P03-pc_inc/README.md) | PC incrementer | 2 | ●○○ | ●●● |  |
| [P04](../packages/P04-alu_logic/README.md) | ALU logic unit | 1, 2 | ●○○ | ●●● |  |
| [P05](../packages/P05-shift_left/README.md) | Left barrel shifter | 2 | ●●○ | ●●○ |  |
| [P06](../packages/P06-shift_right/README.md) | Right barrel shifter | 2, 3 | ●●○ | ●●○ |  |
| [P07](../packages/P07-slt_unit/README.md) | Less-than unit (signed and unsigned) | 1, 3 | ●●○ | ●●○ |  |
| [P08](../packages/P08-alu_select/README.md) | ALU result selector | 2 | ●○○ | ●●● |  |
| [P09](../packages/P09-branch_cmp/README.md) | Branch comparator | 1, 3, 4 | ●●○ | ●●○ |  |
| [P10](../packages/P10-aluctl/README.md) | ALU control | 1, 4 | ●●○ | ●●○ |  |

## B. Registers and program counter

| Package | Block | Units | Hardware | Program | I/O slot |
|---|---|---|---|---|---|
| [P11](../packages/P11-rf_decoder/README.md) | Register-file write decoder | 2 | ●●○ | ●●○ |  |
| [P12](../packages/P12-rf_storage/README.md) | Register-file storage | 1, 2 | ●●○ | ●●○ |  |
| [P13](../packages/P13-rf_readmux/README.md) | Register-file read port | 2 | ●●○ | ●●○ |  |
| [P14](../packages/P14-pc_reg/README.md) | Program counter register | 1, 2, 4 | ●○○ | ●●● |  |

## C. Decode and control

| Package | Block | Units | Hardware | Program | I/O slot |
|---|---|---|---|---|---|
| [P15](../packages/P15-next_pc/README.md) | Next-PC selector | 4 | ●○○ | ●●● |  |
| [P16](../packages/P16-pcsel_logic/README.md) | Next-PC decision logic | 1, 4 | ●●○ | ●●○ |  |
| [P17](../packages/P17-ifields/README.md) | Instruction field splitter | 4 | ●○○ | ●●● |  |
| [P18](../packages/P18-imm_is/README.md) | Immediate generator I/S | 3, 4 | ●○○ | ●●● |  |
| [P19](../packages/P19-imm_bju/README.md) | Immediate generator B/J/U | 3, 4 | ●●○ | ●●○ |  |
| [P20](../packages/P20-imm_select/README.md) | Immediate selector | 4 | ●○○ | ●●● |  |
| [P21](../packages/P21-opclass_dec/README.md) | Opcode class decoder | 1, 4 | ●●○ | ●●○ |  |
| [P22](../packages/P22-ctrl_hw/README.md) | Hardwired control unit | 1, 4 | ●●● | ●○○ |  |
| [P23](../packages/P23-ctrl_rom/README.md) | Microprogrammed control (control ROM) | 2, 4 | ●●○ | ●●○ |  |
| [P24](../packages/P24-ctrl_check/README.md) | Control selector and checker | 4 | ●○○ | ●●● |  |
| [P25](../packages/P25-wb_mux/README.md) | Write-back selector | 4 | ●○○ | ●●● |  |
| [P26](../packages/P26-opab_mux/README.md) | ALU operand selector | 4, 5 | ●○○ | ●●● |  |

## D. Memory and bus

| Package | Block | Units | Hardware | Program | I/O slot |
|---|---|---|---|---|---|
| [P27](../packages/P27-store_align/README.md) | Store aligner | 2, 6 | ●●○ | ●●○ |  |
| [P28](../packages/P28-load_extend/README.md) | Load extender | 2, 3, 6 | ●●○ | ●●○ |  |
| [P29](../packages/P29-data_ram/README.md) | Data memory | 2, 6 | ●●○ | ●●○ |  |
| [P30](../packages/P30-boot_rom/README.md) | Boot ROM | 2, 4, 5 | ●○○ | ●●● |  |
| [P31](../packages/P31-addr_decode/README.md) | Address decoder (memory map) | 2, 6 | ●●○ | ●●○ |  |
| [P32](../packages/P32-read_mux/README.md) | Memory read selector | 2, 6 | ●○○ | ●●● |  |
| [P33](../packages/P33-io_bus_mux/README.md) | I/O read bus | 2, 6 | ●○○ | ●●● |  |
| [P34](../packages/P34-bus_arbiter/README.md) | Bus arbiter (CPU vs DMA) | 6 | ●●○ | ●●○ |  |
| [P35](../packages/P35-cache_tags/README.md) | Cache tag store | 6 | ●●● | ●○○ |  |
| [P36](../packages/P36-cache_stats/README.md) | Cache statistics counters | 6 | ●○○ | ●●● | 7 |

## E. Traps and interrupts

| Package | Block | Units | Hardware | Program | I/O slot |
|---|---|---|---|---|---|
| [P37](../packages/P37-csr_file/README.md) | Control and status registers | 4, 6 | ●●● | ●○○ |  |
| [P38](../packages/P38-csr_op/README.md) | CSR read-modify-write | 4 | ●○○ | ●●● |  |
| [P39](../packages/P39-trap_ctrl/README.md) | Trap controller | 4 | ●●○ | ●●○ |  |
| [P40](../packages/P40-illegal_detect/README.md) | Illegal-instruction detector | 4, 5 | ●●○ | ●●○ |  |

## F. Input/output devices

| Package | Block | Units | Hardware | Program | I/O slot |
|---|---|---|---|---|---|
| [P41](../packages/P41-uart_tx/README.md) | Terminal output (UART) | 6 | ●●○ | ●●○ | 0 |
| [P42](../packages/P42-kbd_rx/README.md) | Keyboard input | 6 | ●●○ | ●●○ | 1 |
| [P43](../packages/P43-gpio/README.md) | LEDs, display register and buttons | 2, 6 | ●○○ | ●●● | 2 |
| [P44](../packages/P44-seg7_decoder/README.md) | Seven-segment decoder | 1, 2 | ●●○ | ●●○ |  |
| [P45](../packages/P45-hex_display/README.md) | Hex display scanner | 2, 6 | ●○○ | ●●● |  |
| [P46](../packages/P46-timer/README.md) | Timer | 6 | ●●○ | ●●○ | 3 |
| [P47](../packages/P47-irq_ctrl/README.md) | Interrupt controller | 2, 4, 6 | ●●○ | ●●○ | 4 |
| [P48](../packages/P48-dma/README.md) | DMA controller | 6 | ●●● | ●○○ | 5 |

## G. Measurement and support devices

| Package | Block | Units | Hardware | Program | I/O slot |
|---|---|---|---|---|---|
| [P49](../packages/P49-perf_counters/README.md) | Performance counters | 4, 5 | ●○○ | ●●● | 6 |
| [P50](../packages/P50-mul_unit/README.md) | Multiplier (shift and add) | 3, 5 | ●●● | ●○○ | 8 |
| [P51](../packages/P51-simd_unit/README.md) | Four-lane vector unit (mini GPU) | 3, 5 | ●○○ | ●●● | 9 |
| [P52](../packages/P52-bcd_unit/README.md) | Binary-to-BCD converter | 3 | ●●○ | ●●○ | 10 |
| [P53](../packages/P53-watchdog/README.md) | Watchdog timer | 6 | ●○○ | ●●● | 11 |
| [P54](../packages/P54-rng_lfsr/README.md) | Random numbers (LFSR) | 2 | ●○○ | ●●● | 12 |
| [P55](../packages/P55-sp_guard/README.md) | Stack guard | 5 | ●●○ | ●●○ | 13 |
| [P56](../packages/P56-class_stats/README.md) | Instruction-mix counters | 4, 5 | ●○○ | ●●● | 14 |
| [P57](../packages/P57-halt_ctrl/README.md) | Halt controller | 4 | ●○○ | ●●● | 15 |
| [P58](../packages/P58-bpred/README.md) | Branch predictor (2-bit counters) | 4 | ●●● | ●○○ | 16 |
| [P59](../packages/P59-hazard_meter/README.md) | Pipeline hazard meter | 4 | ●●○ | ●●○ | 17 |
| [P60](../packages/P60-parity_unit/README.md) | Parity generator | 2, 3 | ●○○ | ●●● | 18 |
| [P61](../packages/P61-text_screen/README.md) | Text screen | 2, 6 | ●●○ | ●●○ | 19 |
| [P62](../packages/P62-irq_latency/README.md) | Interrupt latency meter | 4, 6 | ●○○ | ●●● | 20 |
| [P63](../packages/P63-hw_stack/README.md) | Hardware stack | 5 | ●●○ | ●●○ | 21 |
| [P64](../packages/P64-code_conv/README.md) | Code converter (Gray, excess-3) | 3 | ●○○ | ●●● | 22 |
| [P65](../packages/P65-complement_unit/README.md) | Complement unit (r and r-1 complements) | 3 | ●●○ | ●●○ | 23 |
| [P66](../packages/P66-reset_ctrl/README.md) | Reset controller | 1, 4 | ●○○ | ●●● |  |
