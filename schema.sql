-- =========================================================
-- Pharmaceutical Sales & Market Performance Dashboard
-- Star Schema — SQL Data Model
-- =========================================================
-- Fact table: monthly spending/claims by drug, manufacturer, state
-- Dimension tables: drug attributes, manufacturer attributes
-- =========================================================

CREATE TABLE Dim_Manufacturer (
    Manufacturer_ID INTEGER PRIMARY KEY,
    Manufacturer     TEXT NOT NULL
);

CREATE TABLE Dim_Drug (
    Drug_ID               INTEGER PRIMARY KEY,
    Brand_Name             TEXT NOT NULL,
    Generic_Name            TEXT,
    Therapeutic_Category     TEXT
);

CREATE TABLE Fact_Spending (
    Date              TEXT,       -- first of month, e.g. 2022-01-01
    Drug_ID            INTEGER,
    Manufacturer_ID      INTEGER,
    State              TEXT,       -- 2-letter US state code
    Total_Spending       REAL,       -- CMS Medicare Part D spend, USD
    Total_Claims          INTEGER,
    Dosage_Units          INTEGER,
    FOREIGN KEY (Drug_ID) REFERENCES Dim_Drug(Drug_ID),
    FOREIGN KEY (Manufacturer_ID) REFERENCES Dim_Manufacturer(Manufacturer_ID)
);
