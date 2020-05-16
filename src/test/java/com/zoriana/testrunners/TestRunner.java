package com.zoriana.testrunners;

import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import org.junit.runner.RunWith;

/**
 * Created by Zorianka on 12/05/20.
 */
@RunWith(Cucumber.class)
@CucumberOptions(features = "src/test/resources/features",
        glue = "com.zoriana.steps",
        plugin = {"pretty", "html:target/cucumber-reports", "json:target/cucumber.json", "html:target/site/cucumber-pretty"},
        strict = true,
        monochrome = true)

public class TestRunner {
}

