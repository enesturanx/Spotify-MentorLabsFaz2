package com.spotify.endtoendtest;

import com.intuit.karate.junit5.Karate;

public class EndtoendRunner {
    @Karate.Test
    Karate testUsers() {
        return Karate.run("endtoend").relativeTo(getClass());
    }

}
