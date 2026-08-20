-- =========================================================
-- Pharmaceutical Sales & Market Performance Dashboard
-- Core Analytical Queries
-- Source: CMS Medicare Part D public spending data (2022)
-- =========================================================
-- Run against the schema defined in schema.sql
-- 1. COST PER CLAIM BY DRUG
-- Measures unit economics / efficiency per drug — a core pharma
-- commercial analytics metric (lower cost/claim = more efficient
-- claim-to-spend ratio for payers).
SELECT d.Brand_Name,
       d.Therapeutic_Category,
       SUM(f.Total_Spending) AS Total_Spending,
       SUM(f.Total_Claims)   AS Total_Claims,
       ROUND(SUM(f.Total_Spending) * 1.0 / SUM(f.Total_Claims), 2) AS Cost_Per_Claim
FROM Fact_Spending f
JOIN Dim_Drug d ON f.Drug_ID = d.Drug_ID
GROUP BY d.Brand_Name, d.Therapeutic_Category
ORDER BY Cost_Per_Claim DESC;


-- 2. MARKET SHARE BY THERAPEUTIC CATEGORY
-- Uses a scalar subquery to compute each category's % share
-- of total Medicare Part D spending in the dataset.
SELECT d.Therapeutic_Category,
       SUM(f.Total_Spending) AS Category_Spending,
       ROUND(100.0 * SUM(f.Total_Spending) /
             (SELECT SUM(Total_Spending) FROM Fact_Spending), 2) AS Market_Share_Pct
FROM Fact_Spending f
JOIN Dim_Drug d ON f.Drug_ID = d.Drug_ID
GROUP BY d.Therapeutic_Category
ORDER BY Category_Spending DESC;


-- 3. TOP-SPENDING STATE PER DRUG (WINDOW FUNCTION: RANK)
-- Identifies the highest-volume regional market for each drug —
-- used to inform field sales force allocation and market access strategy.
SELECT Brand_Name, State, State_Spending, Rank_In_Drug
FROM (
    SELECT d.Brand_Name,
           f.State,
           SUM(f.Total_Spending) AS State_Spending,
           RANK() OVER (PARTITION BY d.Brand_Name
                        ORDER BY SUM(f.Total_Spending) DESC) AS Rank_In_Drug
    FROM Fact_Spending f
    JOIN Dim_Drug d ON f.Drug_ID = d.Drug_ID
    GROUP BY d.Brand_Name, f.State
)
WHERE Rank_In_Drug = 1
ORDER BY State_Spending DESC;


-- 4. MONTH-OVER-MONTH SPENDING TREND (WINDOW FUNCTION: LAG)
-- Tracks overall market trend and % growth month to month.
SELECT strftime('%Y-%m', Date) AS Month,
       SUM(Total_Spending) AS Monthly_Spending,
       ROUND(100.0 * (SUM(Total_Spending) -
             LAG(SUM(Total_Spending)) OVER (ORDER BY strftime('%Y-%m', Date)))
             / LAG(SUM(Total_Spending)) OVER (ORDER BY strftime('%Y-%m', Date)), 2) AS MoM_Growth_Pct
FROM Fact_Spending
GROUP BY Month
ORDER BY Month;


-- 5. MANUFACTURER MARKET SHARE & RANK (WINDOW FUNCTION: RANK)
-- Rolls spending up to the manufacturer level to benchmark
-- competitive position across the therapeutic portfolio.
SELECT m.Manufacturer,
       SUM(f.Total_Spending) AS Total_Spending,
       ROUND(100.0 * SUM(f.Total_Spending) /
             (SELECT SUM(Total_Spending) FROM Fact_Spending), 2) AS Market_Share_Pct,
       RANK() OVER (ORDER BY SUM(f.Total_Spending) DESC) AS Manufacturer_Rank
FROM Fact_Spending f
JOIN Dim_Manufacturer m ON f.Manufacturer_ID = m.Manufacturer_ID
GROUP BY m.Manufacturer
ORDER BY Total_Spending DESC;
