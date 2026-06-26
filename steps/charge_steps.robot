*** Settings ***
Documentation       Charge purchase step definitions — reusable BDD keywords.
Library             Browser
Variables           variables.py
Resource            steps/login_steps.robot


*** Keywords ***

# ── Navigation ────────────────────────────────────────────────────────────────

User Navigates To Charge Purchase
    [Documentation]    Click the "خرید شارژ" tile on the hub.
    Wait For Elements State    ${CHARGE_TILE}    visible
    Click                      ${CHARGE_TILE}

Charge Page Should Be Loaded
    [Documentation]    Verify the charge purchase page rendered correctly.
    Wait For Elements State    ${CHARGE_PAGE_TITLE}    visible
    Wait For Elements State    ${CHARGE_PHONE_INPUT}    visible

# ── Input Steps ───────────────────────────────────────────────────────────────

User Enters Target Phone "${phone}"
    [Documentation]    Fill in the destination phone number for the charge.
    Wait For Elements State    ${CHARGE_PHONE_INPUT}    visible
    Clear Text                 ${CHARGE_PHONE_INPUT}
    Fill Text                  ${CHARGE_PHONE_INPUT}    ${phone}

User Selects Charge Amount "${amount}"
    [Documentation]    Select a charge amount tile from the list.
    Wait For Elements State    ${AMOUNT_LIST}    visible
    Click                      //button[contains(text(),'${amount}')] | //div[contains(text(),'${amount}')]

User Clicks Confirm Purchase
    [Documentation]    Click the پرداخت / خرید confirm button.
    Click    ${CONFIRM_BUTTON}

# ── Assertion Steps ────────────────────────────────────────────────────────────

Purchase Success Should Be Displayed
    [Documentation]    Assert the success confirmation screen is shown.
    Wait For Elements State    ${SUCCESS_MESSAGE}    visible

Charge Error Should Be Displayed
    [Documentation]    Assert an error banner / message is visible.
    Wait For Elements State    ${CHARGE_ERROR_MESSAGE}    visible
