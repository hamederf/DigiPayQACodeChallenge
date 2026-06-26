*** Settings ***
Documentation       Charge Purchase feature — E2E scenarios for DigiPay خرید شارژ mini-app.
...
...                 Scenarios:
...                   TC-CHARGE-01  Successful charge purchase for an Irancell number
...                   TC-CHARGE-02  Successful charge purchase for a Hamrah Avval number
...
Metadata            Author       DigiPay QA Suite
Metadata            Version      1.0.0

Library             Browser
Resource            steps/login_steps.robot
Resource            steps/charge_steps.robot
Resource            steps/selectors.robot
Variables           variables.py

Suite Setup         Run Keywords
...                 Open DigiPay Application    AND
...                 User Logs In With Valid Credentials    AND
...                 User Should Be On Hub Page
Suite Teardown      Close DigiPay Application
Test Setup          User Navigates To Charge Purchase
Test Teardown       Run Keyword If Test Failed
...                 Take Screenshot    filename=reports/screenshots/${TEST NAME}-failure.png


*** Test Cases ***

TC-CHARGE-01: Successful Charge Purchase For Irancell Number
    [Documentation]    GIVEN the user is logged in and on the hub
    ...                WHEN  they open خرید شارژ, enter an Irancell number and select 1000 تومان
    ...                THEN  the purchase should complete and a success screen should appear

    [Tags]    charge    smoke    happy-path    irancell    TC-CHARGE-01

    Given Charge Page Should Be Loaded
    When  User Enters Target Phone "${CHARGE_PHONE_IRANCELL}"
    And   User Selects Charge Amount "${CHARGE_AMOUNT_1000}"
    And   User Clicks Confirm Purchase
    Then  Purchase Success Should Be Displayed


TC-CHARGE-02: Successful Charge Purchase For Hamrah Avval Number
    [Documentation]    GIVEN the user is logged in and on the hub
    ...                WHEN  they open خرید شارژ, enter a Hamrah Avval number and select 2000 تومان
    ...                THEN  the purchase should complete and a success screen should appear

    [Tags]    charge    smoke    happy-path    hamrah-avval    TC-CHARGE-02

    Given Charge Page Should Be Loaded
    When  User Enters Target Phone "${CHARGE_PHONE_HAMRAHAVVAL}"
    And   User Selects Charge Amount "${CHARGE_AMOUNT_2000}"
    And   User Clicks Confirm Purchase
    Then  Purchase Success Should Be Displayed
