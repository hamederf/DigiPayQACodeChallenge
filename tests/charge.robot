*** Settings ***
Documentation       Charge Purchase feature — E2E scenarios for DigiPay خرید شارژ mini-app.
Metadata            Author       DigiPay QA Suite
Metadata            Version      1.0.0

Library             Browser
Resource            ${CURDIR}/../steps/login_steps.robot
Resource            ${CURDIR}/../steps/charge_steps.robot
Resource            ${CURDIR}/../steps/selectors.robot
Variables           ${CURDIR}/../variables.py

Suite Setup         Run Keywords
...                 Open DigiPay Application    AND
...                 User Logs In With Valid Credentials    AND
...                 User Should Be On Hub Page
Suite Teardown      Close DigiPay Application
Test Setup          User Navigates To Charge Purchase
Test Teardown       Take Screenshot    filename=reports/screenshots/${TEST NAME}.png


*** Test Cases ***

TC-CHARGE-01: Successful Charge Purchase For Irancell Number
    [Documentation]    GIVEN the user is logged in
    ...                WHEN they buy 1000 toman charge for an Irancell number
    ...                THEN the purchase should complete successfully
    [Tags]    charge    smoke    happy-path    irancell    TC-CHARGE-01

    Charge Page Should Be Loaded
    User Enters Target Phone "${CHARGE_PHONE_IRANCELL}"
    User Selects Charge Amount "${CHARGE_AMOUNT_1000}"
    User Clicks Confirm Purchase
    Purchase Success Should Be Displayed


TC-CHARGE-02: Successful Charge Purchase For Hamrah Avval Number
    [Documentation]    GIVEN the user is logged in
    ...                WHEN they buy 2000 toman charge for a Hamrah Avval number
    ...                THEN the purchase should complete successfully
    [Tags]    charge    smoke    happy-path    hamrah-avval    TC-CHARGE-02

    Charge Page Should Be Loaded
    User Enters Target Phone "${CHARGE_PHONE_HAMRAHAVVAL}"
    User Selects Charge Amount "${CHARGE_AMOUNT_2000}"
    User Clicks Confirm Purchase
    Purchase Success Should Be Displayed
