# Data Dictionary — Pharmaceutical Sales & Market Performance

This dataset models Medicare Part D drug spending, utilization, and manufacturing details across multiple states and therapeutic categories over a multi-year period.

---

## 📐 Data Schema Overview

The database utilizes a **Star Schema** architecture to optimize query performance and analytical flexibility:

       Dim_Drug (1) ──── (N)
                             \
                              Fact_Spending
                             /
  Dim_Manufacturer (1) ──── (N)

---

## 📊 Table Definitions

### 1. `Fact_Spending` (Fact Table)
Contains transaction-level financial, utilization, and volume metrics aggregated by month, state, drug, and manufacturer.

| Column Name | Data Type | Key Type | Description | Sample Value |
| :--- | :--- | :--- | :--- | :--- |
| `Date` | Date (`YYYY-MM-DD`) | Foreign Key | First day of the reporting month | `2023-01-01` |
| `Drug_ID` | Integer | Foreign Key | Unique identifier referencing `Dim_Drug` | `1` |
| `Manufacturer_ID` | Integer | Foreign Key | Unique identifier referencing `Dim_Manufacturer` | `1` |
| `State` | String (2-Char) | Geographic | Two-letter U.S. state postal abbreviation | `CA` |
| `Total_Spending` | Currency (`Decimal`) | Fact / Metric | Total gross Medicare Part D spending ($ USD) | `15000000.00` |
| `Total_Claims` | Integer | Fact / Metric | Total number of filled prescriptions/claims | `5000` |
| `Dosage_Units` | Integer | Fact / Metric | Total quantity of dosage units administered (e.g., pills, doses) | `20000` |

---

### 2. `Dim_Drug` (Dimension Table)
Contains brand, generic, and classification attributes for each pharmaceutical product.

| Column Name | Data Type | Key Type | Description | Sample Value |
| :--- | :--- | :--- | :--- | :--- |
| `Drug_ID` | Integer | Primary Key | Unique numeric identifier for the drug | `1` |
| `Brand_Name` | String | Attribute | Commercial brand name of the drug | `Enbrel` |
| `Generic_Name` | String | Attribute | Active chemical/pharmaceutical ingredient name | `Etanercept` |
| `Therapeutic_Category` | String | Attribute | Broad clinical classification of the drug | `Immunology` |

---

### 3. `Dim_Manufacturer` (Dimension Table)
Contains details regarding the pharmaceutical manufacturing entities.

| Column Name | Data Type | Key Type | Description | Sample Value |
| :--- | :--- | :--- | :--- | :--- |
| `Manufacturer_ID` | Integer | Primary Key | Unique numeric identifier for the manufacturer | `1` |
| `Manufacturer` | String | Attribute | Legal entity name of the pharmaceutical manufacturer | `Amgen` |

---

## 🧮 Calculated Fields & Business Metrics Reference

| Calculated Measure | Formula / Logic | Description |
| :--- | :--- | :--- |
| **Cost per Claim** | `SUM([Total_Spending]) / SUM([Total_Claims])` | Average gross cost incurred per prescription claim filled. |
| **Cost per Dosage Unit** | `SUM([Total_Spending]) / SUM([Dosage_Units])` | Average cost per individual dosage unit dispensed. |
| **Market Share (LOD)** | `SUM([Total_Spending]) / SUM({FIXED [Date], [State] : SUM([Total_Spending])})` | Dynamic market share percentage calculated against total market baseline. |
