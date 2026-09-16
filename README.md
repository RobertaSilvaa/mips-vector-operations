# MIPS Vector Operations

A MIPS assembly program that reads two integer vectors and performs element-wise addition or multiplication.

## Repository Structure

```text
mips-vector-operations/
├── .gitignore
├── README.md
└── vector_operations.asm
```

## Features

- Addition or multiplication selection
- Vector sizes from 2 to 32 elements
- Separate input for vectors A and B
- Element-wise result stored in a third vector
- Complete result-vector output
- Input-range validation for operation and vector size
- Option to run another calculation

Each vector reserves 128 bytes, which is enough for 32 32-bit integers.

## Running

This repository does not include a MIPS simulator.

### MARS GUI

1. Open `vector_operations.asm` in MARS.
2. Assemble the program.
3. Run it.
4. Enter integer values in the Run I/O console.

### MARS command line

If you already have a MARS JAR locally, run from this repository directory:

```text
java -jar <path-to-MARS.jar> nc vector_operations.asm
```

The exact JAR filename and path depend on the MARS installation on your machine.

## Input Notes

The program uses MIPS syscall `5` for integer input. Operation and size ranges are validated after an integer is read.

Non-numeric console input behavior depends on the simulator and is not handled with a custom string parser.

## Verification Status

The source was reviewed for:

- broken label references;
- invalid control flow;
- vector bounds;
- operation validation;
- result-pointer handling;
- repeated calculations;
- English identifiers, comments, and technical labels.

Logic checks confirm that the result routine advances through every result element and that vectors cannot exceed the reserved 32-element capacity.

No MARS or SPIM executable was provided with the source, so simulator assembly and runtime behavior still need to be verified locally.

## Suggested Commit Message

```text
fix: correct MIPS vector processing and input validation
```
