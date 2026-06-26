"""
BasePage
DigiPay QA — Page Object Model foundation
All page classes inherit from here.
"""
from browser import Browser          # robotframework-browser Python API
from variables import DEFAULT_TIMEOUT


class BasePage:
    """
    Provides resilient, reusable wrappers around robotframework-browser
    primitives.  Every specific page inherits these helpers so test code
    never calls low-level browser keywords directly.
    """

    def __init__(self, browser: Browser):
        self.browser = browser
        self.timeout = DEFAULT_TIMEOUT

    # ── Waiting helpers ─────────────────────────────────────────────────────

    def wait_for_element(self, selector: str, state: str = "visible"):
        """Wait until an element reaches the expected state."""
        self.browser.wait_for_elements_state(
            selector, state, timeout=f"{self.timeout}ms"
        )

    def wait_for_url_contains(self, partial_url: str):
        self.browser.wait_until_location_contains(
            partial_url, timeout=f"{self.timeout}ms"
        )

    # ── Interaction helpers ──────────────────────────────────────────────────

    def click(self, selector: str):
        self.wait_for_element(selector)
        self.browser.click(selector)

    def fill(self, selector: str, value: str):
        self.wait_for_element(selector)
        self.browser.fill_text(selector, value)

    def clear_and_fill(self, selector: str, value: str):
        self.wait_for_element(selector)
        self.browser.clear_text(selector)
        self.browser.fill_text(selector, value)

    # ── Assertion helpers ────────────────────────────────────────────────────

    def element_should_be_visible(self, selector: str):
        self.wait_for_element(selector, "visible")

    def element_should_contain_text(self, selector: str, expected: str):
        self.wait_for_element(selector)
        self.browser.get_text(selector)          # triggers wait
        actual = self.browser.get_text(selector)
        assert expected in actual, (
            f"Expected '{expected}' in element text but got '{actual}'"
        )

    def page_should_contain_text(self, text: str):
        self.browser.get_text("body")            # ensure page is loaded
        content = self.browser.get_text("body")
        assert text in content, (
            f"Page does not contain expected text: '{text}'"
        )

    # ── Screenshot helper ────────────────────────────────────────────────────

    def take_screenshot(self, name: str):
        self.browser.take_screenshot(filename=f"reports/screenshots/{name}.png")
