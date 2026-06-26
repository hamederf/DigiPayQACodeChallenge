"""
HubPage
DigiPay QA — Page Object for the Mini-App Hub (home screen after login).

The hub shows a grid / list of mini-apps; we need to find and click
the "خرید شارژ" (charge purchase) card.
"""
from pages.base_page import BasePage


class HubPage(BasePage):

    # ── Selectors ────────────────────────────────────────────────────────────
    # Use text-based selectors for mini-app tiles — more stable than index.
    HUB_CONTAINER    = "[class*='hub'], [class*='Hub'], main, #main-content"
    CHARGE_TILE      = "text=خرید شارژ"
    # Fallback selectors (tried in order by the helper if primary fails)
    CHARGE_TILE_ALT  = "[href*='charge'], [data-testid*='charge'], a:has-text('شارژ')"
    USER_AVATAR      = "[class*='avatar'], [class*='profile'], [aria-label*='حساب']"

    # ── Assertions ───────────────────────────────────────────────────────────

    def hub_should_be_loaded(self):
        """Confirm the hub page is fully rendered after login."""
        self.wait_for_element(self.HUB_CONTAINER)
        self.wait_for_element(self.CHARGE_TILE)

    # ── Actions ──────────────────────────────────────────────────────────────

    def navigate_to_charge_purchase(self):
        """Click the خرید شارژ tile; fall back to alt selector if needed."""
        try:
            self.click(self.CHARGE_TILE)
        except Exception:
            self.click(self.CHARGE_TILE_ALT)
