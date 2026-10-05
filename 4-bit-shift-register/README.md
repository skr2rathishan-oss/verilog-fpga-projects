# 4-Bit Shift Register (Verilog)

A beginner FPGA project: a 4-bit **Serial-In Parallel-Out (SIPO)** shift register written in Verilog, simulated with **Icarus Verilog** and **GTKWave**, and implemented on the **Digilent Nexys A7** with **Vivado**.

## Project Structure

```
4-bit-shift-register/
├── rtl/
│   ├── shift_register.v     # 4-bit shift register (the design)
│   └── top_nexys_a7.v       # Board wrapper: slow tick, switches, LEDs
├── tb/
│   └── tb_shift_register.v  # Self-checking testbench
├── sim/
│   └── tb_shift_register.vcd  # Waveform produced by the simulation
├── constraints/
│   └── nexys_a7.xdc         # Pin assignments for the Nexys A7
└── README.md
```

## How It Works

On every rising clock edge where `en` is high, the register shifts left by one bit and `serial_in` enters at bit 0:

```
q <= {q[2:0], serial_in};
```

Shifting in `1, 0, 1, 1` looks like this:

| Clock | serial_in | q[3:0] |
|-------|-----------|--------|
| reset | –         | 0000   |
| 1     | 1         | 0001   |
| 2     | 0         | 0010   |
| 3     | 1         | 0101   |
| 4     | 1         | 1011   |

### Ports (`shift_register`)

| Port         | Dir    | Width | Description                       |
|--------------|--------|-------|-----------------------------------|
| `clk`        | input  | 1     | Clock                             |
| `rst`        | input  | 1     | Synchronous reset, active high    |
| `en`         | input  | 1     | Shift enable                      |
| `serial_in`  | input  | 1     | Serial data in                    |
| `q`          | output | 4     | Parallel output                   |
| `serial_out` | output | 1     | Serial data out (`q[3]`)          |

## Simulation (Icarus Verilog + GTKWave)

Run these commands from the **project root** (the testbench writes its waveform to `sim/`):

```bash
# Compile
iverilog -o sim/tb_shift_register.vvp rtl/shift_register.v tb/tb_shift_register.v

# Run
vvp sim/tb_shift_register.vvp

# View waveform
gtkwave sim/tb_shift_register.vcd
```

Expected output ends with:

```
ALL TESTS PASSED
```

The testbench checks reset, shifting a pattern in, holding the value while `en = 0`, shifting zeros through, and resetting mid-run.

In GTKWave, expand `tb_shift_register` → `dut` and add `clk`, `rst`, `en`, `serial_in`, and `q[3:0]` to the wave view.

## FPGA Implementation (Vivado, Nexys A7)

The board clock is 100 MHz, too fast to see on LEDs. `top_nexys_a7.v` generates an enable pulse twice per second, so the register shifts at 2 Hz. Change the `TICK_COUNT` parameter to adjust the speed.

### Board Controls

| Board I/O    | Function                           |
|--------------|------------------------------------|
| `CPU_RESETN` | Reset (red button, active low)     |
| `SW0`        | Serial input bit                   |
| `SW1`        | Shift enable (up = shift, down = hold) |
| `LED0–LED3`  | Register output `q[0]`–`q[3]`      |

### Build Steps

1. Open Vivado and select **Create Project** → RTL Project.
2. Add sources: `rtl/shift_register.v` and `rtl/top_nexys_a7.v`.
3. Add constraints: `constraints/nexys_a7.xdc`.
4. Select the part **xc7a100tcsg324-1** (Nexys A7-100T).
5. Make sure `top_nexys_a7` is set as the top module.
6. Click **Generate Bitstream**.
7. Open **Hardware Manager** → Open Target → Auto Connect → **Program Device**.

### Try It

1. Press `CPU_RESETN`; all LEDs turn off.
2. Flip `SW1` up to start shifting.
3. Toggle `SW0` and watch the bits move from `LED0` toward `LED3`.
4. Flip `SW1` down to freeze the current pattern.

> Using the Nexys A7-50T? Choose part **xc7a50ticsg324-1L** instead. The pinout is the same.

## Tools

- [Icarus Verilog](https://steveicarus.github.io/iverilog/): simulation
- [GTKWave](https://gtkwave.sourceforge.net/): waveform viewer
- [Vivado](https://www.xilinx.com/products/design-tools/vivado.html): synthesis and programming
