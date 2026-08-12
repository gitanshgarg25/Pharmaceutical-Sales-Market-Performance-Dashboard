# Data Dictionary — Pharmaceutical Sales & Market Performance

This dataset models Medicare Part D drug spending, utilization, and manufacturing details across multiple states and therapeutic categories over a multi-year period.

---

## 📐 Data Schema Overview

The database utilizes a **Star Schema** architecture to optimize query performance and analytical flexibility:

```text
       Dim_Drug (1) ──── (N)
                             \
                              Fact_Spending
                             /
  Dim_Manufacturer (1) ──── (N)
