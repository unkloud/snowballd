module tests.stemmer_test;

import snowballd;
import std.exception : assertThrown, assertNotThrown;

struct TestCase {
    string input;
    string expected;
}

struct LanguageTestData {
    string language;
    TestCase[] testCases;
}

unittest {
    const englishTestData = [
        TestCase("running", "run"),
        TestCase("flies", "fli"),
        TestCase("dogs", "dog"),
        TestCase("churches", "church"),
        TestCase("crying", "cri"),
        TestCase("ugly", "ugili"),
        TestCase("early", "earli"),
        TestCase("happiness", "happi"),
        TestCase("happily", "happili"),
        TestCase("unhappy", "unhappi"),
        TestCase("cats", "cat"),
        TestCase("boxes", "box"),
        TestCase("children", "children"),
        TestCase("walked", "walk"),
        TestCase("ran", "ran"),
        TestCase("walking", "walk"),
        TestCase("swimming", "swim")
    ];
    auto stemmer = Stemmer("english");
    foreach (testCase; englishTestData) {
        assert(stemmer.stem(testCase.input) == testCase.expected);
    }
}

unittest {
    const multiLanguageData = [
        LanguageTestData("french", [TestCase("cheval", "cheval"), TestCase("chevaux", "cheval")]),
        LanguageTestData("german", [TestCase("laufen", "lauf")]),
        LanguageTestData("spanish", [TestCase("correr", "corr")]),
        LanguageTestData("porter", [TestCase("running", "run"), TestCase("flies", "fli"), TestCase("dogs", "dog")])
    ];
    foreach (langData; multiLanguageData) {
        auto stemmer = Stemmer(langData.language);
        foreach (testCase; langData.testCases) {
            assert(stemmer.stem(testCase.input) == testCase.expected);
        }
    }
}

unittest {
    string[] algorithms = Stemmer.availableAlgorithms();
    assert(algorithms.length > 10);
    string[] requiredAlgorithms = ["english", "french", "german"];
    foreach (required; requiredAlgorithms) {
        bool found = false;
        foreach (algo; algorithms) {
            if (algo == required) {
                found = true;
                break;
            }
        }
        assert(found);
    }
}

unittest {
    assertThrown!Exception(Stemmer("invalid_algorithm"));
    const edgeCases = [
        TestCase("", ""),
        TestCase("a", "a"),
        TestCase("i", "i"),
        TestCase("be", "be")
    ];
    auto stemmer = Stemmer("english");
    foreach (testCase; edgeCases) {
        assert(stemmer.stem(testCase.input) == testCase.expected);
    }
}

unittest {
    const encodingTests = [TestCase("running", "run")];
    auto utf8Stemmer = Stemmer("english", "UTF-8");
    auto defaultStemmer = Stemmer("english");
    foreach (testCase; encodingTests) {
        assert(utf8Stemmer.stem(testCase.input) == testCase.expected);
        assert(defaultStemmer.stem(testCase.input) == testCase.expected);
    }
}

unittest {
    auto stemmer = Stemmer("english");
    assert(stemmer.stem("running") == "run");
    assert(stemmer.stem("RUNNING") != "run");
}

unittest {
    auto stemmer1 = Stemmer("english");
    auto stemmer2 = Stemmer("french");
    auto stemmer3 = Stemmer("german");
    assert(stemmer1.stem("running") == "run");
    assert(stemmer2.stem("chevaux") == "cheval");
    assert(stemmer3.stem("laufen") == "lauf");
}

unittest {
    auto stemmer = Stemmer("english");
    string longWord = "antidisestablishmentarianism";
    string stemmedLong = stemmer.stem(longWord);
    assert(stemmedLong.length > 0);
    assert(stemmedLong.length <= longWord.length);
    const specialCases = [
        TestCase("test123", "test123"),
        TestCase("self-evident", "self-evid")
    ];
    foreach (testCase; specialCases) {
        assert(stemmer.stem(testCase.input) == testCase.expected);
    }
}
