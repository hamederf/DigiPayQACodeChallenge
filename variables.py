"""
Test Variables & Configuration
DigiPay QA Automation Suite
"""
import os
from dotenv import load_dotenv

load_dotenv()

# ─── URLs ───────────────────────────────────────────────────────────────────
BASE_URL = os.getenv("BASE_URL", "https://app.mydigipay.com")

# ─── Credentials ─────────────────────────────────────────────────────────────
VALID_PHONE   = os.getenv("DIGIPAY_PHONE", "09120000000")
VALID_OTP     = os.getenv("DIGIPAY_OTP",   "123456")
INVALID_PHONE = "09000000000"
INVALID_OTP   = "000000"

# ─── Charge Purchase Data ────────────────────────────────────────────────────
CHARGE_PHONE_IRANCELL  = os.getenv("CHARGE_PHONE_IRANCELL",  "09120000001")
CHARGE_PHONE_HAMRAHAVVAL = os.getenv("CHARGE_PHONE_HAMRAHAVVAL", "09910000001")
CHARGE_AMOUNT_1000     = "1000"
CHARGE_AMOUNT_2000     = "2000"

# ─── Browser Config ──────────────────────────────────────────────────────────
BROWSER          = os.getenv("BROWSER", "chromium")
HEADLESS         = os.getenv("HEADLESS", "true").lower() == "true"
SLOW_MO          = int(os.getenv("SLOW_MO", "0"))
DEFAULT_TIMEOUT  = int(os.getenv("DEFAULT_TIMEOUT", "30000"))   # ms
RETRY_COUNT      = int(os.getenv("RETRY_COUNT", "2"))

# ─── Paths ───────────────────────────────────────────────────────────────────
REPORTS_DIR      = "reports"
SCREENSHOTS_DIR  = "reports/screenshots"
