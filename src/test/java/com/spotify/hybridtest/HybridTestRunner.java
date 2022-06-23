package com.spotify.hybridtest;

import com.intuit.karate.junit5.Karate;

public class HybridTestRunner {

    @Karate.Test
    Karate testUsers() {
        return Karate.run("hybridTest").relativeTo(getClass());
    }
}
