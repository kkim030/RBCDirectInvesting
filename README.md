# RBC Direct Investing — App Improvement Prototype

Why? Wanted to solve friction points I ran into using RBC Direct Investing daily: no combined view of my banking + investing accounts, no portfolio allocation chart on mobile, and no way to set up recurring investments.

I rebuilt the app's navigation and visual design to match what the real RBC Direct Investing app actually looks like.

**[Read the full PRD](PRD.pdf)** for the problem analysis, evidence, and success criteria behind each feature.

**[Test out the demo](https://appetize.io/app/b_l2hvvb7heqfzwuww2i52vco5ae)** to launch the application on desktop and test out the demo. When launched, scroll down and click *demo account*.

---

## What I Changed (and Why)

### Unified Account Dashboard

Merged Personal Banking (Chequing, Savings, Credit Line) and Direct Investing (TFSA, RRSP, FHSA) into one Home screen with a combined net-worth card at the top.

<p align="center">
  <img width="270" alt="Home — combined balance" src="https://github.com/user-attachments/assets/bd4d8e32-79b9-4e82-bdef-67455b2a20e6" />
  &nbsp;&nbsp;
  <img width="270" alt="Home — banking detail" src="https://github.com/user-attachments/assets/9eda577c-e888-4aa7-a296-bfc2a26b11cb" />
</p>

### Portfolio Allocation Breakdown

The desktop Trading Dashboard has a full Portfolio Analyzer with asset-class, sector, and regional breakdowns. On mobile? You get a flat list of holdings.
I brought a version of this to mobile — an interactive donut chart showing percentage allocation across all holdings. You can toggle between grouping by holding or by sector.

<p align="center">
  <img width="270" alt="Allocation by holding" src="https://github.com/user-attachments/assets/ca285465-e697-4055-ba8e-5c5455b75a13" />
  &nbsp;&nbsp;
  <img width="270" alt="Allocation by sector" src="https://github.com/user-attachments/assets/1f7f3e02-3714-4850-a46d-401d23dbbf33" />
</p>

### Auto-Invest

Added recurring buy orders for any stock or ETF, across all account types - for investors who desire to dollar cost average.

<p align="center">
  <img width="220" alt="Auto-invest setup" src="https://github.com/user-attachments/assets/090fa54e-3b49-4a3d-b64a-a496a3005e4e" />
  &nbsp;&nbsp;
  <img width="220" alt="Auto-invest form" src="https://github.com/user-attachments/assets/f30f669f-29b9-4e6f-9e57-9aa95f70680c" />
  &nbsp;&nbsp;
  <img width="220" alt="Auto-invest rules" src="https://github.com/user-attachments/assets/87fc7506-39be-4f34-8552-8daaef0837c3" />
</p>

<p align="center">
  <img width="270" alt="Auto-invest confirmation" src="https://github.com/user-attachments/assets/5933e2ed-5212-4262-8f0e-a0726aa268ea" />
</p>

---

## Tech Stack

| | |
|---|---|
| **iOS** | SwiftUI (iOS 17+), Swift 5.9, MVVM |
| **Charts** | DGCharts 5.1.0 via SPM (UIViewRepresentable wrapper) |
| **Backend** | Spring Boot 3.2.3, Java 21 |
| **Database** | PostgreSQL (prod) / H2 in-memory (demo) |
| **Project Gen** | XcodeGen (`project.yml` &rarr; `.xcodeproj`) |

## Running Locally

```bash
# Generate the Xcode project
brew install xcodegen
xcodegen generate

# Open in Xcode and run on a simulator
open RBCInvesting.xcodeproj

# (Optional) Start the backend for live data
cd rbc-api
./mvnw spring-boot:run -Dspring-boot.run.profiles=demo
```

---

## Project Structure

```
RBCInvesting/
  App/                  # Entry point, assets
  Models/               # Data models (Auth, Account, Holding, Order, etc.)
  Views/
    Auth/               # Login, Register
    Dashboard/          # HomeView, BankingAccountCard, PortfolioAllocationSection
    Holdings/           # HoldingsView with sort & filter
    Transfers/          # TransfersView, AutoInvestView, AutoInvestSetupSheet
    Quotes/             # QuotesView with search & sparklines
    More/               # MoreView (settings, order status)
    Charts/             # PieChartRepresentable (DGCharts wrapper)
    Components/         # MainTabView, FABButton, QuickActionsSheet
  ViewModels/           # PortfolioVM, AuthVM, BankingVM, AutoInvestVM, etc.
  Services/             # APIService
  Extensions/           # Theme colors, modifiers, reusable components
rbc-api/                # Spring Boot backend
PRD.pdf                 # Product Requirements Document
```

---

*Built by Kelly Kim*
