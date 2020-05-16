Feature: Get foreign exchange reference rates.

  Scenario: latest date
    When I submit a GET request for "latest" rates
    Then the response status is 200
    And the response base value is "EUR"
    And the response rates value is not empty
    And the response date is available

  Scenario Outline: specify symbols for latest date
    When I submit a GET request for "<dateSpec>" rates and symbols "<symbols>"
    Then the response status is 200
    And the response base value is "EUR"
    And the response rates value is an object with keys "<symbols>" and double values
    And the response date is available

    Examples:
      | dateSpec | symbols                                                                                                                         |
      | latest   | USD                                                                                                                             |
      | latest   | USD,GBP                                                                                                                         |
      | latest   | HKD,IDR,ILS,DKK,INR,CHF                                                                                                         |
      | latest   | GBP,HKD,IDR,ILS,DKK,INR,CHF,MXN,CZK,SGD,THB,HRK,MYR,NOK,CNY,BGN,PHP,SEK,PLN,ZAR,CAD,ISK,BRL,RON,NZD,TRY,JPY,RUB,KRW,USD,HUF,AUD |
      | latest   | EUR                                                                                                                             |
      | latest   | USD,EUR                                                                                                                         |

  Scenario Outline: invalid symbols results in 'bad request'
    When I submit a GET request for "<dateSpec>" rates and symbols "<symbols>"
    Then the response status is 400

    Examples:
      | dateSpec | symbols |
      | latest   | usd     |
      | latest   | GBB     |
      | latest   | UAH     |
      | latest   | 976     |
      | latest   | )*^     |

  Scenario Outline: specify base currency for latest date
    When I submit a GET request for "<dateSpec>" rates and base currency "<base>"
    Then the response status is 200
    And the response base value is "<base>"
    And the response rates value is not empty
    And the response date is available

    Examples:
      | dateSpec | base |
      | latest   | USD  |
      | latest   | EUR  |

  Scenario Outline: invalid base currency results in 'bad request'
    When I submit a GET request for "<dateSpec>" rates and base currency "<base>"
    Then the response status is 400

    Examples:
      | dateSpec | base    |
      | latest   | UST     |
      | latest   | USD,EUR |
      | latest   | UAH     |
      | latest   | usd     |
      | latest   | 765     |
      | latest   | $#%     |

  Scenario Outline: specify base currency and symbols for latest date
    When I submit a GET request for "<dateSpec>" rates and base currency "<base>" and symbols "<symbols>"
    Then the response status is 200
    And the response base value is "<base>"
    And the response rates value is an object with keys "<symbols>" and double values
    And the response date is available

    Examples:
      | dateSpec | base | symbols                                                                                                                         |
      | latest   | USD  | GBP                                                                                                                             |
      | latest   | USD  | GBP,SEK,PLN,ZAR                                                                                                                 |
      | latest   | GBP  | GBP                                                                                                                             |
      | latest   | USD  | GBP,HKD,IDR,ILS,DKK,INR,CHF,MXN,CZK,SGD,THB,HRK,MYR,NOK,CNY,BGN,PHP,SEK,PLN,ZAR,CAD,ISK,BRL,RON,NZD,TRY,JPY,RUB,KRW,USD,HUF,AUD |
      | latest   | EUR  | EUR                                                                                                                             |

  Scenario Outline: invalid base currency results in 'bad request' while requesting base and symbols
    When I submit a GET request for "<dateSpec>" rates and base currency "<base>" and symbols "<symbols>"
    Then the response status is 400

    Examples:
      | dateSpec | base    | symbols |
      | latest   | usd     | GBP     |
      | latest   | 976     | USD     |
      | latest   | %@#     | PLN     |
      | latest   | USD,GBP | GBP     |
      | latest   | UAH     | GBP     |

  Scenario Outline: invalid symbols results in 'bad request' while requesting base and symbols
    When I submit a GET request for "<dateSpec>" rates and base currency "<base>" and symbols "<symbols>"
    Then the response status is 400

    Examples:
      | dateSpec | base | symbols |
      | latest   | USD  | gbp     |
      | latest   | PLN  | UAH     |
      | latest   | USD  | 976     |
      | latest   | PLN  | %@#     |

  Scenario Outline: specify empty base and symbols
    When I submit a GET request for "<requestDateSpec>" rates and base currency "" and symbols ""
    Then the response status is 200
    And the response base value is "EUR"
    And the response rates value is not empty
    And the response date is available

    Examples:
      | requestDateSpec |
      | future          |
      | latest          |

  Scenario Outline: get the foreign exchange rates for specific date
    When I submit a GET request for rates with specific date "<requestDateSpec>"
    Then the response status is 200
    And the response base value is "EUR"
    And the response rates value is not empty
    And the response date is the specific date "<responseDateSpec>"

    Examples:
      | requestDateSpec | responseDateSpec | description                  |
      | 2010-01-12      | 2010-01-12       | Business day (tues)          |
      | 1999-01-04      | 1999-01-04       | First business day available |
      | 2020-05-10      | 2020-05-08       | Sunday                       |
      | 2020-05-09      | 2020-05-08       | Saturday                     |

  Scenario Outline: invalid specific date results in 'bad request'
    When I submit a GET request for rates with specific date "<requestDateSpec>"
    Then the response status is 400
    
    Examples:
      | requestDateSpec |
      | 1999-01-03      |
      | 20200509        |
      | 2020-13-09      |
      | 2020-12-32      |
      | 20201-13-32     |
      | 2020-ab-01      |
      | 2018-02-cd      |
      | abcd-05-11      |


  Scenario Outline: specify base currency for specific date
    When I submit a GET request for rates with specific date "<requestDateSpec>" and base currency "<base>"
    Then the response status is 200
    And the response base value is "<base>"
    And the response rates value is not empty
    And the response date is the specific date "<responseDateSpec>"

    Examples:
      | requestDateSpec | responseDateSpec | base |
      | 2010-01-12      | 2010-01-12       | USD  |
      | 1999-01-04      | 1999-01-04       | EUR  |
      | 2020-05-10      | 2020-05-08       | GBP  |
      | 2020-05-09      | 2020-05-08       | PLN  |

  Scenario Outline: invalid base currency for specific date results in 'bad request'
    When I submit a GET request for rates with specific date "<requestDateSpec>" and base currency "<base>"
    Then the response status is 400

    Examples:
      | requestDateSpec | base    |
      | 2010-01-12      | GBP,USD |
      | 1999-01-04      | eur     |
      | 2020-05-10      | UAH     |
      | 2020-05-09      | 976     |
      | 2010-05-08      | !)*     |

  Scenario Outline: specify symbols for specific date
    When I submit a GET request for rates with specific date "<requestDateSpec>" and symbols "<symbols>"
    Then the response status is 200
    And the response base value is "EUR"
    And the response rates value is an object with keys "<symbols>" and double values
    And the response date is the specific date "<responseDateSpec>"

    Examples:
      | requestDateSpec | responseDateSpec | symbols                                                                                                                         |
      | 2010-01-12      | 2010-01-12       | USD                                                                                                                             |
      | 1999-01-04      | 1999-01-04       | USD,GBP                                                                                                                         |
      | 2020-05-10      | 2020-05-08       | HKD,IDR,ILS,DKK,INR,CHF                                                                                                         |
      | 2020-05-09      | 2020-05-08       | GBP,HKD,IDR,ILS,DKK,INR,CHF,MXN,CZK,SGD,THB,HRK,MYR,NOK,CNY,BGN,PHP,SEK,PLN,ZAR,CAD,ISK,BRL,RON,NZD,TRY,JPY,RUB,KRW,USD,HUF,AUD |

  Scenario Outline: invalid symbols for specific date results in 'bad request'
    When I submit a GET request for rates with specific date "<requestDateSpec>" and symbols "<symbols>"
    Then the response status is 400

    Examples:
      | requestDateSpec | symbols |
      | 2010-01-12      | GBU     |
      | 1999-01-04      | eur     |
      | 2020-05-10      | UAH     |
      | 2020-05-09      | 976     |
      | 2010-05-08      | !)*     |

  Scenario Outline: specify base currency and symbols for specific date
    When I submit a GET request for rates with specific date "<requestDateSpec>" and base currency "<base>" and symbols "<symbols>"
    Then the response status is 200
    And the response base value is "<base>"
    And the response rates value is an object with keys "<symbols>" and double values
    And the response date is the specific date "<responseDateSpec>"

    Examples:
      | requestDateSpec | responseDateSpec | base | symbols                                                                                                                         |
      | 2012-01-12      | 2012-01-12       | USD  | AUD                                                                                                                             |
      | 2010-01-12      | 2010-01-12       | USD  | USD                                                                                                                             |
      | 1999-01-04      | 1999-01-04       | EUR  | USD,GBP                                                                                                                         |
      | 2020-05-10      | 2020-05-08       | GBP  | HKD,IDR,ILS,DKK,INR,CHF                                                                                                         |
      | 2020-05-09      | 2020-05-08       | PLN  | GBP,HKD,IDR,ILS,DKK,INR,CHF,MXN,CZK,SGD,THB,HRK,MYR,NOK,CNY,BGN,PHP,SEK,PLN,ZAR,CAD,ISK,BRL,RON,NZD,TRY,JPY,RUB,KRW,USD,HUF,AUD |

  Scenario Outline: invalid base value for specific date results in 'bad request' while requesting base and symbols
    When I submit a GET request for rates with specific date "<requestDateSpec>" and base currency "<base>" and symbols "<symbols>"
    Then the response status is 400

    Examples:
      | requestDateSpec | symbols | base    |
      | 2010-01-12      | AUD     | IDR,UDS |
      | 2013-09-31      | GBP     | eur     |
      | 2016-07-11      | USD     | UAH     |
      | 2020-05-09      | USD     | 976     |
      | 2010-05-08      | GBP     | !)*     |

  Scenario Outline: invalid symbols value for specific date results in 'bad request' while requesting base and symbols
    When I submit a GET request for rates with specific date "<requestDateSpec>" and base currency "<base>" and symbols "<symbols>"
    Then the response status is 400

    Examples:
      | requestDateSpec | symbols | base |
      | 1999-01-04      | eur     | GBP  |
      | 2020-05-10      | UAH     | USD  |
      | 2020-05-09      | 976     | USD  |
      | 2010-05-08      | !)*     | PLN  |

  Scenario Outline: specify empty base and symbols for specific date
    When I submit a GET request for rates with specific date "<requestDateSpec>" and base currency "" and symbols ""
    Then the response status is 200
    And the response base value is "EUR"
    And the response rates value is not empty
    And the response date is the specific date "<responseDateSpec>"

    Examples:
      | requestDateSpec | responseDateSpec |
      | 2012-01-12      | 2012-01-12       |
      | 1999-01-04      | 1999-01-04       |
      | 2020-05-10      | 2020-05-08       |
      | 2020-05-09      | 2020-05-08       |

  Scenario: requests for future dates give the same results as current date
    When I submit a GET request for "future" rates
    Then the response status is 200
    And the response base value is "EUR"
    And the response rates value is not empty
    And the response date matches the response date for "latest" rates

  Scenario Outline: Incorrect path in url results in 'bad request'
    When I submit a GET request for "<dateSpec>" rates
    Then the response status is <status>

    Examples:
      | dateSpec | status |
      |          | 404    |
      | last     | 404    |

  Scenario: incorrect path parameter in url results in 'bad request'
    When I submit a GET request for "https://api.ratesapi.io/api1/latest" rates
    Then the response status is 404


