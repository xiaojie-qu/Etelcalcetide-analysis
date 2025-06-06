###  File Organization

#### `code/` -- R Scripts

| File Name               | Description                                            |
|-------------------------|--------------------------------------------------------|
| `00_RUN.R`              | Master script to execute all analysis steps in order.  |
| `1_table1.R`            | Generates Table 1 (baseline characteristics).          |
| `2_weighting.R`         | Creates the weighted cohort using propensity scores.   |
| `3_modelling.R`         | Runs Models 1-4 and produces model output.             |
| `4_dose_distribution.R` | Summarizes etelcalcetide dose at each 4-week interval. |
| `5_plots/`              | File containing plotting scripts                       |
| `function.R`            | User-defined functions for Table 1 and plotting.       |
| `model_function.R`      | Functions to organize and output model results.        |

#### `data/` -- Data Files

> **Note:** Data files are not shared publicly due to privacy considerations.

| File Name             | Description                            |
|-----------------------|----------------------------------------|
| `dataset.xlsx`        | De-identified patient data used for the analysis |
| `dose_data.xlsx`      | Dose data                          |
| `data_cleaned.xlsx`   | Cleaned and pre-processed dataset      |
| `data_for_model.xlsx` | Final dataset used for modelling       |

#### `output/` -- Generated Files (after running `00_RUN.R`)

| File Name                 | Description                                                                 |
|---------------------------|-----------------------------------------------------------------------------|
| `table1.html`             | HTML output of Table 1 (baseline characteristics).                          |
| `model_output.xlsx`       | Output of Models 1--4, used for Table 2 in the manuscript.                  |
| `smd.xlsx`                | Standardized mean differences before and after weighting.                   |
| `smd.png`                 | Plot of standardized mean differences.                                      |
| `week_dose_by_group.xlsx` | Dose group distribution every 4 weeks, stratified by initiation dose.       |
| `dose_dist_group.png`     | Graph of `week_dose_by_group.xlsx`.                                         |
| `week_dose_by_pth.xlsx`   | Dose group distribution every 4 weeks, stratified by baseline PTH category. |
| `dose_dist_pth.png`       | Graph of `week_dose_by_pth.xlsx`.                                           |
