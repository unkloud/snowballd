#!/usr/bin/env bash
VERSION=$(cat libstemmer/.version | tr -d '\n')
cat > source/snowballd/libversion.d << EOF
module snowballd.libversion;

/// Returns the version of the underlying libstemmer library
string libstemmerVersion() pure nothrow @safe
{
    return "$VERSION";
}
EOF

sed -i "s/\"version\": \".*\"/\"version\": \"$VERSION\"/" dub.json
