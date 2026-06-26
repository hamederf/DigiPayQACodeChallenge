*** Settings ***
Documentation    Central selector registry — single source of truth for all locators.
...              Selector strategy: data-testid > aria role > stable CSS class > text.
...              Text selectors are used where element text is part of the contract
...              (i.e., visible to users and unlikely to change without a product decision).


*** Variables ***

# ════════════════════════════════════════════════════════════════════════════
# LOGIN PAGE
# ════════════════════════════════════════════════════════════════════════════
${PHONE_INPUT}         css=input[type='tel']
${SUBMIT_BUTTON}       css=button[type='submit']
${OTP_INPUT}           css=input[type='number'][maxlength='6']
${OTP_CONFIRM_BTN}     css=button[type='submit']
${ERROR_MESSAGE}       css=[class*='error'],[role='alert']

# ════════════════════════════════════════════════════════════════════════════
# HUB PAGE
# ════════════════════════════════════════════════════════════════════════════
${HUB_CONTAINER}       css=main,[class*='hub'],[class*='Hub']
${CHARGE_TILE}         text=خرید شارژ

# ════════════════════════════════════════════════════════════════════════════
# CHARGE PURCHASE PAGE
# ════════════════════════════════════════════════════════════════════════════
${CHARGE_PAGE_TITLE}        text=خرید شارژ
${CHARGE_PHONE_INPUT}       css=input[type='tel']
${AMOUNT_LIST}              css=[class*='amount'],[class*='Amount'],[class*='price']
${CONFIRM_BUTTON}           text=پرداخت
${SUCCESS_MESSAGE}          text=موفق
${CHARGE_ERROR_MESSAGE}     css=[class*='error'],[role='alert']
