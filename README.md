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

### Prerequisites

Before building from source, ensure you have the following command line tools installed:

- **D compiler** (DMD, LDC, or GDC) and **DUB** package manager
- **make** - For building the libstemmer library
- **jq** - For JSON parsing in build scripts
- **tar** - For extracting downloaded archives
- **curl** or **wget** - For downloading libstemmer source code
- Standard POSIX utilities: `cat`, `tr`, `sed`, `find`, `rm`, `cp`, `mkdir`

#### Installation on Ubuntu/Debian:
```bash
sudo apt-get update
sudo apt-get install build-essential jq curl tar
```

#### Installation on CentOS/RHEL/Fedora:
```bash
# For CentOS/RHEL
sudo yum install make jq curl tar
# For Fedora
sudo dnf install make jq curl tar
```

#### Installation on macOS:
```bash
brew install jq make curl tar
```

### Building

```bash
git clone <repository-url>
cd snowballd
dub build
```

The build process will automatically:
1. Download and extract the appropriate libstemmer source code
2. Build the libstemmer static library
3. Generate version information
4. Build the D library

## License

This project is licensed under the GNU Affero General Public License v3.0 or later (AGPL-3.0-or-later). See
the [LICENSE.txt](LICENSE.txt) file for the full license text.

## Contributing

Thank you for your interest in contributing to this project. It is maintained as a personal endeavor, and while
community enthusiasm is greatly appreciated, I may not have the capacity to review pull requests in a timely manner.

If you find this project useful, you are strongly encouraged to fork the repository and evolve it to suit your
needs. Thank you for your understanding.
