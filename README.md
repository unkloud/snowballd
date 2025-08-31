# snowballd

**Note: This project was created with the help of an AI coding agent.**

A D programming language library that provides bindings and a high-level wrapper for
the [Snowball libstemmer](https://snowballstem.org/) library. Snowball is a language for writing stemming algorithms,
and this library allows you to use those algorithms from D programs to reduce words to their root forms.

## What is stemming?

Stemming is the process of reducing words to their root form. For example:

- "running" → "run"
- "flies" → "fli"
- "better" → "better"

This is useful for text processing, search engines, and natural language processing tasks.

## Quick Start

### Prerequisites

- D compiler (DMD, LDC, or GDC)
- DUB package manager (usually comes with D)

If you're new to D, visit [dlang.org](https://dlang.org) for installation instructions.

### Installation

Add snowballd as a dependency to your `dub.json`:

```json
{
  "dependencies": {
    "snowballd": "~>0.1.0"
  }
}
```

Or for `dub.sdl`:

```sdl
dependency "snowballd" version="~>0.1.0"
```

### Basic Usage

```d
import snowballd;

void main()
{
    // Create a stemmer for English
    auto stemmer = Stemmer("english");

    // Stem some words
    writeln(stemmer.stem("running"));   // Output: "run"
    writeln(stemmer.stem("flies"));     // Output: "fli"
    writeln(stemmer.stem("better"));    // Output: "better"

    // See what algorithms are available
    string[] algorithms = Stemmer.availableAlgorithms();
    writeln("Available algorithms: ", algorithms);

    // Check the library version
    writeln("Library version: ", Stemmer.libVersion());
}
```

### Multiple Languages

The library supports many languages:

```d
import snowballd;

void main()
{
    // French stemming
    auto frenchStemmer = Stemmer("french");
    writeln(frenchStemmer.stem("courantes")); // Output: "courant"

    // German stemming  
    auto germanStemmer = Stemmer("german");
    writeln(germanStemmer.stem("laufen"));    // Output: "lauf"

    // Spanish stemming
    auto spanishStemmer = Stemmer("spanish");
    writeln(spanishStemmer.stem("corriendo")); // Output: "corr"
}
```

## API Reference

### `Stemmer` struct

The main interface for using the library. It automatically manages memory and provides a safe, D-idiomatic API.

#### Constructors

- `Stemmer(string algorithm, string encoding = "UTF-8")` - Creates a new stemmer
    - `algorithm`: Language name (e.g., "english", "french") or ISO 639 code
    - `encoding`: Character encoding (usually leave as default "UTF-8")
    - Throws: `Exception` if the algorithm is not supported

#### Methods

- `string stem(string word)` - Stems a single word
    - Input should be lowercase for best results
    - Returns the stemmed word

#### Static Methods

- `string[] availableAlgorithms()` - Returns list of supported languages
- `string libVersion()` - Returns the underlying libstemmer version

### Low-level C API

For advanced users, the raw C bindings are also available:

- `sb_stemmer_new()`, `sb_stemmer_delete()`, `sb_stemmer_stem()`, etc.

See the source code documentation for details.

## Important Notes

- **Input should be lowercase**: The stemming algorithms expect lowercase input
- **Memory management**: The `Stemmer` struct handles this automatically
- **Thread safety**: Each `Stemmer` instance should be used by only one thread
- **Error handling**: Invalid algorithms throw D exceptions

## Building from Source

```bash
git clone <repository-url>
cd snowballd
dub build
```

## License

This project uses the same license as the underlying Snowball library.

## Contributing

Contributions are welcome! Please ensure any changes follow D best practices and include appropriate documentation.
