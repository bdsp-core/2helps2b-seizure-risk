# Data source & provenance — 2HELPS2B seizure-risk score (Struck et al., JAMA Neurol 2017)

## Paper
Struck AF, Ustun B, Ruiz AR, Lee JW, LaRoche SM, Hirsch LJ, Gilmore EJ, Vlachy J,
Haider HA, Rudin C, **Westover MB**. *Association of an Electroencephalography-Based Risk
Score With Seizure Probability in Hospitalized Patients.* **JAMA Neurol 2017;74(12):1419-1424.**
doi:10.1001/jamaneurol.2017.2459 · PMID 29052706. (The "2HELPS2B" score.)

## Committed data (de-identified)
- **`CCEMRCDATA.mat`** — the analysis table (5,742 continuous-EEG records × 119 coded
  variables): IIC-pattern indicators (LPD/GPD/LRDA/GRDA, BiRDs), frequency/prevalence
  features, clinical covariates (prior seizures, coma/reactivity), and the seizure outcome
  (`hasseizures`). **All variables are numeric/coded — no MRNs, names, or dates.**
  (PHI-scanned 2026-07-09: 0 identifier columns.)
- `CCEMRCDATA_NotTable.mat` — the same data as a plain matrix.
- `IIC_emory.xlsx` — IIC-frequency probability summary table.
- `Fig_*.png` — the committed seizure-probability curves by IIC pattern.

## Data ownership
Data are from the **Critical Care EEG Monitoring Research Consortium (CCEMRC)**, a multicenter
consortium whose de-identified data BDSP already hosts (cf. the multistate seizure-risk release).
No single-institution PHI is included.

## Raw -> derived lineage
Multicenter cEEG reports (CCEMRC) -> coded IIC-pattern + clinical feature table
(`CCEMRCDATA.mat`) -> LASSO/logistic feature selection + bootstrap AUC (`a_step2*`) ->
seizure-probability curves by pattern (`a_step3*`) -> the integer 2HELPS2B risk score.
