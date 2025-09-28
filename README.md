# SQL Practice & Chicago Datasets Project

This repository contains my SQL learning journey, including:

- Practice exercises with **multiple-choice SQL questions** and guided solutions.
- Hands-on queries over real-world datasets from the City of Chicago.
- Creation of relational database schemas (e.g., HR database) to practice table design, keys, and relationships.
- Advanced SQL practice with views, complex `JOINs`, `UNION`, conditional logic (`CASE`), and data cleaning.
- Scripts and notes to reinforce concepts like `JOINs`, subqueries, `GROUP BY`, aggregation, filtering, and transaction control.

---

## 📂 Project Structure

- `scripts/` → SQL scripts and Python notebooks with queries.
- `datasets/` → Public datasets from [City of Chicago Open Data](https://data.cityofchicago.org/).
- `metadata.txt` → User-friendly description of the datasets.
- `README.md` → Project documentation.

---

## 📊 Datasets Used

1. **Crimes - 2001 to Present**  
   Reported incidents of crime in Chicago since 2001 (excluding the last 7 days).  
   Source: Chicago Police Department’s CLEAR system.  

2. **Chicago Public Schools - Progress Report Cards (2011–2012)**  
   Performance data for Chicago schools, including safety, environment, instruction, and student outcomes.  

3. **Socioeconomic Indicators and Hardship Index (2008–2012)**  
   Public health and economic indicators for each community area in Chicago, including a hardship index.
   
## 🔧 New Scripts Added
- **HR_Database_Create_Tables_Script.sql** — Builds a full HR relational schema with tables for employees, jobs, departments, and job history.
- **advanced_query_practice.sql** — Advanced practice on the HR schema, including creating/updating SQL views, complex filters, and aggregations.
- **more_advanced_queries.sql** — Complex queries on Chicago datasets with multi-table JOINs, UNION operations, and data analysis on hardship index and school/crime data.

Details in [`metadata.txt`](./metadata.txt).



