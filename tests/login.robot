*** Settings ***
Documentation       Login feature — E2E scenarios for DigiPay authentication.
Metadata            Author       DigiPay QA Suite
Metadata            Version      1.0.0

Library             Browser
Resource            ${CURDIR}/../steps/login_steps.robot
Resource            ${CURDIR}/../steps/selectors.robot
Variables           ${CURDIR}/../variables.py

Suite Setup         Open DigiPay Application
Suite Teardown      Close DigiPay Application
Test Teardown       Take Screenshot    filename=reports/screenshots/${TEST NAME}.png


*** Test Cases ***

TC-LOGIN-01: Successful Login With Valid Phone And OTP
    [Documentation]    GIVEN the user is on the DigiPay login page
    ...                WHEN they enter a valid phone number and correct OTP
    ...                THEN they should be redirected to the hub page
    [Tags]    login    smoke    happy-path    TC-LOGIN-01

    The Login Page Is Open
    User Enters Phone Number "${VALID_PHONE}"
    User Submits Phone Number
    OTP Screen Should Be Displayed
    User Enters OTP "${VALID_OTP}"
    User Confirms OTP
    User Should Be On Hub Page


TC-LOGIN-02: Failed Login With Invalid OTP
    [Documentation]    GIVEN the user is on the DigiPay login page
    ...                WHEN they enter a valid phone number but a wrong OTP
    ...                THEN an error message should be displayed
    [Tags]    login    negative    TC-LOGIN-02

    The Login Page Is Open
    User Enters Phone Number "${VALID_PHONE}"
    User Submits Phone Number
    OTP Screen Should Be Displayed
    User Enters OTP "${INVALID_OTP}"
    User Confirms OTP
    Login Error Should Be Displayed


*** Keywords ***

The Login Page Is Open
    Go To                      ${BASE_URL}
    Wait For Elements State    ${PHONE_INPUT}    visible
