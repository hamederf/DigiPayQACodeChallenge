*** Settings ***
Documentation       Login feature — E2E scenarios for DigiPay authentication.
...
...                 Scenarios:
...                   TC-LOGIN-01  Successful login with valid phone and OTP
...                   TC-LOGIN-02  Failed login attempt with invalid OTP
...
Metadata            Author       DigiPay QA Suite
Metadata            Version      1.0.0

Library             Browser
Resource            steps/login_steps.robot
Resource            steps/selectors.robot
Variables           variables.py

Suite Setup         Open DigiPay Application
Suite Teardown      Close DigiPay Application
Test Teardown       Run Keyword If Test Failed
...                 Take Screenshot    filename=reports/screenshots/${TEST NAME}-failure.png


*** Test Cases ***

TC-LOGIN-01: Successful Login With Valid Phone And OTP
    [Documentation]    GIVEN the user is on the DigiPay login page
    ...                WHEN  they enter a valid phone number and correct OTP
    ...                THEN  they should be redirected to the hub page

    [Tags]    login    smoke    happy-path    TC-LOGIN-01

    Given The Login Page Is Open
    When  User Enters Phone Number "${VALID_PHONE}"
    And   User Submits Phone Number
    Then  OTP Screen Should Be Displayed

    When  User Enters OTP "${VALID_OTP}"
    And   User Confirms OTP
    Then  User Should Be On Hub Page


TC-LOGIN-02: Failed Login With Invalid OTP
    [Documentation]    GIVEN the user is on the DigiPay login page
    ...                WHEN  they enter a valid phone number but a wrong OTP
    ...                THEN  an error message should be displayed and login should fail

    [Tags]    login    negative    TC-LOGIN-02

    Given The Login Page Is Open
    When  User Enters Phone Number "${VALID_PHONE}"
    And   User Submits Phone Number
    Then  OTP Screen Should Be Displayed

    When  User Enters OTP "${INVALID_OTP}"
    And   User Confirms OTP
    Then  Login Error Should Be Displayed


*** Keywords ***

The Login Page Is Open
    [Documentation]    Navigate to DigiPay and wait for the phone input to appear.
    Go To               ${BASE_URL}
    Wait For Elements State    ${PHONE_INPUT}    visible
