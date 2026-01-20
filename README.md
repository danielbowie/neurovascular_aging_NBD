# Analysis Code for **Neurovascular mechanisms of cognitive aging: Sex-related differences in the average progression of arteriosclerosis, white matter atrophy, and cognitive decline**

This repository contains the data analysis code used for the manuscript:

> Bowie, D., et al. (2024). *Neurovascular mechanisms of cognitive aging: Sex-related differences in the average progression of arteriosclerosis, white matter atrophy, and cognitive decline*. *Neurobiology of Disease*. https://doi.org/10.1016/j.nbd.2024.106653

## Overview

The scripts included here reflect the analysis pipeline used in the published paper. The code has been cleaned and modularized to enhance readability, transparency, and reproducibility. This includes:

- Modular scripts for data cleaning, processing, and statistical analysis
- Use of relative paths and standardized file structure
- Use of [`renv`](https://rstudio.github.io/renv/) to capture the R package environment
- Output figures are saved in `/figures/`, and rendered reports in `/reports/`


---

## Project Structure

```
neurovascular_aging_NBD/
├── data/ # Processed data
├── scripts/ # Data harmonization and merging
├── reports/ # R Markdown notebooks
├── figures/ # Saved ggplot figures
├── master_script.R # Main script to reproduce all analyses
├── renv.lock # Locked package versions for reproducibility
├── README.md # You're here
```

---

## Requirements

- R version: 4.3.1 (or compatible)
- RStudio recommended
- [`renv`](https://rstudio.github.io/renv/) for dependency management

To install `renv` (if not already installed):

```r
install.packages("renv")
```

---

## Getting Started

1. Clone or download the repository
2. Open the R Project (`.Rproj`) file
3. Use `renv::restore()` to recreate the package environment
4. Run scripts in the order specified in `master_script.R`

---

## Reproducibility Checklist

- Project opens via `.Rproj` file 
- `renv::restore()` runs without errors  
- `master_script.R` executes end-to-end without modification 
- Output figures and reports are saved in `figures/` and `reports/`  
- README includes project overview, instructions, and citation information  

---

## Reproducibility Note

While this repository closely reflects the original workflow and yields the same **statistical patterns and conclusions**, small numerical differences may arise when re-running the scripts—for example, a breakpoint estimate of 50 years instead of 51.

These differences are likely due to:
- Undocumented intermediate processing steps from the original analysis (conducted during my PhD)
- Version differences in packages or the R environment
- Random seed effects (e.g., in bootstrapped or iterative procedures)

These discrepancies are **minor** and do **not affect the published findings or interpretations**. This repository represents a cleaned and transparent version of the original analysis pipeline, updated to reflect best practices in reproducible research.

---

## Troubleshooting 

If renv::restore() fails due to archived or source-only packages, try installing them manually:

```r
renv::install("https://cran.r-project.org/src/contrib/Archive/segmented/segmented_2.0-0.tar.gz")
```

---

## Citation

If using or adapting this code, please cite the original paper:

> Bowie, D., et al. (2024). *Neurovascular mechanisms of cognitive aging: Sex-related differences in the average progression of arteriosclerosis, white matter atrophy, and cognitive decline*. *Neurobiology of Disease*. https://doi.org/10.1016/j.nbd.2024.106653

---

## Contact

If you have any questions about the analysis, feel free to reach out via daniel.christopher.bowie@gmail.com or open an issue on this repo.

---

## License

This code is released under the MIT License. See the LICENSE file for full terms.

