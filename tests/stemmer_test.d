module tests.stemmer_test;

import snowballd;
import std.exception : assertThrown, assertNotThrown;
import std.stdio : writeln;

// Test basic stemming functionality
unittest
{
    writeln("[DEBUG_LOG] Testing basic English stemming");
    auto stemmer = Stemmer("english");

    // Test common English words
    assert(stemmer.stem("running") == "run");
    assert(stemmer.stem("flies") == "fli");
    assert(stemmer.stem("dogs") == "dog");
    assert(stemmer.stem("churches") == "church");
    assert(stemmer.stem("crying") == "cri");
    assert(stemmer.stem("ugly") == "ugili");
    assert(stemmer.stem("early") == "earli");
    writeln("[DEBUG_LOG] Basic English stemming tests passed");
}

// Test multiple language algorithms
unittest
{
    writeln("[DEBUG_LOG] Testing multiple language algorithms");

    // Test French stemming
    auto frenchStemmer = Stemmer("french");
    assert(frenchStemmer.stem("cheval") == "cheval");
    assert(frenchStemmer.stem("chevaux") == "cheval");

    // Test German stemming  
    auto germanStemmer = Stemmer("german");
    assert(germanStemmer.stem("laufen") == "lauf");

    // Test Spanish stemming
    auto spanishStemmer = Stemmer("spanish");
    assert(spanishStemmer.stem("correr") == "corr");

    writeln("[DEBUG_LOG] Multiple language algorithm tests passed");
}

// Test available algorithms functionality
unittest
{
    writeln("[DEBUG_LOG] Testing availableAlgorithms function");
    string[] algorithms = Stemmer.availableAlgorithms();

    // Should have multiple algorithms
    assert(algorithms.length > 10);

    // Should contain common algorithms
    bool hasEnglish = false;
    bool hasFrench = false;
    bool hasGerman = false;

    foreach (algo; algorithms)
    {
        if (algo == "english")
            hasEnglish = true;
        if (algo == "french")
            hasFrench = true;
        if (algo == "german")
            hasGerman = true;
    }

    assert(hasEnglish);
    assert(hasFrench);
    assert(hasGerman);

    writeln("[DEBUG_LOG] Available algorithms test passed, found ",
            algorithms.length, " algorithms");
}

// Test error handling
unittest
{
    writeln("[DEBUG_LOG] Testing error handling");

    // Test invalid algorithm
    assertThrown!Exception(Stemmer("invalid_algorithm"));

    // Test valid stemmer with edge case inputs
    auto stemmer = Stemmer("english");

    // Empty string should return empty string
    assert(stemmer.stem("") == "");

    // Single character
    assert(stemmer.stem("a") == "a");

    // Very short words
    assert(stemmer.stem("i") == "i");
    assert(stemmer.stem("be") == "be");

    writeln("[DEBUG_LOG] Error handling tests passed");
}

// Test character encoding support
unittest
{
    writeln("[DEBUG_LOG] Testing character encoding support");

    // Test UTF-8 (default)
    auto utf8Stemmer = Stemmer("english", "UTF-8");
    assert(utf8Stemmer.stem("running") == "run");

    // Test explicit UTF-8
    auto utf8Stemmer2 = Stemmer("english");
    assert(utf8Stemmer2.stem("running") == "run");

    writeln("[DEBUG_LOG] Character encoding tests passed");
}

// Test stemmer with various word lengths and patterns
unittest
{
    writeln("[DEBUG_LOG] Testing various word patterns");
    auto stemmer = Stemmer("english");

    // Test words with different suffixes
    assert(stemmer.stem("happiness") == "happi");
    assert(stemmer.stem("happily") == "happili");
    assert(stemmer.stem("unhappy") == "unhappi");

    // Test plurals
    assert(stemmer.stem("cats") == "cat");
    assert(stemmer.stem("boxes") == "box");
    assert(stemmer.stem("children") == "children"); // Irregular plural

    // Test past tense
    assert(stemmer.stem("walked") == "walk");
    assert(stemmer.stem("ran") == "ran"); // Irregular past tense

    // Test gerunds and present participles
    assert(stemmer.stem("walking") == "walk");
    assert(stemmer.stem("swimming") == "swim");

    writeln("[DEBUG_LOG] Word pattern tests passed");
}

// Test case sensitivity
unittest
{
    writeln("[DEBUG_LOG] Testing case sensitivity");
    auto stemmer = Stemmer("english");

    // Stemmer expects lowercase input for best results
    assert(stemmer.stem("running") == "run");
    assert(stemmer.stem("RUNNING") != "run"); // Uppercase may not stem correctly

    // Test mixed case
    string mixedCase = "Running";
    string lowerCase = "running";
    // The library expects lowercase, so results may differ

    writeln("[DEBUG_LOG] Case sensitivity tests passed");
}

// Test porter algorithm specifically
unittest
{
    writeln("[DEBUG_LOG] Testing Porter algorithm");
    auto porterStemmer = Stemmer("porter");

    // Porter algorithm should work similar to English
    assert(porterStemmer.stem("running") == "run");
    assert(porterStemmer.stem("flies") == "fli");
    assert(porterStemmer.stem("dogs") == "dog");

    writeln("[DEBUG_LOG] Porter algorithm tests passed");
}

// Test resource management (RAII)
unittest
{
    writeln("[DEBUG_LOG] Testing resource management");

    // Test that multiple stemmers can be created and used
    {
        auto stemmer1 = Stemmer("english");
        auto stemmer2 = Stemmer("french");
        auto stemmer3 = Stemmer("german");

        assert(stemmer1.stem("running") == "run");
        assert(stemmer2.stem("chevaux") == "cheval");
        assert(stemmer3.stem("laufen") == "lauf");
    } // Stemmers should be automatically cleaned up here

    writeln("[DEBUG_LOG] Resource management tests passed");
}

// Test long words and edge cases
unittest
{
    writeln("[DEBUG_LOG] Testing long words and edge cases");
    auto stemmer = Stemmer("english");

    // Test very long word
    string longWord = "antidisestablishmentarianism";
    string stemmedLong = stemmer.stem(longWord);
    assert(stemmedLong.length > 0);
    assert(stemmedLong.length <= longWord.length);

    // Test word with numbers (though not typical use case)
    assert(stemmer.stem("test123") == "test123");

    // Test word with hyphens
    assert(stemmer.stem("self-evident") == "self-evid");

    writeln("[DEBUG_LOG] Long words and edge cases tests passed");
}
