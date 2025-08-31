liteup snowballd: libstemmer fetcher

Usage
- ./libstemmer/install.sh <version>
  - version: must be 3.0.0 or 3.0.1 (other versions are not supported and will error)
  - example: ./libstemmer/install.sh 3.0.1
  - The script will create libstemmer/<version> and place files there

Requirements
- bash, curl or wget, tar

Behavior
- On each run, the script removes libstemmer/.build if it exists to ensure a clean state
- Downloads https://snowballstem.org/dist/libstemmer_c-<version>.tar.gz
- Extracts and places the source files into libstemmer/<version>
- No build is performed
- Temporary folder libstemmer/.build is also removed if left empty at the end
- Fails fast with clear errors
- Quiet output: prints only usage (on incorrect invocation) and error messages; no progress logs

Implementation notes
- No C toolchain required
- Error handling is centralized via die() helper that prints a message to stderr and exits non-zero
