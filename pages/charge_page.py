"""
ChargePage
DigiPay QA — Page Object for the خرید شارژ (charge purchase) mini-app.

Typical flow:
  1. Enter target phone number
  2. Select operator (auto-detected or manual)
  3. Select charge amount
  4. Confirm purchase
  5. Enter wallet PIN / payment password
  6. See success screen
"""
from pages.base_page import BasePage


class ChargePage(BasePage):

    # ── Selectors ────────────────────────────────────────────────────────────
    PAGE_TITLE        = "text=خرید شارژ, h1:has-text('شارژ'), [class*='title']:has-text('شارژ')"
    PHONE_INPUT       = "input[type='tel'], input[placeholder*='شماره'], input[placeholder*='موبایل']"
    OPERATOR_SECTION  = "[class*='operator'], [class*='Operator']"
    AMOUNT_LIST       = "[class*='amount'], [class*='Amount'], [class*='price']"
    AMOUNT_OPTION     = lambda self, val: f"text={val} تومان, [data-amount='{val}'], button:has-text('{val}')"
    CONFIRM_BUTTON    = "button:has-text('پرداخت'), button:has-text('خرید'), button:has-text('تأیید')"
    PIN_INPUT         = "input[type='password'], input[placeholder*='رمز'], input[placeholder*='PIN']"
    PIN_CONFIRM_BTN   = "button:has-text('تأیید'), button:has-text('پرداخت'), button[type='submit']"
    SUCCESS_MESSAGE   = "text=موفق, text=خرید انجام شد, [class*='success'], [class*='Success']"
    ERROR_MESSAGE     = "[class*='error'], [class*='Error'], [role='alert']"

    # ── Actions ──────────────────────────────────────────────────────────────

    def enter_target_phone(self, phone: str):
        self.wait_for_element(self.PAGE_TITLE)
        self.clear_and_fill(self.PHONE_INPUT, phone)

    def select_amount(self, amount: str):
        """Click the charge amount tile matching `amount` (numeric string)."""
        self.wait_for_element(self.AMOUNT_LIST)
        self.click(self.AMOUNT_OPTION(amount))

    def confirm_purchase(self):
        self.click(self.CONFIRM_BUTTON)

    def enter_payment_pin(self, pin: str):
        """Enter wallet/payment PIN on the confirmation dialog."""
        self.wait_for_element(self.PIN_INPUT)
        self.fill(self.PIN_INPUT, pin)
        self.click(self.PIN_CONFIRM_BTN)

    # ── Compound flow ─────────────────────────────────────────────────────────

    def complete_charge_purchase(self, phone: str, amount: str, pin: str = ""):
        """
        Full happy-path charge purchase.
        `pin` is optional — pass empty string if the app skips PIN in test env.
        """
        self.enter_target_phone(phone)
        self.select_amount(amount)
        self.confirm_purchase()
        if pin:
            self.enter_payment_pin(pin)

    # ── Assertions ────────────────────────────────────────────────────────────

    def charge_page_should_be_loaded(self):
        self.element_should_be_visible(self.PAGE_TITLE)
        self.element_should_be_visible(self.PHONE_INPUT)

    def success_screen_should_be_visible(self):
        self.element_should_be_visible(self.SUCCESS_MESSAGE)

    def error_message_should_be_visible(self):
        self.element_should_be_visible(self.ERROR_MESSAGE)
