# NYC Yellow Taxi End-to-End Data Engineering Pipeline in Microsoft Fabric

A full-stack, enterprise-grade data engineering solution built on **Microsoft Fabric**. This project ingests, cleanses, orchestrates, and visualizes 2026 New York City Yellow Taxi ride datasets using a medallion-inspired architecture (**Lakehouse ➔ Staging Data Warehouse ➔ Presentation Layer ➔ Direct Lake Power BI Report**).

---

## 🛠️ Architecture & Data Flow

[Parquet / CSV Files]
│
▼

LAKEHOUSE (Landing Zone)
│
▼ (Data Factory Pipeline + Metadata-Driven Loop)

DATA WAREHOUSE — Staging Layer (STG.NYC_Taxi_Yellow)
│
▼ (T-SQL Stored Procedure Engine)

DATA WAREHOUSE — Presentation Layer (dbo.NYC_Taxi_Yellow)
│
▼ (Direct Lake Mode)

POWER BI REPORT (Executive Dashboard)


---

## 🎯 Key Capabilities & Engineering Highlights

* **Metadata-Driven Incremental Ingestion:** Dynamically detects the last processed month using a T-SQL logging table (`metadata.processing_log`) and ingests only new incremental batches without hardcoding dates.
* **T-SQL Performance Optimization:** Replaced initial Dataflows Gen2 transformation step with a T-SQL Stored Procedure (`dbo.Process_Presentation`), cutting transformation time from **~3 minutes down to 32 seconds**.
* **Data Cleansing & Outlier Filtering:** Automatically purges timestamp anomalies and out-of-bounds records per monthly batch inside the staging pipeline (`dbo.Data_Cleaning_STG`).
* **Audit & Logging Framework:** Captures execution logs, row counts, run IDs, and processing timestamps in real time for operational monitoring.
* **Direct Lake Visualization:** Connects Power BI directly to the Gold presentation layer for ultra-low latency interactive reporting without data replication.

---

## 📐 Pipeline Components

### 1. Ingestion & Storage (Lakehouse)
* Monthly 2024 NYC Taxi Parquet datasets stored in the **Fabric Lakehouse** (`Files` section).
* Dimension lookup table (`taxi_zone_lookup.csv`) uploaded for geographical mapping (Boroughs and Zones).

### 2. Staging Layer (`PL_Stage_Processing_NYC_Taxi`)
* Executes a `Script Activity` querying `metadata.processing_log` to derive the next processing month dynamically.
* Runs a `Copy Data` activity transferring monthly Parquet files into `STG.NYC_Taxi_Yellow`.
* Invokes `STG.Data_Cleaning_STG` to eliminate out-of-range timestamps.

### 3. Presentation Layer (`dbo.Process_Presentation`)
* Enriches transactional records with vendor mappings (e.g., *Creative Mobile Technologies*, *Verifone*) and payment types (e.g., *Credit Card*, *Cash*).
* Performs `LEFT JOIN` operations against taxi zone lookup tables to map Pickup/Dropoff Location IDs to official Boroughs and Zones.

### 4. Master Orchestration (`PL_Orchestrate_NYC_Taxi`)
* End-to-end master pipeline chaining staging ingestion, data validation, presentation transformation, and logging using `Invoke Pipeline` activities.

---

## 📊 Analytics & BI Features

The Power BI dashboard displays:
* **Core KPIs:** Total Revenue ($ USD), Total Trips, Total Passengers.
* **Trend Analysis:** Daily Revenue breakdown by Payment Method.
* **Geographical Insights:** Top pickup-to-dropoff zone routes by volume and earnings.
* **Slicers:** Date ranges, Vendor IDs, and Payment Methods.

---

## 🛠️ Technology Stack

* **Platform:** Microsoft Fabric
* **Storage:** OneLake / Lakehouse (Delta Parquet, CSV)
* **Compute / Warehouse:** Fabric Data Warehouse (T-SQL Stored Procedures)
* **Orchestration:** Fabric Data Factory Pipelines
* **BI / Analytics:** Power BI (Direct Lake Mode)

---

## 🛠️ Workflow (Images)

### Workspace
 ![image alt](https://github.com/darikson-creator/nyctaxi-yellow-end-to-end-project/blob/91cb5fabf2fa5c8e926dc282241ca3e0949f9188/1.%20Workspace.png)
 
### Lakehouse
 ![image alt](https://github.com/darikson-creator/nyctaxi-yellow-end-to-end-project/blob/515a4ac9816460a394aa5b40715ee43acc34d5c4/2.%20Lakehouse.png)
 
### Warehouse
 ![image alt](https://github.com/darikson-creator/nyctaxi-yellow-end-to-end-project/blob/515a4ac9816460a394aa5b40715ee43acc34d5c4/3.%20warehouse.png)
 
### Pipelines
 ![image alt](https://github.com/darikson-creator/nyctaxi-yellow-end-to-end-project/blob/515a4ac9816460a394aa5b40715ee43acc34d5c4/4.%20Pipelines.png)
 
### Dataflow-Gen2
![image alt](https://github.com/darikson-creator/nyctaxi-yellow-end-to-end-project/blob/515a4ac9816460a394aa5b40715ee43acc34d5c4/5.%20Dataflow%20Gen2.png)

### Staging Pipeline
![image alt](https://github.com/darikson-creator/nyctaxi-yellow-end-to-end-project/blob/515a4ac9816460a394aa5b40715ee43acc34d5c4/6.%20Staging%20Pipeline.png)

### Presentation Pipeline
![image alt](https://github.com/darikson-creator/nyctaxi-yellow-end-to-end-project/blob/515a4ac9816460a394aa5b40715ee43acc34d5c4/7.%20Presentation%20Pipeline.png)

### Orchestration Pipeline
![image alt](https://github.com/darikson-creator/nyctaxi-yellow-end-to-end-project/blob/515a4ac9816460a394aa5b40715ee43acc34d5c4/8.%20Orchestrate%20Pipeline.png)

### PBI Report
![image alt](https://github.com/darikson-creator/nyctaxi-yellow-end-to-end-project/blob/515a4ac9816460a394aa5b40715ee43acc34d5c4/9.%20Report.png)


