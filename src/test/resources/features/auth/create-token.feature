Feature: Auth - CreateToken

  Background:
    * url 'https://restful-booker.herokuapp.com'

  Scenario: Crear token con credenciales válidas
    Given path 'auth'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "username": "admin",
        "password": "password123"
      }
      """
    When method post
    Then status 200
    And match response.token != null
    And match response.token != ''

  Scenario: No crear token con password incorrecto
    Given path 'auth'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "username": "admin",
        "password": "incorrecto"
      }
      """
    When method post
    Then status 200
    And match response.reason == 'Bad credentials'

  Scenario: No crear token con username incorrecto
    Given path 'auth'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "username": "usuario_fake",
        "password": "password123"
      }
      """
    When method post
    Then status 200
    And match response.reason == 'Bad credentials'

  Scenario: No crear token con body incompleto
    Given path 'auth'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "username": "admin"
      }
      """
    When method post
    Then status 200
    And match response.reason == 'Bad credentials'