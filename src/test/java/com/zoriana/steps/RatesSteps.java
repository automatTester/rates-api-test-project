package com.zoriana.steps;

import io.cucumber.java.Before;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.restassured.RestAssured;
import io.restassured.response.Response;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Map;

import static io.restassured.RestAssured.given;
import static io.restassured.RestAssured.when;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

/**
 * Steps used to test the Rates API.
 */
public class RatesSteps {
    private static final String BASE_URI = "https://api.ratesapi.io/api";

    private static final Logger log = LoggerFactory.getLogger(RatesSteps.class);

    /**
     * Hold the response during each test between making the request and validation of the response.
     */
    private Response response;

    /**
     * Initialization before each test is run.
     */
    @Before
    public void setup() {
        // ensure rest assured is reset to expectations before each test
        RestAssured.baseURI = BASE_URI;
        // ensure any previous response is deleted before each test
        response = null;
    }

    /**
     * Submits request to get the latest foreign exchange rates.
     */
    @When("I submit a GET request for {string} rates")
    public void iSubmitAGETRequestForRates(String dateSpec) {
        String date = requestDateSpecAsPath(dateSpec);
        log.info("getting app path={}", date);
        response = when().get(date);
    }

    /**
     * Submits request to get the foreign exchange rates with symbols parameter.
     */
    @When("I submit a GET request for {string} rates and symbols {string}")
    public void iSubmitAGETRequestForRatesWithSymbols(String dateSpec, String symbols) {
        String date = requestDateSpecAsPath(dateSpec);
        log.info("getting app path={} symbols={}", date, symbols);
        response = given()
                .param("symbols", symbols)
                .when()
                .get(date);
    }

    /**
     * Submits request to get the latest foreign exchange rates with specific base currency.
     */
    @When("I submit a GET request for {string} rates and base currency {string}")
    public void iSubmitAGETRequestForRatesWithBaseCurrency(String dateSpec, String base) {
        String date = requestDateSpecAsPath(dateSpec);
        log.info("getting app path={} base={}", date, base);
        response = given()
                .param("base", base)
                .when()
                .get(date);
    }

    @When("I submit a GET request for {string} rates and base currency {string} and symbols {string}")
    public void iSubmitAGETRequestForRatesAndBaseCurrencyAndSymbols(String dateSpec, String base, String symbols) {
        String date = requestDateSpecAsPath(dateSpec);
        log.info("getting app path={} base={} symbols={}", date, base, symbols);
        response = given()
                .param("base", base)
                .param("symbols", symbols)
                .when()
                .get(date);

    }

    /**
     * Submits request to get the latest foreign exchange rates with specific date.
     */
    @When("I submit a GET request for rates with specific date {string}")
    public void iSubmitAGETRequestForRatesWithSpecificDate(String date) {
        log.info("getting app path={}", date);
        response = when()
                .get(date);
    }

    /**
     * Submits request to get the latest foreign exchange rates with specific date and symbols.
     */
    @When("I submit a GET request for rates with specific date {string} and symbols {string}")
    public void iSubmitAGETRequestForRatesWithSpecificDateAndSymbols(String date, String symbols) {
        log.info("getting app path={} symbols={}", date, symbols);
        response = given()
                .param("symbols", symbols)
                .when()
                .get(date);
    }

    /**
     * Submits request to get the latest foreign exchange rates with specific date and base currency.
     */
    @When("I submit a GET request for rates with specific date {string} and base currency {string}")
    public void iSubmitAGETRequestForRatesWithSpecificDateAndBaseCurrency(String date, String base) {
        log.info("getting app path={} base={}", date, base);
        response = given()
                .param("base", base)
                .when()
                .get(date);
    }

