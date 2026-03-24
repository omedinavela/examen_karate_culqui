Feature: Booking - GetBooking

  Background:
    * url 'https://restful-booker.herokuapp.com'

  Scenario: Obtener booking existente por id válido
       # Crear booking primero
    Given path 'booking'
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And request
      """
      {
        "firstname": "Juan",
        "lastname": "Perez",
        "totalprice": 120,
        "depositpaid": true,
        "bookingdates": {
          "checkin": "2026-03-23",
          "checkout": "2026-03-28"
        },
        "additionalneeds": "Breakfast"
      }
      """
    When method post
    Then status 200
    * def bookingId = response.bookingid

    # Consultar el booking creado
    Given path 'booking', bookingId
    When method get
    Then status 200
    And match response.firstname != null
    And match response.lastname != null
    And match response.totalprice == '#number'
    And match response.depositpaid == '#boolean'
    And match response.bookingdates != null
    And match response.bookingdates.checkin == '#string'
    And match response.bookingdates.checkout == '#string'

  Scenario: Obtener booking inexistente
    Given path 'booking', 99999999
    When method get
    Then status 404

  Scenario: Obtener booking con id no numérico
    Given path 'booking', 'abc'
    When method get
    Then status 404

  Scenario: Obtener booking con id vacío en path no existente
    Given path 'booking', ''
    When method get
    Then status 404