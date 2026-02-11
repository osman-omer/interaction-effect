# Project 4 — Interaction Effects in Regression (Insurance Dataset)

## 📌 Project Goal  
Learn how to model and interpret **interaction effects** in linear regression.  
The focus is on **methodology and understanding**, not on clinical or predictive inference.

## 📊 Dataset  
- Source: `insurance.csv`  
- Variables:  
  - `charges` (Insurance charges in USD)  
  - `age` (Years)  
  - `smoker` (Yes / No)  
  - `sex`, `region`, `bmi`, `children` (available but not main focus here)  

## 🧪 Analysis Overview  
- Data quality checks (`glimpse`, `summary`, missing values)  
- Convert categorical variables to factors (`smoker`, `sex`, `region`)  
- Exploratory Data Analysis (EDA):  
  - Summary statistics by smoker status  
  - Scatter plot: Age vs Charges by smoker  
- Regression models:  
  - Additive model: `charges ~ age + smoker`  
  - Interaction model: `charges ~ age * smoker`  
- Model comparison:  
  - ANOVA (nested models)  
  - R² & Adjusted R²  
  - AIC, BIC  
- Interpretation of interaction term  
- Predicted values by age and smoker status  
- Visualization of interaction (non-parallel regression lines)  

## 📈 Key Findings  
- **Age effect differs by smoking status** (different slopes for smokers vs non-smokers)  
- **Interaction model** explains slightly more variance than the additive model  
- R² improvement is small → interaction improves fit, but overall predictive power remains limited  
- Visual interaction (non-parallel lines) does **not always** imply statistical significance  

## 🧠 Key Concepts Demonstrated  
- **Interaction Term (`age * smoker`):**  
  Allows the effect of age on charges to vary between smokers and non-smokers  

- **Additive vs Interaction Models:**  
  - Additive → same age effect for everyone  
  - Interaction → different age effect per group  

- **Interpretation of Coefficients:**  
  - Intercept → baseline group (non-smoker at age 0)  
  - `age` → slope for non-smokers  
  - `smokeryes` → difference at baseline  
  - `age:smokeryes` → how much the slope changes for smokers  

- **Model Comparison:**  
  ANOVA, AIC, and BIC used to decide whether the interaction term is worth keeping  

## 🖼️ Visualization  
- Scatter plot with separate regression lines by smoker status  
- Predicted charges by age for smokers vs non-smokers  
- Coefficient comparison (additive vs interaction model)

  ![predicted charges](plots/prediction_plot.png)

## 📌 Conclusion  
This project is a **learning exercise** focused on understanding interaction terms in regression:

- Interaction terms capture **effect modification** (different relationships across groups).  
- Visual patterns must be confirmed with **formal statistical tests**.  
- The project highlights the difference between **model complexity** and **practical gain**.  
- Entirely methodological — **not intended for clinical or predictive use**.  

> Key takeaway: Interaction terms are essential when relationships differ across subgroups, especially in medical and social data.