    /**
     * Submits request to get the latest foreign exchange rates with specific date, symbols and base currency.
     */
    @When("I submit a GET request for rates with specific date {string} and base currency {string} and symbols {string}")
    public void iSubmitAGETRequestForRatesWithSpecificDateAndBaseCurrencyAndSymbols(String date, String base, String symbols) {
        log.info("getting app path={} base={} symbols={}", date, base, symbols);
        response = given()
                .param("base", base)
                .param("symbols", symbols)
                .when()
                .get(date);
    }

    /**
     * Validates the response status.
     */
    @Then("the response status is {int}")
    public void theResponseStatusIs(int status) {
        response.then()
                .statusCode(status);
    }

    /**
     * Validates the response base value.
     */
    @And("the response base value is {string}")
    public void theResponseBaseValueIs(String baseValue) {
        response.then()
                .assertThat()
                .body("base", equalTo(baseValue));
    }

    /**
     * Validates that the response rates value is an object with keys and double values.
     */
    @And("the response rates value is an object with keys {string} and double values")
    public void theResponseRatesHasKeysAndValues(String symbolsString) {
        String[] symbols = symbolsString.split(",");

        Map<String, Double> rates = response.jsonPath()
                .getMap("rates", String.class, Double.class);

        assertThat(rates.keySet(), containsInAnyOrder(symbols));
    }

    /**
     * Validates that the response rates in result not empty.
     */
    @And("the response rates value is not empty")
    public void theResponseRatesIsNotEmpty() {
        Map<String, Double> rates = response.jsonPath()
                .getMap("rates", String.class, Double.class);

        assertThat(rates, is(not(anEmptyMap())));
    }

    /**
     * Checks that a response date exists with valid date format
     */
    @And("the response date is available")
    public void theResponseDateIsAvailable() {
        // verifies format as well
        LocalDate responseDate = parseResponseDate();

        assertThat("response date", responseDate, is(notNullValue()));
    }

    /**
     * Compares the response date with the dateSpec date - either "current" or a specific date.
     */
    @And("the response date is the specific date {string}")
    public void theResponseDateIsTheSpecificDate(String specificDate) {
        LocalDate expectedDate = parseExpectedDate(specificDate);
        LocalDate responseDate = parseResponseDate();

        assertThat("response date", responseDate, equalTo(expectedDate));
    }

    @And("the response date matches the response date for {string} rates")
    public void theResponseDateMatchesTheResponseDateForRates(String dateSpec) {
        LocalDate expectedDate = getDateFromIndependentRequest(dateSpec);

        theResponseDateIsTheSpecificDate(expectedDate.toString());
        log.info("response date matches date for response for '{}': {}", dateSpec, expectedDate);
    }

    /**
     * Used to make a separate call within a scenario to get the date of another request.
     * Saves the current request temporarily while making another request, so this classes methods
     * may be used, but returns the state to the same as when it was called.
     */
    private LocalDate getDateFromIndependentRequest(String dateSpec) {
        // save the working response, as to use the 'response' for an independent request
        Response original = this.response;

        iSubmitAGETRequestForRates(dateSpec);
        LocalDate expectedDate = parseResponseDate();

        // reinstate the working response
        response = original;

        return expectedDate;
    }

    private LocalDate parseExpectedDate(String date) {
        try {
            return LocalDate.parse(date);
        } catch (DateTimeParseException x) {
            // just throw a new error with a better description to fail the test
            throw new RuntimeException("Invalid specific date used in the test (" + date + ")!", x);
        }
    }

    private LocalDate parseResponseDate() {
        String date = response.jsonPath().getString("date");
        try {
            return LocalDate.parse(date);
        } catch (DateTimeParseException x) {
            // just throw a new error with a better description to fail the test
            throw new RuntimeException("Date response value (" + date + ") is not a date", x);
        }
    }

    /**
     * Converting a date spec into string for use in the request URL path.
     */
    private String requestDateSpecAsPath(String dateSpec) {
        if ("future".equals(dateSpec)) {
            return LocalDate.now().plusDays(1).toString();
        }
        return dateSpec;
    }
}

