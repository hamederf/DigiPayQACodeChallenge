# Design Notes — Selector Strategy & Anti-Flakiness

## 1. Selector Priority Order

Selectors are chosen according to this priority ladder (most stable → least stable):

```
1. data-testid / data-qa  (ideal — survives refactors, invisible to users)
2. ARIA role + accessible name  (e.g. role=button[name='پرداخت'])
3. Stable CSS class  (class fragments like [class*='submit'] avoid full-name coupling)
4. Visible text  (used when text is part of the product contract, e.g. tile labels)
5. Positional / nth-child  ← AVOIDED — breaks on layout changes
```

### Why not XPath?
XPath is brittle in SPAs: the DOM structure re-renders on every route change.  
CSS + text selectors bind to semantics, not structure.

### Current state
DigiPay (`app.mydigipay.com`) does not expose `data-testid` attributes on most elements.  
Until the front-end team adds them, we use **text selectors** for tiles and **CSS type + attribute selectors** for inputs.  
All selectors are centralised in `steps/selectors.robot` so updates require a single-file change.

---

## 2. Anti-Flakiness Techniques

### 2.1 Explicit waits — never `Sleep`
Every interaction is preceded by `Wait For Elements State ... visible`.  
This replaces fixed `Sleep` calls, which break on slow networks and are wasteful on fast ones.

```robot
# ✅ Do this
Wait For Elements State    ${OTP_INPUT}    visible
Fill Text                  ${OTP_INPUT}    ${otp}

# ❌ Never this
Sleep    2s
Fill Text    ${OTP_INPUT}    ${otp}
```

### 2.2 Global timeout configured once
`DEFAULT_TIMEOUT` (default 30 s) is set in `variables.py` and applied at suite setup:

```robot
Set Browser Timeout    ${DEFAULT_TIMEOUT}ms
```

Individual keywords inherit this; overrides are explicit, not scattered.

### 2.3 `Clear Text` before `Fill Text`
SPA input fields sometimes retain previous values across navigation.  
We always call `Clear Text` before filling to prevent stale data from causing assertion failures.

### 2.4 Fallback selectors for dynamic tiles
The hub mini-app grid can render with different class names depending on A/B variants.  
`HubPage.navigate_to_charge_purchase()` tries the primary text selector first, then falls back to an href/data-attribute alternative — both in the same keyword, no test-level change needed.

### 2.5 Failure screenshots at test teardown
```robot
Test Teardown    Run Keyword If Test Failed
...              Take Screenshot    filename=reports/screenshots/${TEST NAME}-failure.png
```
Every failed test captures a screenshot automatically, providing immediate visual evidence without manual reproduction.

### 2.6 Suite-level login, not per-test
Login is performed once per suite (`Suite Setup`) for charge tests.  
Re-logging in before every charge test multiplies OTP latency and is an unnecessary failure point.

### 2.7 Atomic commits & feature branch workflow
Each logical change is a separate commit (e.g., `feat: add LoginPage POM`, `test: TC-LOGIN-01 happy path`).  
This makes bisecting failures trivial and keeps the PR diff readable.

---

## 3. Known Limitations & Future Improvements

| Item | Current state | Improvement |
|---|---|---|
| `data-testid` | Not available in production | Request front-end team to add them |
| OTP automation | OTP received via SMS — manual step in local runs | Integrate with a test SMS gateway or mock OTP endpoint |
| Parallel execution | Sequential (pabot installed but not wired) | Add `pabot` runner for tag-based parallel execution |
| Visual regression | Not implemented | Add Percy or Applitools integration |
| Test data isolation | Shared phone numbers | Use a test-account provisioning service per run |
