### Data Description

*Please note that data used in the study are not uploaed onto github in view of confidentiality. 

The source data for this analysis is stored as Excel (`.xlsx`) spreadsheets in the folder named `data/`. There are two source datasets used:

#### 1. `dataset.xlsx`

This file contains de-identified data of **239 unique patients**, with **one row per patient**. Key variables are:

| Variable                       | Type      | Description                                                         |
|--------------------------------|-----------|---------------------------------------------------------------------|
| `id`                           | Character | Unique patient identifier                                           |
| `total_etel_dose`              | Numeric   | Total etelcalcetide dose (mg) over the 24-week study period         |
| `gender`                       | Factor    | female or male                                                      |
| `ethnicity`                    | Factor    | chinese or others                                                   |
| `age`                          | Numeric   | Age at etelcalcetide initiation                                     |
| `has_cvd`                      | Factor    | History of cardiovascular disease (1 = Yes, 0 = No)                 |
| `has_dm`                       | Factor    | History of type 2 diabetes (1 = Yes, 0 = No)                        |
| `has_htn`                      | Factor    | History of hypertension (1 = Yes, 0 = No)                           |
| `total_alfa_dose`              | Numeric   | Total alfacalcidol dose (mcg) over 24 weeks                         |
| `baseline_pth`, `endpoint_pth` | Numeric   | Intact parathyroid hormone (pmol/L) at baseline and week 24         |
| `baseline_ca`, `endpoint_ca`   | Numeric   | Serum calcium (mg/dL) at baseline and week 24                       |
| `baseline_po4`, `endpoint_po4` | Numeric   | Serum phosphate (mg/dL) at baseline and week 24                     |
| `baseline_sap`, `endpoint_sap` | Numeric   | Serum Alkaline phosphatase (u/L) at baseline and week 24            |
| `baseline_alb`                 | Numeric   | Albumin (g/dL) at baseline                                          |
| `baseline_hb`                  | Numeric   | Haemoglobin (g/dL) at baseline                                      |
| `adl`                          | Factor    | Activities of daily living: Independent or Dependent/Semi-Dependent |
| `vintage`                      | Numeric   | Years since dialysis initiation                                     |
| `vascular_access_type`         | Factor    | AVF (arteriovenous fistula),                                        |
|                                |           | AVG (arteriovenous graft) or                                        |
|                                |           | Perm Cath (permanent catheter)                                      |
| `primary_diagnosis`            | Factor    | Diabetes-related, GN/Presumed GN or Others                          |

#### 2. `dose_data.xlsx`

This file contains **repeated measures per patient**, with **one row per 4-week interval** (up to 24 weeks). Variables:

| Variable    | Type      | Description                                          |
|-------------|-----------|------------------------------------------------------|
| `id`        | Character | Patient identifier (matches `data_raw.xlsx`)         |
| `week`      | Factor    | 4-week intervals: 4, 8, 12, 16, 20, 24               |
| `week_dose` | Numeric   | Etelcalcetide dose (mg) received during the interval |
