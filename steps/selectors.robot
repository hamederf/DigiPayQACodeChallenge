*** Settings ***
Documentation    Central selector registry — single source of truth for all locators.


*** Variables ***

# ════════════════════════════════════════════════════════════════════════════
# LOGIN PAGE
# ════════════════════════════════════════════════════════════════════════════
${PHONE_INPUT}         css=input[inputmode='numeric'][maxlength='11']
${SUBMIT_BUTTON}       css=button.ngx-button.style-fill
${OTP_INPUT}           css=input[inputmode='numeric'][maxlength='6']
${OTP_CONFIRM_BTN}     css=button.ngx-button.style-fill
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
${CHARGE_PHONE_INPUT}       css=input[inputmode='numeric'][maxlength='11']
${AMOUNT_LIST}              css=[class*='amount'],[class*='Amount'],[class*='price']
${CONFIRM_BUTTON}           text=پرداخت
${SUCCESS_MESSAGE}          text=موفق
${CHARGE_ERROR_MESSAGE}     css=[class*='error'],[role='alert']
