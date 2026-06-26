"""
LoginPage
DigiPay QA — Page Object for the authentication flow.

DigiPay uses a two-step OTP login:
  Step 1 → enter mobile number → submit
  Step 2 → enter OTP code     → submit
"""
from pages.base_page import BasePage
from variables import BASE_URL


class LoginPage(BasePage):

    # ── Selectors ────────────────────────────────────────────────────────────
    # Strategy: prefer data-testid > aria roles > stable CSS classes.
    # Avoid positional / nth-child selectors to stay resilient to layout changes.

    PHONE_INPUT      = "input[type='tel'], input[placeholder*='موبایل'], input[placeholder*='شماره']"
    SUBMIT_BUTTON    = "button[type='submit'], button:has-text('ادامه'), button:has-text('ورود')"
    OTP_INPUT        = "input[type='number'][maxlength='6'], input[placeholder*='کد']"
    OTP_CONFIRM_BTN  = "button:has-text('تأیید'), button:has-text('ورود'), button[type='submit']"
    ERROR_MESSAGE    = "[class*='error'], [class*='Error'], [role='alert']"
    RESEND_OTP_LINK  = "button:has-text('ارسال مجدد'), a:has-text('ارسال مجدد')"

    # ── Navigation ───────────────────────────────────────────────────────────

    def open(self):
        self.browser.go_to(BASE_URL)
        self.wait_for_element(self.PHONE_INPUT)

    # ── Actions ──────────────────────────────────────────────────────────────

    def enter_phone_number(self, phone: str):
        self.clear_and_fill(self.PHONE_INPUT, phone)

    def submit_phone(self):
        self.click(self.SUBMIT_BUTTON)

    def enter_otp(self, otp: str):
        self.wait_for_element(self.OTP_INPUT)
        self.clear_and_fill(self.OTP_INPUT, otp)

    def submit_otp(self):
        self.click(self.OTP_CONFIRM_BTN)

    # ── Compound flows ───────────────────────────────────────────────────────

    def login_with_valid_credentials(self, phone: str, otp: str):
        """Full happy-path login: phone → OTP → home."""
        self.open()
        self.enter_phone_number(phone)
        self.submit_phone()
        self.enter_otp(otp)
        self.submit_otp()

    def attempt_login_with_invalid_phone(self, invalid_phone: str):
        """Submit an invalid phone number and stay on error state."""
        self.open()
        self.enter_phone_number(invalid_phone)
        self.submit_phone()

    def attempt_login_with_invalid_otp(self, phone: str, invalid_otp: str):
        """Valid phone but wrong OTP — expect error on OTP screen."""
        self.open()
        self.enter_phone_number(phone)
        self.submit_phone()
        self.enter_otp(invalid_otp)
        self.submit_otp()

    # ── Assertions ───────────────────────────────────────────────────────────

    def error_message_should_be_visible(self):
        self.element_should_be_visible(self.ERROR_MESSAGE)

    def otp_screen_should_be_visible(self):
        self.element_should_be_visible(self.OTP_INPUT)
