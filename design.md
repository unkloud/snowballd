# Design

Goal: Provide a simple D library that exposes Snowball libstemmer functionality.

Current state
- Project is configured as a D library via dub.json (targetType: library). ✓
- Minimal API placeholder exists in module `snowballd` with `versionString()`. ✓

Next steps (future work)
- Add D bindings to C headers under libstemmer/include/libstemmer.h using `extern(C)`.
- Provide safe D wrappers over the C API.
- Add tests and examples importing the library instead of a main() program.
