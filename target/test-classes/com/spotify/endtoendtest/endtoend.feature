Feature: End to end Test
  Background:
    * configure driver = {type:'chromedriver' , executable:'src/test/resources/chromedriver.exe'}
    * call read 'classpath:com/spotify/variables.json'
    * url 'https://api.spotify.com/v1'
    * configure headers = {Content-Type: 'application/json', Authorization: #(authID)}
    And def clickFunction =
  """
  function(element,length) {
      for(var i = 0; i < length ; i++){
      element[i].click();
      }
  }
  """

    And def getUris =
  """
  function(length,y) {
      var data = "";
      for(var i = 0; i< length ; i++){
          if(i>0){
            data += ",";
          }
        data += y.items[i].track.id ;
      }
      return data;
  }
  """

  Scenario: Endtoend Test Scenario

    #Login
    Given driver 'https://open.spotify.com/'
    * def login = callonce read('classpath:com/spotify/login.feature')
    Then match waitFor(homePage.userBar).enabled == true

    #Scroll to 'mood' category and click and then click 'Positive' playlist .
    When scroll(category.ruhhali)
    And waitFor(category.ruhhali).click()
    And waitFor(playList.pozitif).click()
    * waitFor(playList.title)

    #The songs in the playlist are filtered and the first 5 songs are added to the likes.
    * def filter = function(x){return x.attribute('class').contains(song.addButton) }
    * def songList = locateAll(song.addButtons, filter)
    * clickFunction(songList,3)

    #Click on the 'Favorite Songs' button. And the songs in the list are started.
    And waitFor(homePage.favoriteSongs).click()
    And waitFor(song.playButton).click()
    * delay(10000)

    #The song ids in the 'favorite songs' list are obtained.
    And path '/me/tracks'
    When method get
    * def uris = getUris(response.items.length,response)

    #All songs in the list of liked songs are deleted.
    And path '/me/tracks'
    And param ids = uris
    When method delete

    #It is checked that the songs are deleted.
    And path '/me/tracks'
    When method get
    Then match response.total == 0













