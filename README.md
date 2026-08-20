# Pharmaceutical Sales & Market Performance Dashboard

An interactive Tableau commercial analytics dashboard built on simulated Medicare Part D drug spending data. This project models pharmaceutical spending, claim volumes, cost efficiency metrics, and geographic utilization across key therapeutic areas and drug manufacturers (including Amgen, AbbVie, BMS, and Merck).

---

## 📌 Dashboard Preview

![Dashboard Overview](assets/dashboard_overview.png)

> **Live Interactive Version:** [Link to Tableau Public Profile](#) *(Replace with your actual Tableau Public link)*

---

## 📂 Repository Structure

```text
├── assets/                       # High-res screenshots and dashboard preview GIFs
├── scripts/                      # Technical references for Calculated Fields & LOD formulas
├── DATA_DICTIONARY.md            # Field definitions and schema documentation
├── INSIGHTS.md                   # Commercial analysis & executive takeaways
├── Pharma_Market_Dataset_Tableau.xlsx  # Relational source dataset
├── Pharmaceutical_Sales_Dashboard.twbx # Packaged Tableau Workbook
└── README.md                     # Project overview and documentation

## Data Model (SQL)

The dashboard's underlying star schema was engineered and validated in SQL before being visualized in Tableau — the fact/dimension tables and metric queries live in [`schema.sql`](./schema.sql) and [`queries.sql`](./queries.sql).

**Schema**
- `Fact_Spending` — monthly CMS Medicare Part D spending, claims, and dosage units by drug, manufacturer, and state
- `Dim_Drug` — brand name, generic name, therapeutic category
- `Dim_Manufacturer` — manufacturer name

**Key queries (see `queries.sql` for full commented versions)**
1. **Cost per Claim by drug** — unit economics across 8 flagship pharmaceutical assets
2. **Market share by therapeutic category** — % of total spend across 4 therapeutic categories
3. **Top-spending state per drug** (`RANK() OVER (PARTITION BY ...)`) — informs field sales allocation and market access strategy
4. **Month-over-month spending trend** (`LAG() OVER (...)`) — tracks overall market growth/decline
5. **Manufacturer market share and rank** — competitive benchmarking across the portfolio

All metrics were validated against the Tableau dashboard's outputs to confirm the SQL data model and the BI layer agree — e.g., total spending in the SQL layer reconciles to the $27B+ figure shown on the dashboard.

**Tools used:** SQLite (data modeling and query development), Tableau (visualization)
