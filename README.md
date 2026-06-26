# DigiPay E2E Test Suite

Automated end-to-end tests for [DigiPay](https://app.mydigipay.com) covering the **login flow** and **خرید شارژ (charge purchase)** mini-app.

Built with **Robot Framework** + **robotframework-browser (Playwright)** following a **BDD / keyword-driven** style and **Page Object Model** architecture.

---

## Table of Contents

1. [Tech Stack](#tech-stack)
2. [Project Structure](#project-structure)
3. [Prerequisites](#prerequisites)
4. [Installation](#installation)
5. [Environment Variables](#environment-variables)
6. [Running the Tests](#running-the-tests)
7. [Docker](#docker)
8. [CI/CD](#cicd)
9. [Test Scenarios](#test-scenarios)
10. [Design Notes](#design-notes)

---

## Tech Stack

| Layer | Tool | Version |
|---|---|---|
| Test runner | Robot Framework | 7.x |
| Browser automation | robotframework-browser (Playwright) | 18.x |
| Browser | Chromium (headless) | bundled by Playwright |
| Language | Python | 3.12 |
| Parallel execution | robotframework-pabot | 2.x |
| CI | GitHub Actions | — |
| Containerization | Docker + Compose | — |

---

## Project Structure

```
DigiPayQACodeChallenge/
├── tests/
│   ├── login.robot          # Login feature (TC-LOGIN-01, TC-LOGIN-02)
│   └── charge.robot         # Charge purchase feature (TC-CHARGE-01, TC-CHARGE-02)
├── pages/
│   ├── base_page.py         # BasePage with shared helpers
│   ├── login_page.py        # LoginPage POM
│   ├── hub_page.py          # HubPage POM
│   └── charge_page.py       # ChargePage POM
├── steps/
│   ├── selectors.robot      # Central selector registry (single source of truth)
│   ├── login_steps.robot    # Login BDD keywords
│   └── charge_steps.robot   # Charge purchase BDD keywords
├── reports/                 # Generated; ignored by git
│   └── screenshots/
├── .github/
│   └── workflows/
│       └── ci.yml           # GitHub Actions pipeline
├── variables.py             # Test data & env-var loader
├── requirements.txt         # Python dependencies
├── Dockerfile               # Container image definition
├── docker-compose.yml       # Easy local Docker execution
├── .env.example             # Environment variable template
├── .gitignore
└── README.md
```

---

## Prerequisites

- Python **3.12+**
- pip
- Git
- (Optional) Docker & Docker Compose

---

## Installation

```bash
# 1. Clone the repo
git https://github.com/hamederf/DigiPayQACodeChallenge.git
cd DigiPayQACodeChallenge

# 2. (Recommended) Create a virtual environment
python -m venv .venv
source .venv/bin/activate      # Windows: .venv\Scripts\activate

# 3. Install Python dependencies
pip install -r requirements.txt

# 4. Install Playwright's Chromium browser
python -m Browser.entry init

# 5. Create your local .env file
cp .env.example .env
# → open .env and fill in real credentials
```

---

## Environment Variables

Copy `.env.example` → `.env` and fill in the values below.  
**Never commit the `.env` file.**  
For CI, add these as [GitHub Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets).

| Variable | Description | Example |
|---|---|---|
| `BASE_URL` | DigiPay base URL | `https://app.mydigipay.com` |
| `DIGIPAY_PHONE` | Valid registered phone number | `09120000000` |
| `DIGIPAY_OTP` | Valid OTP for the test account | `123456` |
| `CHARGE_PHONE_IRANCELL` | Irancell number to charge | `09120000001` |
| `CHARGE_PHONE_HAMRAHAVVAL` | Hamrah Avval number to charge | `09910000001` |
| `BROWSER` | Browser engine | `chromium` |
| `HEADLESS` | Run headless? | `true` / `false` |
| `SLOW_MO` | Slow-motion delay (ms) | `0` |
| `DEFAULT_TIMEOUT` | Global element timeout (ms) | `30000` |

---

## Running the Tests

### Run all tests

```bash
robot --outputdir reports tests/
```

### Run only login tests

```bash
robot --outputdir reports tests/login.robot
```

### Run only charge tests

```bash
robot --outputdir reports tests/charge.robot
```

### Run by tag

```bash
# Smoke tests only
robot --outputdir reports --include smoke tests/

# Negative scenarios
robot --outputdir reports --include negative tests/
```

### Run with visible browser (debug mode)

```bash
HEADLESS=false SLOW_MO=500 robot --outputdir reports tests/
```

### View the HTML report

After a run, open `reports/report.html` in your browser.

---

## Docker

### Build and run with Docker Compose

```bash
# Copy and fill in credentials
cp .env.example .env

# Build image and run all tests
docker-compose up --build

# Reports are written to ./reports/ on the host machine
```

### Build and run manually

```bash
docker build -t digipayqacodechallenge .

docker run --rm \
  -e DIGIPAY_PHONE=09120000000 \
  -e DIGIPAY_OTP=123456 \
  -e CHARGE_PHONE_IRANCELL=09120000001 \
  -e CHARGE_PHONE_HAMRAHAVVAL=09910000001 \
  -v "$(pwd)/reports:/app/reports" \
  DigiPayQACodeChallenge
```

---

## CI/CD

The GitHub Actions pipeline (`.github/workflows/ci.yml`) triggers on:

- Every **push** to `main`, `develop`, or `feature/**`
- Every **pull request** targeting `main` or `develop`
- Manual dispatch from the GitHub Actions UI

### Required GitHub Secrets

Add these under **Settings → Secrets and variables → Actions**:

```
BASE_URL
DIGIPAY_PHONE
DIGIPAY_OTP
CHARGE_PHONE_IRANCELL
CHARGE_PHONE_HAMRAHAVVAL
```

### Pipeline steps

```
1. Checkout code
2. Set up Python 3.12
3. Install pip dependencies
4. Install Playwright (Chromium)
5. Run login.robot
6. Run charge.robot
7. Merge outputs → final HTML report
8. Upload reports as GitHub artifact (14-day retention)
```

---

## Test Scenarios

| ID | Feature | Scenario | Type |
|---|---|---|---|
| TC-LOGIN-01 | Login | Successful login with valid phone & OTP | Happy path / Smoke |
| TC-LOGIN-02 | Login | Failed login with invalid OTP | Negative |
| TC-CHARGE-01 | Charge Purchase | Buy 1,000 تومان charge for Irancell number | Happy path / Smoke |
| TC-CHARGE-02 | Charge Purchase | Buy 2,000 تومان charge for Hamrah Avval number | Happy path / Smoke |

---

## Design Notes

See [DESIGN_NOTES.md](./DESIGN_NOTES.md) for the full explanation of:

- Selector strategy and priority order
- Anti-flakiness techniques used throughout the suite
- Trade-offs and future improvements
