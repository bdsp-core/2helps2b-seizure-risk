# Reproduce — 2HELPS2B (Struck et al., JAMA Neurol 2017)

MATLAB (R2016+, verified on R2026a) with the Statistics & Machine Learning Toolbox.
The bundled `glmnet_matlab/` provides LASSO. From the repo root:

```matlab
addpath('glmnet_matlab');
a_step1_prepareData                 % inspect the CCEMRCDATA table
a_step2_IIC_LLR_GetFeaturesAndAUC   % per-pattern LASSO features + bootstrap AUC
a_step3_IIC_LLR_ProbabilityCurves   % seizure-probability curves by IIC pattern (Fig_*)
a_step4_probit                      % probit fits
```

Quick check (no toolbox needed) — reproduces the paper's Table 1 seizure proportions:

```matlab
load CCEMRCDATA
sum(data.anyLRDA & data.hasseizures)/sum(data.anyLRDA)   % ~0.28  (paper: 0.28)
sum(data.anyGRDA & data.hasseizures)/sum(data.anyGRDA)   % ~0.13  (paper: 0.13)
```

| Paper item | Script | Input (committed) | Output |
|---|---|---|---|
| Table 1 (seizure proportion by pattern) | `a_step1`/inline | `CCEMRCDATA.mat` | proportions |
| Per-pattern AUC (bootstrap) | `a_step2_IIC_LLR_GetFeaturesAndAUC.m` | `CCEMRCDATA.mat` | `AUC_INDIVIDUAL_IIC_RESULTS` |
| Seizure-probability curves (LPD/GPD/LRDA/GRDA, IIC frequency) | `a_step3_IIC_LLR_ProbabilityCurves.m` | `CCEMRCDATA.mat` | `Fig_*_Probability.png` |
| Probit fits | `a_step4_probit.m` | `CCEMRCDATA.mat` | fits |

**Verified 2026-07-09:** `CCEMRCDATA.mat` reproduces the Table-1 seizure proportions
(LRDA 0.276, GRDA 0.132, 719/5742 seizures). The LASSO/curve steps require the bundled
`glmnet_matlab` on the path. The final integer risk score (RiskSLIM) is from Ustun & Rudin's
method; see the paper.
