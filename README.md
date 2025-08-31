snowballd: D library (bindings/wrapper) for Snowball libstemmer

Usage

- Add dependency to your dub project:
  dependency "snowballd" version="~>0.1.0"
- Import module:
  import snowballd;
- Example:
  auto v = versionString();

Development

- This project is a library with libstemmer statically linked
- The functionality is exposed via D API
- Run tests with: `dub test`
