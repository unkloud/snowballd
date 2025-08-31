module snowballd;

import std.conv : to;
import std.exception : enforce;
import std.range : empty;
import std.string : fromStringz, toStringz;

/// Opaque stemmer structure
struct sb_stemmer;

/// Symbol type used by the stemmer (equivalent to unsigned char)
alias sb_symbol = ubyte;

extern (C) nothrow @nogc
{
    /// Returns an array of available stemming algorithm names.
    /// The list is null-terminated and must not be modified.
    const(char*)* sb_stemmer_list();

    /// Creates a new stemmer object for the specified algorithm and character encoding.
    /// 
    /// Params:
    ///   algorithm = Algorithm name (English name or ISO 639 language codes, lowercase)
    ///   charenc = Character encoding (null for UTF-8, or "UTF_8", "ISO_8859_1", "ISO_8859_2", "KOI8_R")
    /// 
    /// Returns: Pointer to new stemmer, or null if algorithm not recognized or out of memory
    sb_stemmer* sb_stemmer_new(const(char)* algorithm, const(char)* charenc);

    /// Deletes a stemmer object and frees all associated resources.
    /// Safe to pass null pointer.
    void sb_stemmer_delete(sb_stemmer* stemmer);

    /// Stems a word using the specified stemmer.
    /// Input should be composed accents (NFC/NFKC) and lowercase.
    /// 
    /// Params:
    ///   stemmer = The stemmer to use
    ///   word = Input word as array of symbols
    ///   size = Length of input word
    /// 
    /// Returns: Stemmed word (owned by stemmer, do not free), or null on error
    const(sb_symbol)* sb_stemmer_stem(sb_stemmer* stemmer, const(sb_symbol)* word, int size);

    /// Gets the length of the result from the last stemming operation.
    /// Should only be called after sb_stemmer_stem().
    int sb_stemmer_length(sb_stemmer* stemmer);
}

/// A high-level D wrapper for a libstemmer stemmer.
/// It handles resource management automatically (RAII).
struct Stemmer
{
    private sb_stemmer* stemmer;

    /// Creates a new stemmer for the given algorithm and character encoding.
    /// Params:
    ///   algorithm = Algorithm name (e.g., "english")
    ///   charenc = Character encoding ("UTF-8" is the default and typically does not need to be changed)
    /// Throws: `Exception` if the algorithm is not supported or the stemmer cannot be created.
    this(in string algorithm, in string charenc = "UTF-8")
    {
        const encoding = (charenc == "UTF-8" || charenc.empty) ? null : charenc.toStringz();
        stemmer = sb_stemmer_new(algorithm.toStringz(), encoding);
        enforce(stemmer !is null, "Failed to create stemmer for algorithm: " ~ algorithm);
    }

    /// Destructor to automatically free the stemmer resources.
    ~this() nothrow @nogc
    {
        if (stemmer !is null)
        {
            sb_stemmer_delete(stemmer);
        }
    }

    /// Copy constructor is disabled to prevent double-free
    @disable this(this);

    /// Stems the given word.
    /// The input word should be lowercase for best results.
    /// Returns: The stemmed word as a D string.
    string stem(in string word)
    {
        if (word.empty)
            return word;

        const wordPtr = cast(const(sb_symbol)*) word.ptr;
        const wordLength = cast(int) word.length;
        const resultPtr = sb_stemmer_stem(stemmer, wordPtr, wordLength);
        if (resultPtr is null)
        {
            return word;
        }
        const resultLength = sb_stemmer_length(stemmer);
        return cast(string) resultPtr[0 .. resultLength].dup;
    }

    /// Gets a list of available stemmer algorithms.
    /// Returns: A string array of algorithm names.
    static string[] availableAlgorithms() @trusted
    {
        const list = sb_stemmer_list();
        if (list is null)
        {
            return [];
        }
        string[] algorithms;
        for (size_t i = 0; list[i]!is null; ++i)
            algorithms ~= list[i].fromStringz.idup;
        return algorithms;
    }
}
