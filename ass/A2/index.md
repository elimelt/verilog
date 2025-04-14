# Assignment 2

## Problem 1

Specify the minimum size (i.e., number of words and number of bits per word) of separate ROMs that will accommodate the truth tables for the following combinational circuit components. Assume the output will be as wide as is needed to represent the largest possible result (no truncation).

#### A binary multiplier that multiplies two 4-bit binary words.

Word Size: 8 bits

Number of words: 256 (number of unique input values for two 4-bit inputs)

So the total size is 2048 bits = 256 bytes

#### A 3-bit adder-subtractor.

Word Size: 4 bits
Number of words: 64

So the total size is 256 bits = 32 bytes

## Problem 2

The following questions may depend on each other and are intended to be done in order:

- How many 4 Mi × 16 RAM chips are needed to provide a total memory capacity of 64 Mi-bytes?

16 bits * 4 Mi = 8 Mi-bytes

So we need 64/8 = 8 chips.

- How many address bits are needed for our larger, 64 Mi-byte-memory assuming the same word size as the individual chips?

Word size: 16 bits = 2 bytes
64 Mi-bytes = 2^26 bytes = 2^25 words

So we need 25 address bits.

- How many of the address bits are connected to each RAM chip?

The RAM chip has 4 Mi = 2^22 words, so we need 22 address bits to access each chip.

- How many of the address bits must be decoded for the chip select (i.e., how many are needed for us to know which RAM chip we need to access)? Specify the size of the decoder.

The RAM chip has 8 chips, so we need 3 bits to select which chip to access.

## Problem 3

You are given (files) two different implementations of a 4-bit sign-and-magnitude adder: (1) a SystemVerilog module found in `sign_mag_add.sv` and (2) a corresponding ROM table found in `truthtable4.txt`.

> These operations can be tricky to interpret at first because you're so used to Two's Complement arithmetic. First interpret both inputs' values in sign-and-magnitude, add the two values together, and then attempt to encode the result back into sign-and-magnitude. If the result can't be properly represented, we call this arithmetic overflow.

1. Complete the testbench in sign_mag_add_tb.sv for an instance of sign_mag_add named dut1 with output signal sum. Make sure that you include different test cases that cover at least the following situations:

- Some number + 0
- pos + neg = 0
- pos + neg > 0
- pos + neg < 0
- pos + pos (valid)
- pos + pos (overflow)
- neg + neg (valid)
- neg + neg (overflow)

2. Modify the following code (provided for you in sync_rom.sv) to instead work with the data found in truthtable4.txt (which you should open to view). If you open truthtable4.txt in Quartus, don't add the file to your project.

```sv
module sync_rom (input  logic clk,
                 input  logic [3:0] addr,
                 output logic [6:0] data);
   // signal declaration
   logic [6:0] rom [0:15];
   // load binary values from a dummy text file into ROM
   initial
      $readmemb("data.txt", rom);
   // synchronously reads out data from requested addr
   always_ff @(posedge clk)
      data <= rom[addr];
endmodule  // sync_rom
```

> The $readmemb argument shown ("data.txt") uses a relative path. If you encounter the following warning in ModelSim (memory will also show up as all X's and a red line):
"# ** Warning: (vsim-7) Failed to open readmem file "data.txt" in read mode."

Solution: Replace the argument with the absolute path (e.g., "C:/371/hw2/data.txt").

3. Add an instance of sync_rom named dut2 with output signal data in your testbench from Part A alongside dut1 and verify that they produce the same behavior in ModelSim when passed the same inputs simultaneously.

- Depending on when you change the inputs in your test bench, you should see a timing difference of 0-1 clock cycle between the outputs of the two.
- Submit your modified code files, but you do not need to include a screenshot of your simulation in your submission PDF.

4. Compare the resource usage of these two implementations. Synthesize in Quartus with sync_rom.sv and then sign_mag_add.sv as your top-level module. Find the "Resource Usage Summary" page in the Compilation Report and compare the number of ALMs and memory bits used (omission means 0). Include this comparison in your submission PDF.

## Problem 4

Let's examine a 4×4 RAM module as shown below.

```
picture of 4x4 RAM
```


- The R/W input is 1 for writing and 0 for reading.
- A1A0 forms the two-bit address that selects which word is read out to Dout.

In the following parts, draw out a memory diagram by adding/using wires, gates, and plexors (i.e., multiplexors or demultiplexors). The clock inputs are not shown, but should be assumed to be present and connected correctly.

a. Complete the diagram below for an implementation of the 4×4 RAM as a register file. The en inputs to the registers are enable signals (i.e., the register will update when en=1 and remain the same when en=0).
b. Construct an 8×8 memory diagram using the given 4×4 RAM as a building block. Hint: how will the inputs and outputs differ for a 8×8 RAM compared to the 4×4 RAM block diagram shown above?