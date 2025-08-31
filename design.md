# Design Document

**Note: This project was created with the help of an AI coding agent.**

## Goal

Provide a simple, safe, and idiomatic D library that exposes Snowball libstemmer functionality for text stemming operations.

## Architecture Overview

The library provides two levels of API:

1. **High-level D wrapper** (`Stemmer` struct) - Recommended for most users
2. **Low-level C bindings** - For advanced users needing direct control

## Components

### High-Level D Wrapper (`Stemmer` struct)

This is the recommended interface for D developers. It provides safety and convenience:

- **RAII for Memory Management**: 
  - *What it means*: Resources are automatically cleaned up when the `Stemmer` goes out of scope
  - *Implementation*: The `Stemmer` struct manages the `sb_stemmer` lifecycle automatically via its constructor and destructor
  - *D Features*: Uses `@nogc` and `nothrow` attributes for performance-critical destructors

- **Idiomatic D Interface**: 
  - *What it means*: Works naturally with D's type system and conventions
  - *Implementation*: Accepts and returns D's `string` type, uses `in` parameters for immutable inputs
  - *D Features*: Leverages D's const correctness and string handling

- **Error Handling**: 
  - *What it means*: Failed operations throw exceptions instead of returning null pointers
  - *Implementation*: Uses `std.exception.enforce` for clean error handling
  - *D Features*: Integrates with D's exception system rather than C-style error codes

- **Resource Safety**: 
  - *What it means*: Prevents common memory bugs like double-free errors
  - *Implementation*: Copy constructor is disabled (`@disable this(this)`)
  - *D Features*: Uses D's disable mechanism to prevent dangerous operations

- **Static Utilities**: 
  - *What it means*: Provides class-level functions that don't need an instance
  - *Implementation*: `availableAlgorithms()` method marked `@trusted` to safely interface with C code
  - *D Features*: Uses D's `@trusted` attribute to encapsulate unsafe C interactions

- **Memory Safety**: 
  - *What it means*: Returned strings are safe from C memory management issues
  - *Implementation*: Uses `.dup` to copy C strings into D's garbage collector
  - *D Features*: Leverages D's garbage collector for automatic memory management

### Low-Level C Bindings

For advanced users who need direct control or maximum performance:

- **Opaque Types**: 
  - *What it means*: The C library's internal structures are hidden from D code
  - *Implementation*: `sb_stemmer` struct acts as an opaque handle
  - *D Features*: Uses D's struct declaration without implementation details

- **Type Aliases**: 
  - *What it means*: C types are mapped to equivalent D types for compatibility
  - *Implementation*: `sb_symbol` mapped to D's `ubyte` (equivalent to C's `unsigned char`)
  - *D Features*: Uses D's `alias` for clean type mapping

- **C Function Bindings**: 
  - *What it means*: Direct access to the underlying C library functions
  - *Implementation*: `extern(C)` declarations for all libstemmer functions:
    - `sb_stemmer_list()`: Returns available algorithm names
    - `sb_stemmer_new()`: Creates stemmer instances with algorithm/encoding parameters
    - `sb_stemmer_delete()`: Memory cleanup for stemmer instances
    - `sb_stemmer_stem()`: Core stemming operation on word arrays
    - `sb_stemmer_length()`: Gets result length from last stem operation
  - *D Features*: Uses D's `extern(C)` linkage for C library integration

### Version Management (libversion.d)

- **Automatic Generation**: 
  - *What it means*: Version information is kept in sync automatically during builds
  - *Implementation*: The `libversion.d` file is generated during build via `generate_version.sh`
  - *Why it matters*: Prevents version mismatches between library and wrapper

- **Version Source**: 
  - *Implementation*: Reads version from `libstemmer/.version` file (currently "3.0.1")
  - *API Function*: Provides `libstemmerVersion()` returning the underlying libstemmer version

- **Build Integration**: 
  - *Implementation*: Version generation integrated into dub's preBuildCommands for seamless updates
  - *Version Control*: Generated files excluded from git via `.gitignore` as they are build artifacts

## Design Rationale

### Why Two APIs?

- **Performance vs Safety Trade-off**: 
  - Low-level C API: Maximum performance, direct control, manual memory management
  - High-level D wrapper: Safety, convenience, automatic resource management

- **Learning Curve Consideration**:
  - Beginners can use the safe `Stemmer` struct
  - Experts can use direct C bindings when needed

- **D Language Integration**:
  - High-level API uses D idioms (exceptions, RAII, string types)
  - Low-level API preserves C semantics for compatibility

### Technical Decisions

- **Type Safety**: Leverages D's const correctness and proper pointer types
- **Memory Management**: RAII wrapper handles cleanup automatically, C API requires manual management
- **Error Handling**: D exceptions vs C return codes for different user preferences
- **Documentation**: Comprehensive function documentation with parameter details and usage examples

## Implementation Status

- ✅ Project configured as a D library via dub.json (targetType: library)
- ✅ D bindings to libstemmer implemented using extern(C)
- ✅ High-level, safe D wrapper (`Stemmer` struct) with automatic memory management
- ✅ Version string function available for library identification
- ⚠️ Test suite: Currently minimal - comprehensive testing would be beneficial for future development

## Development and Testing

### Current Status
- The library has basic functionality implemented and working
- Manual testing confirms core stemming operations work correctly
- The API is stable and ready for use

### Recommended Testing Areas (Future Work)
For contributors interested in expanding the test coverage, these areas would be valuable:

- **Basic Functionality**: Test common word stemming across multiple languages
- **Error Handling**: Verify proper exception handling for invalid algorithms
- **Edge Cases**: Test with empty strings, very long words, special characters
- **Memory Management**: Verify RAII behavior and resource cleanup
- **Character Encoding**: Test UTF-8 and other encoding support

### Development Guidelines
- Follow D best practices for memory safety and idiomatic code
- Use `dub build` to compile the library
- Test changes manually with simple D programs before submitting
- Ensure new features include appropriate documentation

## Future Enhancements

- **Performance Benchmarks**: Compare algorithm performance across different languages
- **Extended Examples**: More comprehensive usage documentation with real-world scenarios  
- **Test Suite**: Automated testing infrastructure for continuous integration
- **Documentation**: Additional tutorials for D language newcomers
