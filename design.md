# Design

Goal: Provide a simple D library that exposes Snowball libstemmer functionality.

## Components

### High-Level D Wrapper (`Stemmer` struct)

- **RAII for Memory Management**: The `Stemmer` struct manages the `sb_stemmer` lifecycle automatically via its
  constructor and destructor with proper @nogc and nothrow attributes.
- **Idiomatic D Interface**: Works directly with D's `string` type for input and output using `in` parameters for
  immutable string inputs and proper const correctness.
- **Error Handling**: Uses `std.exception.enforce` for idiomatic D error handling instead of manual null checks.
- **Resource Safety**: Copy constructor is disabled (@disable this(this)) to prevent double-free issues.
- **Static Utility**: Provides a static method `availableAlgorithms()` marked @trusted to safely interface with C code.
- **Memory Safety**: Uses .dup to ensure returned strings are owned by D's garbage collector, not C memory.

### D Interface Layer (snowballd.d)

- **Opaque Types**: `sb_stemmer` struct for stemmer handles
- **Type Aliases**: `sb_symbol` mapped to D's `ubyte` (equivalent to C's `unsigned char`)
- **C Function Bindings**: Direct extern(C) declarations for all libstemmer functions:
    - `sb_stemmer_list()`: Returns available algorithm names
    - `sb_stemmer_new()`: Creates stemmer instances with algorithm/encoding parameters
    - `sb_stemmer_delete()`: Memory cleanup for stemmer instances
    - `sb_stemmer_stem()`: Core stemming operation on word arrays
    - `sb_stemmer_length()`: Gets result length from last stem operation

### Design Rationale

- **Minimal Wrapper**: Direct C bindings are provided for maximum performance and low-level control.
- **Safe Abstraction**: A high-level `Stemmer` struct is offered for convenience, safety, and idiomatic D usage. It
  handles resource management and provides a simpler API.
- **Type Safety**: Uses D's const correctness and proper pointer types.
- **Documentation**: Comprehensive function documentation with parameter details and usage notes.
- **Memory Management**: The C-style API requires manual memory management, while the `Stemmer` wrapper handles it
  automatically (RAII).

## Implementation Status

- Project is configured as a D library via dub.json (targetType: library). ✓
- D bindings to libstemmer/include/libstemmer.h implemented using extern(C). ✓
- A high-level, safe D wrapper (`Stemmer` struct) is provided for automatic memory management and idiomatic usage. ✓
- Version string function available for library identification. ✓
- Comprehensive test suite implemented covering all library functionality. ✓

## Testing

The project includes a comprehensive test suite in `tests/stemmer_test.d` that covers:

### Core Functionality Tests

- **Basic Stemming**: Tests common English word stemming (running -> run, flies -> fli, etc.)
- **Multiple Language Support**: Tests French, German, and Spanish stemming algorithms
- **Algorithm Discovery**: Tests the `availableAlgorithms()` function to verify algorithm enumeration
- **Porter Algorithm**: Specific tests for the classic Porter stemming algorithm

### Error Handling and Edge Cases

- **Invalid Algorithm Handling**: Verifies proper exception throwing for unsupported algorithms
- **Empty and Short Inputs**: Tests behavior with empty strings, single characters, and very short words
- **Case Sensitivity**: Tests the library's expectation of lowercase input
- **Long Words**: Tests stemming of very long words like "antidisestablishmentarianism"
- **Special Characters**: Tests words with numbers, hyphens, and other non-alphabetic characters

### Technical Tests

- **Character Encoding**: Tests UTF-8 encoding support (default and explicit)
- **Resource Management**: Verifies RAII behavior with multiple concurrent stemmers
- **Word Pattern Recognition**: Tests various morphological patterns (plurals, past tense, gerunds)

### Test Infrastructure

- All tests include debug logging with `[DEBUG_LOG]` prefixes for debugging
- Tests are organized as separate unittest blocks for clear failure isolation
- Comprehensive assertions verify both positive and negative test cases

## Future Work

- Consider adding performance benchmarks for different algorithms
- Add example usage documentation
