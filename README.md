# 2HELPS2B: an EEG-based seizure-risk score for hospitalized patients

MATLAB code and de-identified data for:

> Struck AF, Ustun B, Ruiz AR, Lee JW, LaRoche SM, Hirsch LJ, Gilmore EJ, Vlachy J,
> Haider HA, Rudin C, **Westover MB**. *Association of an Electroencephalography-Based
> Risk Score With Seizure Probability in Hospitalized Patients.* **JAMA Neurol
> 2017;74(12):1419-1424.** [doi:10.1001/jamaneurol.2017.2459](https://doi.org/10.1001/jamaneurol.2017.2459) · PMID 29052706

Analysis behind the **2HELPS2B** score: seizure probability as a function of ictal-interictal
continuum (IIC) EEG patterns (LPD, GPD, LRDA, GRDA, BiRDs), pattern frequency, prior seizures,
and brief rhythmic discharges, in 5,742 continuous-EEG records from the Critical Care EEG
Monitoring Research Consortium.

## Reproduce

MATLAB R2016+ with the Statistics & ML Toolbox; LASSO via the bundled `glmnet_matlab/`.
See **[REPRODUCE.md](REPRODUCE.md)** and **[DATA_SOURCE.md](DATA_SOURCE.md)**.

```matlab
addpath('glmnet_matlab'); a_step3_IIC_LLR_ProbabilityCurves
```

## Data

`CCEMRCDATA.mat` — 5,742 × 119 coded table; **no MRNs, names, or dates**. CCEMRC multicenter
data. See [DATA_SOURCE.md](DATA_SOURCE.md).

## License

See LICENSE (BDSP credentialed data terms).
