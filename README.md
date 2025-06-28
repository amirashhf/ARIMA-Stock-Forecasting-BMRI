# 📈 Time Series Forecasting for Bank Mandiri (BMRI) Stock Price

![R](https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white)
![Time-Series](https://img.shields.io/badge/Time--Series-2B8CBE?style=for-the-badge&logo=influxdb&logoColor=white)
![ARIMA](https://img.shields.io/badge/ARIMA-Model-blue)

## 📖 Overview
The stock market is a complex and dynamic environment where prices fluctuate constantly. For investors, being able to forecast stock price movements is crucial for making informed decisions. This project focuses on developing a time series forecasting model to predict the stock price of PT Bank Mandiri (Persero) Tbk. (BMRI), one of the largest and most influential banks in Indonesia. The primary goal is to identify and optimize an ARIMA model to accurately forecast future stock prices based on historical data.

## 📊 Dataset
* **Data:** Historical monthly stock prices of PT Bank Mandiri (Persero) Tbk. (BMRI.JK).
* **Source:** Yahoo Finance.
* **Period:** August 2003 to May 2024.
* **Feature Used:** `Close` (monthly closing price).

## ⚙️ Project Workflow
The project follows the standard methodology for ARIMA modeling:

1.  **Data Preparation:** The historical data was loaded and cleaned, using only the `Close` price for the time series analysis.
2.  **Stationarity Check:** Initial analysis of the time series plot, ACF, and PACF showed a clear upward trend, indicating the data was non-stationary.
3.  **Transformation & Differencing:** To achieve stationarity, a **Box-Cox Transformation** (with an estimated lambda of 0.22) and **first-order differencing (d=1)** were applied. The Augmented Dickey-Fuller (ADF) test on the transformed data confirmed it was now stationary (p-value = 0.01).
4.  **Model Identification:** The EACF (Extended Autocorrelation Function) table was used to identify several potential ARIMA(p,d,q) model candidates.
5.  **Model Selection:** Six candidate models were compared based on AIC (Akaike Information Criterion) and BIC (Bayesian Information Criterion) values. The **ARIMA(3,1,2)** model was selected as it offered the best balance between model fit and complexity.
6.  **Model Diagnostics:** The residuals of the ARIMA(3,1,2) model were analyzed and passed the Ljung-Box test for independence, indicating no significant autocorrelation was left.
7.  **Forecasting:** The final ARIMA(3,1,2) model was used to forecast the stock prices for the next 5 months.

## 📈 Forecasting Results
The final model, **ARIMA(3,1,2) with drift**, was used to generate forecasts for the next five months.

![image](https://github.com/user-attachments/assets/680a20fa-9979-4445-ba8e-93e4d1e93fc1)

The forecast for the next 5 months is as follows:

| Forecast Period | Point Forecast | 80% CI | 95% CI |
|---|---|---|---|
| June 2024 | 5924.165 | [5431.107, 6451.616] | [5183.454, 6745.333] |
| July 2024 | 6044.665 | [5336.115, 6824.879] | [4988.364, 7268.642] |
| August 2024 | 6084.684 | [5251.839, 7017.600] | [4848.718, 7554.823] |
| September 2024| 6166.734 | [5223.448, 7238.517] | [4772.155, 7862.039] |
| October 2024| 6226.995 | [5198.800, 7408.056] | [4711.280, 8100.507] |

Table adapted from the project's forecasting results.
