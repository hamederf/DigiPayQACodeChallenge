*** Settings ***
Documentation       Login step definitions — reusable BDD keywords.
Library             Browser
Library             OperatingSystem
Variables           variables.py


*** Keywords ***

# ── Setup / Teardown ────────────────────────────────────────────────────────

Open DigiPay Application
    [Documentation]    Launch Chromium and navigate to the DigiPay base URL.
    New Browser         browser=${BROWSER}    headless=${HEADLESS}
    New Context         viewport={'width': 390, 'height': 844}
    New Page            ${BASE_URL}
    Set Browser Timeout    ${DEFAULT_TIMEOUT}ms

Close DigiPay Application
    [Documentation]    Capture final screenshot and close all browser contexts.
    Run Keyword If Test Failed    Take Screenshot    filename=reports/screenshots/failure-{index}.png
    Close Browser

# ── Phone Number Step ────────────────────────────────────────────────────────

User Enters Phone Number "${phone}"
    [Documentation]    Fill the phone input field with the given number.
    Wait For Elements State    ${PHONE_INPUT}    visible
    Fill Text                  ${PHONE_INPUT}    ${phone}

User Submits Phone Number
    [Documentation]    Click the continue / submit button on the phone screen.
    Click    ${SUBMIT_BUTTON}

# ── OTP Step ────────────────────────────────────────────────────────────────

OTP Screen Should Be Displayed
    [Documentation]    Assert that the OTP input is now visible.
    Wait For Elements State    ${OTP_INPUT}    visible

User Enters OTP "${otp}"
    [Documentation]    Fill the OTP field.
    Wait For Elements State    ${OTP_INPUT}    visible
    Fill Text                  ${OTP_INPUT}    ${otp}

User Confirms OTP
    [Documentation]    Click the OTP confirm button.
    Click    ${OTP_CONFIRM_BTN}

# ── Compound login keyword ────────────────────────────────────────────────────

User Logs In With Valid Credentials
    [Documentation]    Full happy-path login using env variables.
    User Enters Phone Number "${VALID_PHONE}"
    User Submits Phone Number
    OTP Screen Should Be Displayed
    User Enters OTP "${VALID_OTP}"
    User Confirms OTP

# ── Assertion keywords ────────────────────────────────────────────────────────

User Should Be On Hub Page
    [Documentation]    Verify the hub / home page is visible after login.
    Wait For Elements State    ${HUB_CONTAINER}    visible

Login Error Should Be Displayed
    [Documentation]    Assert an error message is shown.
    Wait For Elements State    ${ERROR_MESSAGE}    visible
