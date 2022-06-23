Feature: Hybrid Test Spotify
  Background:
    * configure driver = {type:'chromedriver' , executable:'src/test/resources/chromedriver.exe'}
    * url 'https://api.spotify.com/v1'
    * call read 'classpath:com/spotify/variables.json'
    * configure headers = {Content-Type: 'application/json', Authorization: #(authID)}

  Scenario: Hybrid Test
    Given driver 'https://open.spotify.com/'
    * def login = callonce read('classpath:com/spotify/login.feature')
    Then match waitFor(homePage.userBar).enabled == true

    # Get User ID(API)
    And path '/me'
    When method get
    Then status 200
    * def userID = response.id

    # Create Playlist and get its ID(API)
    And path '/users/'+userID+'/playlists'
    And request requestBody
    When method post
    Then status 201
    * def playlistID = response.id

    # Search song for get its ID(API)
    And path '/search'
    And param q = 'The Final Countdown'
    And param type = 'track'
    When method get
    Then status 200
    * def songUri = response.tracks.items[0].uri

    # Add Song to Playlist(API)
    And path '/playlists/'+playlistID+'/tracks'
    And request {"uris": [#(songUri)]}
    When method post
    Then status 201

    # Steps To play song(UI)
    * refresh()
    * waitFor(homePage.playList).click()
    * waitFor(playList.play).click()
    * waitForEnabled(playList.pause)

    # Checking if the song is playing(API)
    And path '/me/player/currently-playing'
    When method get
    Then match response.item.name == 'The Final Countdown'
    And match response.is_playing == true
    * delay(15000)



















