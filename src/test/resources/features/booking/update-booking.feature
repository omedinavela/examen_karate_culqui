Feature: Booking - UpdateBooking

  Background:
    * url 'https://restful-booker.herokuapp.com'

    # Obtener token
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
    * def token = response.token

  Scenario: Actualizar booking existente con token válido
    Given path 'booking', 1
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And header Cookie = 'token=' + token
    And request
      """
      {
        "firstname": "Carlos",
        "lastname": "Perez",
        "totalprice": 150,
        "depositpaid": true,
        "bookingdates": {
          "checkin": "2026-03-23",
          "checkout": "2026-03-28"
        },
        "additionalneeds": "Breakfast"
      }
      """
    When method put
    Then status 200
    And match response.firstname == 'Carlos'
    And match response.lastname == 'Perez'
    And match response.totalprice == 150
    And match response.depositpaid == true
    And match response.bookingdates.checkin == '2026-03-23'
    And match response.bookingdates.checkout == '2026-03-28'
    And match response.additionalneeds == 'Breakfast'

  Scenario: No actualizar booking sin token
    Given path 'booking', 1
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And request
      """
      {
        "firstname": "Carlos",
        "lastname": "Perez",
        "totalprice": 150,
        "depositpaid": true,
        "bookingdates": {
          "checkin": "2026-03-23",
          "checkout": "2026-03-28"
        },
        "additionalneeds": "Breakfast"
      }
      """
    When method put
    Then status 403

  Scenario: No actualizar booking con token inválido
    Given path 'booking', 1
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And header Cookie = 'token=token_invalido_123'
    And request
      """
      {
        "firstname": "Carlos",
        "lastname": "Perez",
        "totalprice": 150,
        "depositpaid": true,
        "bookingdates": {
          "checkin": "2026-03-23",
          "checkout": "2026-03-28"
        },
        "additionalneeds": "Breakfast"
      }
      """
    When method put
    Then status 403

  Scenario: No actualizar booking con body incompleto
    Given path 'booking', 1
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And header Cookie = 'token=' + token
    And request
      """
      {
        "firstname": "Carlos"
      }
      """
    When method put
    Then status 400