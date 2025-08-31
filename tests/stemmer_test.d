module tests.stemmer_test;

import snowballd;
import std.exception : enforce;

unittest
{
    auto v = versionString();
    enforce(v.length > 0, "version string should not be empty");
    enforce(v == "snowballd 0.1.0", "unexpected version string: " ~ v);
}
