Feature: Login Spotify
  Background:

  Scenario: Login
    # Login to account(UI)
    * maximize()
    When waitFor(login.loginButton).click()
    And waitFor(login.username).input(username)
    And waitFor(login.password).input(password)
    And waitFor(login.sendButton).click()


