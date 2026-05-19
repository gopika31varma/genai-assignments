Feature: Login to OpenTaps

  Scenario Outline: Successful login with valid credentials
    Given I open the login page
    When I type "<username>" into the Username field
    And I type "<password>" into the Password field
    And I click the Login button
    Then I should be logged in successfully

  Examples:
    | username   | password  |
    | "demosalesmanager"    | "crmsfa"|
    | "demomarketinguser"    | "crmsfa"|
    | "demopurchaseuser"    | "crmsfa"|

import pytest
from pytest_bdd import given, when, then, scenarios, parsers
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

scenarios("login.feature")

@pytest.fixture
def driver():
    d = webdriver.Chrome()
    d.maximize_window()
    yield d
    d.quit()

@pytest.fixture
def wait(driver):
    return WebDriverWait(driver, 10)

@given("I open the login page")
def open_login_page(driver):
    driver.get("https://leaftaps.com/opentaps/control/main")

@when(parsers.parse('I type "{username}" into the Username field'))
def enter_username(driver, wait, username):
    el = wait.until(EC.element_to_be_clickable((By.ID, "username")))
    el.send_keys(username)

@when(parsers.parse('I type "{password}" into the Password field'))
def enter_password(driver, wait, password):
    el = wait.until(EC.element_to_be_clickable((By.ID, "password")))
    el.send_keys(password)

@when("I click the Login button")
def click_login(driver, wait):
    el = wait.until(EC.element_to_be_clickable((By.XPATH, "//input[@class='decorativeSubmit']")))
    el.click()

@then("I should be logged in successfully")
def verify_login(driver, wait):
    success = wait.until(EC.visibility_of_element_located((By.XPATH, "//h2")))
    assert success.text == "Dashboard"