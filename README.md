# Rates API Test Suite

Regression test suite for the Rates API at https://api.ratesapi.io/api.

## Bug Report

Based on results of Rates API regression tests the
following test scenarios failed:

### EUR symbols return 400 instead of 200
```
  Scenario Outline: specify symbols for latest date
    When I submit a GET request for "<dateSpec>" rates and symbols "<symbols>"
    Then the response status is 200
    And the response base value is "EUR"
    And the response rates value is an object with keys "<symbols>" and double values
    And the response date is the latest available

  Examples:
    | dateSpec | symbols |                                                                                                                        |
    | latest   | EUR     | 
    | latest   | USD,EUR  | 

  Scenario Outline: specify base currency and symbols for latest date
    When I submit a GET request for "<dateSpec>" rates and base currency "<base>" and symbols "<symbols>"
    Then the response status is 200
    And the response base value is "<base>"
    And the response rates value is an object with keys "<symbols>" and double values
    And the response date is the latest available

  Examples:
    | dateSpec | base | symbols |                                                                                                                        |
    | latest   | EUR  | EUR     |
```
**Reason of failure**: EUR value is missing in the “rates” list for default base 

### Invalid path does not return 404
```
  Scenario Outline: Incorrect path in url results in 'bad request'
    When I submit a GET request for "<dateSpec>" rates
    Then the response status is <status>

    Examples:
      | dateSpec | status |
      |          | 404    |
      | last     | 404    |
```
**Reason of failure**: According to HTTP standards, 
a request with invalid path parameter should return 404 Not Found response code

**Recommendation**: Above use cases should be confirmed with consumer’s requirements

